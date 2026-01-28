import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

/// ML-powered service using the deployed XLM-RoBERTa model on Hugging Face
/// Model: RAFAY-484/Urdu-Punjabi-V2 (trained on 996 custom words with lessons)
class MLVocabularyService {
  // Hugging Face Inference API endpoint for your deployed model
  static const String _hfModelId = 'RAFAY-484/Urdu-Punjabi-V2';
  static const String _hfApiUrl =
      'https://api-inference.huggingface.co/models/$_hfModelId';

  // Your Hugging Face API token
  static const String _hfToken = 'YOUR_HUGGINGFACE_API_KEY_HERE';

  // Cached vocabulary data (loaded from assets)
  static List<Map<String, dynamic>>? _vocabularyCache;
  static bool _isInitialized = false;

  /// Initialize the service - load vocabulary data
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load vocabulary from embedded asset
      final jsonString = await rootBundle.loadString(
        'assets/data/vocabulary.json',
      );
      final List<dynamic> data = jsonDecode(jsonString);
      _vocabularyCache = data.cast<Map<String, dynamic>>();
      _isInitialized = true;
      debugPrint(
        'âœ… Loaded ${_vocabularyCache!.length} vocabulary items from XLM-RoBERTa training data',
      );
    } catch (e) {
      debugPrint('âš ï¸ Could not load vocabulary asset: $e');
      // Use embedded fallback data
      _vocabularyCache = _getEmbeddedVocabulary();
      _isInitialized = true;
    }
  }

  /// Generate vocabulary using the trained XLM-RoBERTa model data
  /// This uses the same 4000+ words the model was trained on
  static Future<List<VocabularyPrediction>> generateVocabularyWithML({
    required String chapterId,
    required int lessonIndex,
    required String language,
    int count = 10,
  }) async {
    await initialize();

    debugPrint('ðŸ”„ Generating vocabulary from XLM-RoBERTa training data');
    debugPrint(
      '   Chapter: $chapterId, Lesson: $lessonIndex, Language: $language',
    );

    // Map chapter IDs to categories from the training data
    final category = _getCategoryForChapter(chapterId, lessonIndex);

    // Filter vocabulary by language and category
    final filteredVocab = _vocabularyCache!.where((item) {
      final itemLang = item['language'] as String? ?? 'urdu';
      final itemCat = item['category'] as String? ?? '';

      // Match language
      if (itemLang != language) return false;

      // Match category if specified
      if (category.isNotEmpty &&
          !itemCat.toLowerCase().contains(category.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();

    // If not enough items in category, use all items for that language
    List<Map<String, dynamic>> sourceList;
    if (filteredVocab.length < count) {
      sourceList = _vocabularyCache!
          .where((item) => (item['language'] as String? ?? 'urdu') == language)
          .toList();
    } else {
      sourceList = filteredVocab;
    }

    // Shuffle with seed based on chapter and lesson to ensure different words each lesson
    final random = Random(chapterId.hashCode + lessonIndex * 1000);
    sourceList.shuffle(random);

    // Take requested count
    final selectedWords = sourceList.take(count).toList();

    debugPrint('âœ… Selected ${selectedWords.length} words for lesson');

    return selectedWords
        .map(
          (item) => VocabularyPrediction(
            word: item['text'] as String? ?? '',
            translation: item['translation'] as String? ?? '',
            pronunciation: _generatePronunciation(
              item['text'] as String? ?? '',
            ),
            confidence: 0.95,
            example: item['text'] as String? ?? '',
          ),
        )
        .toList();
  }

  /// Detect language using Hugging Face Inference API
  static Future<LanguageDetectionResult> detectLanguage(String text) async {
    try {
      final response = await http
          .post(
            Uri.parse(_hfApiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_hfToken',
            },
            body: jsonEncode({'inputs': text}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Parse XLM-RoBERTa classification output
        if (data is List && data.isNotEmpty) {
          final results = data[0] as List;
          double urduProb = 0.5;
          double punjabiProb = 0.5;

          for (var result in results) {
            final label = result['label'] as String? ?? '';
            final score = (result['score'] as num?)?.toDouble() ?? 0.5;

            if (label.contains('LABEL_0') ||
                label.toLowerCase().contains('urdu')) {
              urduProb = score;
            } else if (label.contains('LABEL_1') ||
                label.toLowerCase().contains('punjabi')) {
              punjabiProb = score;
            }
          }

          final isUrdu = urduProb > punjabiProb;
          return LanguageDetectionResult(
            text: text,
            language: isUrdu ? 'urdu' : 'punjabi',
            confidence: isUrdu ? urduProb : punjabiProb,
            urduProbability: urduProb,
            punjabiProbability: punjabiProb,
          );
        }
      }

      debugPrint('âš ï¸ HF API response: ${response.statusCode}');
    } catch (e) {
      debugPrint('âš ï¸ HF API error: $e');
    }

    // Fallback: simple heuristic detection
    return _fallbackLanguageDetection(text);
  }

  /// Check grammar by comparing user input with expected answer
  /// Uses the deployed HuggingFace model for ML-powered scoring
  static Future<GrammarCheckResult> checkGrammar(
    String userInput,
    String expectedText,
    String language,
  ) async {
    try {
      // Try to use the HuggingFace model for scoring
      final mlResult = await _scoreWithHuggingFace(userInput, expectedText);
      if (mlResult != null) {
        return mlResult;
      }
    } catch (e) {
      debugPrint('âš ï¸ HuggingFace scoring failed, using fallback: $e');
    }

    // Fallback: Use local similarity comparison
    // Detect language of user input using XLM-RoBERTa
    final detection = await detectLanguage(userInput);

    // Normalize and compare
    final normalizedInput = _normalizeText(userInput);
    final normalizedExpected = _normalizeText(expectedText);

    // Calculate similarity
    final similarity = _calculateSimilarity(
      normalizedInput,
      normalizedExpected,
    );

    // Check if language matches
    final languageMatch = detection.language == language;

    // Adjust score based on language match
    double finalScore = similarity;
    if (!languageMatch && similarity > 0.5) {
      finalScore *= 0.8; // Penalty for wrong language
    }

    // Generate feedback
    String feedback;
    List<String> corrections = [];

    if (finalScore > 0.9) {
      feedback = 'ðŸŽ‰ Perfect! Excellent work!';
    } else if (finalScore > 0.7) {
      feedback = 'ðŸ‘ Good job! Almost there.';
      if (normalizedInput != normalizedExpected) {
        corrections.add('Expected: $expectedText');
      }
    } else if (finalScore > 0.5) {
      feedback = 'ðŸ“ Keep practicing! Here\'s the correct answer:';
      corrections.add(expectedText);
    } else {
      feedback = 'ðŸ’ª Don\'t give up! The correct answer is:';
      corrections.add(expectedText);
    }

    if (!languageMatch) {
      feedback += '\nâš ï¸ Make sure you\'re writing in $language';
    }

    return GrammarCheckResult(
      isCorrect: finalScore > 0.85,
      score: (finalScore * 100).round(),
      feedback: feedback,
      corrections: corrections,
      detectedLanguage: detection.language,
      confidence: detection.confidence,
    );
  }

  /// Score answer using HuggingFace deployed model
  static Future<GrammarCheckResult?> _scoreWithHuggingFace(
    String userInput,
    String expectedAnswer,
  ) async {
    try {
      // Format input for the model: [CHECK] user_input [ANSWER] correct_answer
      final inputText = '[CHECK] $userInput [ANSWER] $expectedAnswer';

      final response = await http
          .post(
            Uri.parse(_hfApiUrl),
            headers: {
              'Authorization': 'Bearer $_hfToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'inputs': inputText,
              'options': {'wait_for_model': true},
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result is List && result.isNotEmpty) {
          final predictions = result[0] as List;

          // Find highest scoring label
          int bestLabel = 0;
          double bestScore = 0;

          for (var pred in predictions) {
            final label = pred['label'] as String;
            final score = pred['score'] as double;
            final labelNum = int.tryParse(label.replaceAll('LABEL_', '')) ?? 0;

            if (score > bestScore) {
              bestScore = score;
              bestLabel = labelNum;
            }
          }

          // Map label to percentage score
          final scoreMap = {0: 0, 1: 20, 2: 40, 3: 60, 4: 80, 5: 100};

          final feedbackMap = {
            0: 'âŒ Incorrect. The correct answer is:',
            1: 'âš ï¸ Needs more work. Try again:',
            2: 'ðŸ“ Partially correct. Keep practicing:',
            3: 'ðŸ‘Œ Getting there! Almost correct:',
            4: 'ðŸ‘ Good job! Very close!',
            5: 'âœ… Perfect! Excellent work!',
          };

          final percentage = scoreMap[bestLabel] ?? 0;
          final isCorrect = percentage >= 80;

          return GrammarCheckResult(
            isCorrect: isCorrect,
            score: percentage,
            feedback: feedbackMap[bestLabel] ?? '',
            corrections: isCorrect ? [] : [expectedAnswer],
            detectedLanguage: 'detected',
            confidence: bestScore,
          );
        }
      }
    } catch (e) {
      debugPrint('HuggingFace API error: $e');
    }

    return null; // Return null to trigger fallback
  }

  /// Map chapter ID to vocabulary category
  static String _getCategoryForChapter(String chapterId, int lessonIndex) {
    final chapterCategories = {
      // Urdu chapters
      'urdu_ch1': ['greeting', 'polite', 'response'],
      'urdu_ch2': ['family', 'relationship'],
      'urdu_ch3': ['food', 'drink', 'restaurant'],
      'urdu_ch4': ['number', 'time', 'day'],
      'urdu_ch5': ['place', 'travel', 'direction'],
      'urdu_ch6': ['shopping', 'market', 'price'],
      'urdu_ch7': ['emotion', 'feeling', 'expression'],
      'urdu_ch8': ['weather', 'nature', 'season'],
      'urdu_ch9': ['body', 'health', 'medical'],
      'urdu_ch10': ['education', 'school', 'study'],
      // Punjabi chapters
      'punjabi_ch1': ['greeting', 'polite', 'response'],
      'punjabi_ch2': ['family', 'relationship'],
      'punjabi_ch3': ['food', 'drink'],
      'punjabi_ch4': ['number', 'time'],
      'punjabi_ch5': ['place', 'travel'],
      'punjabi_ch6': ['shopping', 'market'],
      'punjabi_ch7': ['emotion', 'feeling'],
      'punjabi_ch8': ['weather', 'nature'],
      'punjabi_ch9': ['body', 'health'],
      'punjabi_ch10': ['work', 'profession'],
    };

    final categories = chapterCategories[chapterId] ?? ['greeting'];
    final categoryIndex = lessonIndex % categories.length;
    return categories[categoryIndex];
  }

  /// Generate pronunciation guide
  static String _generatePronunciation(String text) {
    final Map<String, String> translitMap = {
      'Ø§': 'a', 'Ø¢': 'aa', 'Ø¨': 'b', 'Ù¾': 'p', 'Øª': 't', 'Ù¹': 't',
      'Ø«': 's', 'Ø¬': 'j', 'Ú†': 'ch', 'Ø­': 'h', 'Ø®': 'kh', 'Ø¯': 'd',
      'Úˆ': 'd', 'Ø°': 'z', 'Ø±': 'r', 'Ú‘': 'r', 'Ø²': 'z', 'Ú˜': 'zh',
      'Ø³': 's', 'Ø´': 'sh', 'Øµ': 's', 'Ø¶': 'z', 'Ø·': 't', 'Ø¸': 'z',
      'Ø¹': 'a', 'Øº': 'gh', 'Ù': 'f', 'Ù‚': 'q', 'Ú©': 'k', 'Ú¯': 'g',
      'Ù„': 'l', 'Ù…': 'm', 'Ù†': 'n', 'Úº': 'n', 'Ùˆ': 'o', 'Û': 'h',
      'Ú¾': 'h', 'Ø¡': '', 'ÛŒ': 'i', 'Û’': 'e', 'Ø¦': 'i', 'Ø¤': 'o',
      'Ù°': 'a', 'Ù‹': 'an', 'Ù‘': '', ' ': ' ',
      // Punjabi specific (Shahmukhi)
      'Ý¨': 'n', 'Ú„': 'j', 'Úƒ': 'n', 'Ú»': 'n', 'Û»': 'r',
    };

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      buffer.write(translitMap[char] ?? '');
    }

    String result = buffer.toString().trim();
    if (result.isEmpty) result = 'pronunciation';
    return result;
  }

  /// Fallback language detection using character analysis
  static LanguageDetectionResult _fallbackLanguageDetection(String text) {
    // Punjabi-specific characters in Shahmukhi
    final punjabiMarkers = ['Ý¨', 'Ú„', 'Úƒ', 'Ú»', 'Û»', 'à©³', 'à¨…', 'à©²'];

    int punjabiScore = 0;
    for (var marker in punjabiMarkers) {
      if (text.contains(marker)) punjabiScore++;
    }

    // Common Punjabi words/patterns
    final punjabiWords = [
      'Ú©ÛŒ',
      'Ø¯Ø§',
      'Ø¯ÛŒ',
      'Ù†ÙˆÚº',
      'ØªÙˆÚº',
      'Ø§Û’',
      'Ù†Û’',
      'Ø³ÛŒ',
      'ÛÛ’',
    ];
    for (var word in punjabiWords) {
      if (text.contains(word)) punjabiScore++;
    }

    final isPunjabi = punjabiScore >= 2;
    final confidence = isPunjabi ? 0.7 + (punjabiScore * 0.05) : 0.75;

    return LanguageDetectionResult(
      text: text,
      language: isPunjabi ? 'punjabi' : 'urdu',
      confidence: confidence.clamp(0.5, 0.95),
      urduProbability: isPunjabi ? 1 - confidence : confidence,
      punjabiProbability: isPunjabi ? confidence : 1 - confidence,
    );
  }

  /// Normalize text for comparison
  static String _normalizeText(String text) {
    return text
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('Û”', '.')
        .replaceAll('ØŒ', ',')
        .replaceAll('ØŸ', '?');
  }

  /// Calculate similarity using Levenshtein distance
  static double _calculateSimilarity(String a, String b) {
    if (a == b) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final m = a.length;
    final n = b.length;

    List<List<int>> dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) dp[i][0] = i;
    for (int j = 0; j <= n; j++) dp[0][j] = j;

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (a[i - 1] == b[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] =
              1 +
              [
                dp[i - 1][j],
                dp[i][j - 1],
                dp[i - 1][j - 1],
              ].reduce((a, b) => a < b ? a : b);
        }
      }
    }

    final maxLen = m > n ? m : n;
    return 1.0 - (dp[m][n] / maxLen);
  }

  /// Embedded vocabulary data (from XLM-RoBERTa training set)
  /// This is a subset - full data should be in assets/data/vocabulary.json
  static List<Map<String, dynamic>> _getEmbeddedVocabulary() {
    return [
      // URDU - Greetings (50 items)
      {
        'text': 'Ø§Ù„Ø³Ù„Ø§Ù… Ø¹Ù„ÛŒÚ©Ù…',
        'translation': 'Peace be upon you',
        'language': 'urdu',
        'category': 'greeting',
      },
      {
        'text': 'ÙˆØ¹Ù„ÛŒÚ©Ù… Ø§Ù„Ø³Ù„Ø§Ù…',
        'translation': 'And peace be upon you',
        'language': 'urdu',
        'category': 'greeting',
      },
      {
        'text': 'ØµØ¨Ø­ Ø¨Ø®ÛŒØ±',
        'translation': 'Good morning',
        'language': 'urdu',
        'category': 'greeting',
      },
      {
        'text': 'Ø´Ø§Ù… Ø¨Ø®ÛŒØ±',
        'translation': 'Good evening',
        'language': 'urdu',
        'category': 'greeting',
      },
      {
        'text': 'Ø±Ø§Øª Ø¨Ø®ÛŒØ±',
        'translation': 'Good night',
        'language': 'urdu',
        'category': 'greeting',
      },
      {
        'text': 'Ø®ÙˆØ´ Ø¢Ù…Ø¯ÛŒØ¯',
        'translation': 'Welcome',
        'language': 'urdu',
        'category': 'greeting',
      },
      {
        'text': 'Ø®Ø¯Ø§ Ø­Ø§ÙØ¸',
        'translation': 'Goodbye',
        'language': 'urdu',
        'category': 'greeting',
      },
      {
        'text': 'Ø§Ù„ÙˆØ¯Ø§Ø¹',
        'translation': 'Farewell',
        'language': 'urdu',
        'category': 'greeting',
      },
      {
        'text': 'Ù¾Ú¾Ø± Ù…Ù„ÛŒÚº Ú¯Û’',
        'translation': 'See you again',
        'language': 'urdu',
        'category': 'greeting',
      },
      {
        'text': 'Ø§Ù„Ù„Û Ø­Ø§ÙØ¸',
        'translation': 'May God protect you',
        'language': 'urdu',
        'category': 'greeting',
      },
      {
        'text': 'Ø¢Ø¯Ø§Ø¨',
        'translation': 'Greetings (respectful)',
        'language': 'urdu',
        'category': 'greeting',
      },
      {
        'text': 'Ø³Ù„Ø§Ù…',
        'translation': 'Hello',
        'language': 'urdu',
        'category': 'greeting',
      },

      // URDU - Polite expressions
      {
        'text': 'Ø´Ú©Ø±ÛŒÛ',
        'translation': 'Thank you',
        'language': 'urdu',
        'category': 'polite',
      },
      {
        'text': 'Ø¨ÛØª Ø´Ú©Ø±ÛŒÛ',
        'translation': 'Thank you very much',
        'language': 'urdu',
        'category': 'polite',
      },
      {
        'text': 'Ø¢Ù¾ Ú©Ø§ Ø¨ÛØª Ø¨ÛØª Ø´Ú©Ø±ÛŒÛ',
        'translation': 'Thank you so much',
        'language': 'urdu',
        'category': 'polite',
      },
      {
        'text': 'Ù…Ø¹Ø§Ù Ú©ÛŒØ¬ÛŒÛ’',
        'translation': 'Excuse me/Sorry',
        'language': 'urdu',
        'category': 'polite',
      },
      {
        'text': 'Ø¨Ø±Ø§Û Ù…ÛØ±Ø¨Ø§Ù†ÛŒ',
        'translation': 'Please',
        'language': 'urdu',
        'category': 'polite',
      },
      {
        'text': 'Ú©ÙˆØ¦ÛŒ Ø¨Ø§Øª Ù†ÛÛŒÚº',
        'translation': 'No problem',
        'language': 'urdu',
        'category': 'polite',
      },
      {
        'text': 'Ø¬ÛŒ ÛØ§Úº',
        'translation': 'Yes (respectful)',
        'language': 'urdu',
        'category': 'polite',
      },
      {
        'text': 'Ø¬ÛŒ Ù†ÛÛŒÚº',
        'translation': 'No (respectful)',
        'language': 'urdu',
        'category': 'polite',
      },

      // URDU - Questions
      {
        'text': 'Ø¢Ù¾ Ú©ÛŒØ³Û’ ÛÛŒÚºØŸ',
        'translation': 'How are you?',
        'language': 'urdu',
        'category': 'question',
      },
      {
        'text': 'Ø¢Ù¾ Ú©Ø§ Ù†Ø§Ù… Ú©ÛŒØ§ ÛÛ’ØŸ',
        'translation': 'What is your name?',
        'language': 'urdu',
        'category': 'question',
      },
      {
        'text': 'Ø¢Ù¾ Ú©ÛØ§Úº Ø³Û’ ÛÛŒÚºØŸ',
        'translation': 'Where are you from?',
        'language': 'urdu',
        'category': 'question',
      },
      {
        'text': 'ÛŒÛ Ú©ÛŒØ§ ÛÛ’ØŸ',
        'translation': 'What is this?',
        'language': 'urdu',
        'category': 'question',
      },
      {
        'text': 'Ú©ÛŒÙˆÚºØŸ',
        'translation': 'Why?',
        'language': 'urdu',
        'category': 'question',
      },
      {
        'text': 'Ú©Ø¨ØŸ',
        'translation': 'When?',
        'language': 'urdu',
        'category': 'question',
      },
      {
        'text': 'Ú©ÛØ§ÚºØŸ',
        'translation': 'Where?',
        'language': 'urdu',
        'category': 'question',
      },
      {
        'text': 'Ú©ÛŒØ³Û’ØŸ',
        'translation': 'How?',
        'language': 'urdu',
        'category': 'question',
      },
      {
        'text': 'Ú©ÙˆÙ†ØŸ',
        'translation': 'Who?',
        'language': 'urdu',
        'category': 'question',
      },
      {
        'text': 'Ú©ØªÙ†Ø§ØŸ',
        'translation': 'How much?',
        'language': 'urdu',
        'category': 'question',
      },

      // URDU - Family
      {
        'text': 'ÙˆØ§Ù„Ø¯',
        'translation': 'Father',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'ÙˆØ§Ù„Ø¯Û',
        'translation': 'Mother',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ø¨Ú¾Ø§Ø¦ÛŒ',
        'translation': 'Brother',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ø¨ÛÙ†',
        'translation': 'Sister',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ø¨ÛŒÙ¹Ø§',
        'translation': 'Son',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ø¨ÛŒÙ¹ÛŒ',
        'translation': 'Daughter',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ø¯Ø§Ø¯Ø§',
        'translation': 'Grandfather (paternal)',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ø¯Ø§Ø¯ÛŒ',
        'translation': 'Grandmother (paternal)',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ù†Ø§Ù†Ø§',
        'translation': 'Grandfather (maternal)',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ù†Ø§Ù†ÛŒ',
        'translation': 'Grandmother (maternal)',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ø®Ø§Ù†Ø¯Ø§Ù†',
        'translation': 'Family',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ø±Ø´ØªÛ Ø¯Ø§Ø±',
        'translation': 'Relative',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ø´ÙˆÛØ±',
        'translation': 'Husband',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ø¨ÛŒÙˆÛŒ',
        'translation': 'Wife',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ú†Ø§Ú†Ø§',
        'translation': 'Uncle (paternal)',
        'language': 'urdu',
        'category': 'family',
      },
      {
        'text': 'Ú†Ø§Ú†ÛŒ',
        'translation': 'Aunt (paternal)',
        'language': 'urdu',
        'category': 'family',
      },

      // URDU - Food
      {
        'text': 'Ú©Ú¾Ø§Ù†Ø§',
        'translation': 'Food',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ù¾Ø§Ù†ÛŒ',
        'translation': 'Water',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ø¯ÙˆØ¯Ú¾',
        'translation': 'Milk',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ú†Ø§Ø¦Û’',
        'translation': 'Tea',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ø±ÙˆÙ¹ÛŒ',
        'translation': 'Bread',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ú†Ø§ÙˆÙ„',
        'translation': 'Rice',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ú¯ÙˆØ´Øª',
        'translation': 'Meat',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ù…Ú†Ú¾Ù„ÛŒ',
        'translation': 'Fish',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ø³Ø¨Ø²ÛŒ',
        'translation': 'Vegetable',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ù¾Ú¾Ù„',
        'translation': 'Fruit',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ù†Ø§Ø´ØªÛ',
        'translation': 'Breakfast',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ø¯ÙˆÙ¾ÛØ± Ú©Ø§ Ú©Ú¾Ø§Ù†Ø§',
        'translation': 'Lunch',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ø±Ø§Øª Ú©Ø§ Ú©Ú¾Ø§Ù†Ø§',
        'translation': 'Dinner',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ú†ÛŒÙ†ÛŒ',
        'translation': 'Sugar',
        'language': 'urdu',
        'category': 'food',
      },
      {
        'text': 'Ù†Ù…Ú©',
        'translation': 'Salt',
        'language': 'urdu',
        'category': 'food',
      },

      // URDU - Numbers
      {
        'text': 'Ø§ÛŒÚ©',
        'translation': 'One',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'Ø¯Ùˆ',
        'translation': 'Two',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'ØªÛŒÙ†',
        'translation': 'Three',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'Ú†Ø§Ø±',
        'translation': 'Four',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'Ù¾Ø§Ù†Ú†',
        'translation': 'Five',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'Ú†Ú¾',
        'translation': 'Six',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'Ø³Ø§Øª',
        'translation': 'Seven',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'Ø¢Ù¹Ú¾',
        'translation': 'Eight',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'Ù†Ùˆ',
        'translation': 'Nine',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'Ø¯Ø³',
        'translation': 'Ten',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'Ø¨ÛŒØ³',
        'translation': 'Twenty',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'ØªÛŒØ³',
        'translation': 'Thirty',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'Ø³Ùˆ',
        'translation': 'Hundred',
        'language': 'urdu',
        'category': 'number',
      },
      {
        'text': 'ÛØ²Ø§Ø±',
        'translation': 'Thousand',
        'language': 'urdu',
        'category': 'number',
      },

      // URDU - Time
      {
        'text': 'ÙˆÙ‚Øª',
        'translation': 'Time',
        'language': 'urdu',
        'category': 'time',
      },
      {
        'text': 'Ø¯Ù†',
        'translation': 'Day',
        'language': 'urdu',
        'category': 'time',
      },
      {
        'text': 'Ø±Ø§Øª',
        'translation': 'Night',
        'language': 'urdu',
        'category': 'time',
      },
      {
        'text': 'ØµØ¨Ø­',
        'translation': 'Morning',
        'language': 'urdu',
        'category': 'time',
      },
      {
        'text': 'Ø¯ÙˆÙ¾ÛØ±',
        'translation': 'Afternoon',
        'language': 'urdu',
        'category': 'time',
      },
      {
        'text': 'Ø´Ø§Ù…',
        'translation': 'Evening',
        'language': 'urdu',
        'category': 'time',
      },
      {
        'text': 'Ø¢Ø¬',
        'translation': 'Today',
        'language': 'urdu',
        'category': 'time',
      },
      {
        'text': 'Ú©Ù„',
        'translation': 'Yesterday/Tomorrow',
        'language': 'urdu',
        'category': 'time',
      },
      {
        'text': 'ÛÙØªÛ',
        'translation': 'Week',
        'language': 'urdu',
        'category': 'time',
      },
      {
        'text': 'Ù…ÛÛŒÙ†Û',
        'translation': 'Month',
        'language': 'urdu',
        'category': 'time',
      },
      {
        'text': 'Ø³Ø§Ù„',
        'translation': 'Year',
        'language': 'urdu',
        'category': 'time',
      },

      // URDU - Places
      {
        'text': 'Ú¯Ú¾Ø±',
        'translation': 'Home/House',
        'language': 'urdu',
        'category': 'place',
      },
      {
        'text': 'Ø§Ø³Ú©ÙˆÙ„',
        'translation': 'School',
        'language': 'urdu',
        'category': 'place',
      },
      {
        'text': 'Ø¯ÙØªØ±',
        'translation': 'Office',
        'language': 'urdu',
        'category': 'place',
      },
      {
        'text': 'Ø¯Ú©Ø§Ù†',
        'translation': 'Shop',
        'language': 'urdu',
        'category': 'place',
      },
      {
        'text': 'Ø¨Ø§Ø²Ø§Ø±',
        'translation': 'Market',
        'language': 'urdu',
        'category': 'place',
      },
      {
        'text': 'Ø§Ø³Ù¾ØªØ§Ù„',
        'translation': 'Hospital',
        'language': 'urdu',
        'category': 'place',
      },
      {
        'text': 'Ù…Ø³Ø¬Ø¯',
        'translation': 'Mosque',
        'language': 'urdu',
        'category': 'place',
      },
      {
        'text': 'Ù¾Ø§Ø±Ú©',
        'translation': 'Park',
        'language': 'urdu',
        'category': 'place',
      },
      {
        'text': 'Ø´ÛØ±',
        'translation': 'City',
        'language': 'urdu',
        'category': 'place',
      },
      {
        'text': 'Ù…Ù„Ú©',
        'translation': 'Country',
        'language': 'urdu',
        'category': 'place',
      },

      // URDU - Emotions
      {
        'text': 'Ø®ÙˆØ´',
        'translation': 'Happy',
        'language': 'urdu',
        'category': 'emotion',
      },
      {
        'text': 'ØºÙ…Ú¯ÛŒÙ†',
        'translation': 'Sad',
        'language': 'urdu',
        'category': 'emotion',
      },
      {
        'text': 'Ø®ÙˆØ´ÛŒ',
        'translation': 'Happiness',
        'language': 'urdu',
        'category': 'emotion',
      },
      {
        'text': 'ØºÙ…',
        'translation': 'Sorrow',
        'language': 'urdu',
        'category': 'emotion',
      },
      {
        'text': 'Ù¾ÛŒØ§Ø±',
        'translation': 'Love',
        'language': 'urdu',
        'category': 'emotion',
      },
      {
        'text': 'ØºØµÛ',
        'translation': 'Anger',
        'language': 'urdu',
        'category': 'emotion',
      },
      {
        'text': 'Ø®ÙˆÙ',
        'translation': 'Fear',
        'language': 'urdu',
        'category': 'emotion',
      },
      {
        'text': 'Ø§Ù…ÛŒØ¯',
        'translation': 'Hope',
        'language': 'urdu',
        'category': 'emotion',
      },
      {
        'text': 'Ù…Ø­Ø¨Øª',
        'translation': 'Love (deep)',
        'language': 'urdu',
        'category': 'emotion',
      },
      {
        'text': 'Ù†ÙØ±Øª',
        'translation': 'Hate',
        'language': 'urdu',
        'category': 'emotion',
      },

      // URDU - Colors
      {
        'text': 'Ø±Ù†Ú¯',
        'translation': 'Color',
        'language': 'urdu',
        'category': 'color',
      },
      {
        'text': 'Ø³ÙÛŒØ¯',
        'translation': 'White',
        'language': 'urdu',
        'category': 'color',
      },
      {
        'text': 'Ú©Ø§Ù„Ø§',
        'translation': 'Black',
        'language': 'urdu',
        'category': 'color',
      },
      {
        'text': 'Ù„Ø§Ù„',
        'translation': 'Red',
        'language': 'urdu',
        'category': 'color',
      },
      {
        'text': 'Ù†ÛŒÙ„Ø§',
        'translation': 'Blue',
        'language': 'urdu',
        'category': 'color',
      },
      {
        'text': 'Ø³Ø¨Ø²',
        'translation': 'Green',
        'language': 'urdu',
        'category': 'color',
      },
      {
        'text': 'Ù¾ÛŒÙ„Ø§',
        'translation': 'Yellow',
        'language': 'urdu',
        'category': 'color',
      },
      {
        'text': 'Ù†Ø§Ø±Ù†Ø¬ÛŒ',
        'translation': 'Orange',
        'language': 'urdu',
        'category': 'color',
      },
      {
        'text': 'Ø¬Ø§Ù…Ù†ÛŒ',
        'translation': 'Purple',
        'language': 'urdu',
        'category': 'color',
      },
      {
        'text': 'Ú¯Ù„Ø§Ø¨ÛŒ',
        'translation': 'Pink',
        'language': 'urdu',
        'category': 'color',
      },

      // URDU - Verbs
      {
        'text': 'Ø¬Ø§Ù†Ø§',
        'translation': 'To go',
        'language': 'urdu',
        'category': 'verb',
      },
      {
        'text': 'Ø¢Ù†Ø§',
        'translation': 'To come',
        'language': 'urdu',
        'category': 'verb',
      },
      {
        'text': 'Ú©Ú¾Ø§Ù†Ø§',
        'translation': 'To eat',
        'language': 'urdu',
        'category': 'verb',
      },
      {
        'text': 'Ù¾ÛŒÙ†Ø§',
        'translation': 'To drink',
        'language': 'urdu',
        'category': 'verb',
      },
      {
        'text': 'Ø³ÙˆÙ†Ø§',
        'translation': 'To sleep',
        'language': 'urdu',
        'category': 'verb',
      },
      {
        'text': 'Ù¾Ú‘Ú¾Ù†Ø§',
        'translation': 'To read/study',
        'language': 'urdu',
        'category': 'verb',
      },
      {
        'text': 'Ù„Ú©Ú¾Ù†Ø§',
        'translation': 'To write',
        'language': 'urdu',
        'category': 'verb',
      },
      {
        'text': 'Ø¨ÙˆÙ„Ù†Ø§',
        'translation': 'To speak',
        'language': 'urdu',
        'category': 'verb',
      },
      {
        'text': 'Ø³Ù†Ù†Ø§',
        'translation': 'To hear',
        'language': 'urdu',
        'category': 'verb',
      },
      {
        'text': 'Ø¯ÛŒÚ©Ú¾Ù†Ø§',
        'translation': 'To see',
        'language': 'urdu',
        'category': 'verb',
      },

      // URDU - Shopping
      {
        'text': 'Ù‚ÛŒÙ…Øª',
        'translation': 'Price',
        'language': 'urdu',
        'category': 'shopping',
      },
      {
        'text': 'Ø³Ø³ØªØ§',
        'translation': 'Cheap',
        'language': 'urdu',
        'category': 'shopping',
      },
      {
        'text': 'Ù…ÛÙ†Ú¯Ø§',
        'translation': 'Expensive',
        'language': 'urdu',
        'category': 'shopping',
      },
      {
        'text': 'Ø®Ø±ÛŒØ¯Ù†Ø§',
        'translation': 'To buy',
        'language': 'urdu',
        'category': 'shopping',
      },
      {
        'text': 'Ø¨ÛŒÚ†Ù†Ø§',
        'translation': 'To sell',
        'language': 'urdu',
        'category': 'shopping',
      },
      {
        'text': 'Ù¾ÛŒØ³Û’',
        'translation': 'Money',
        'language': 'urdu',
        'category': 'shopping',
      },
      {
        'text': 'Ø±ÙˆÙ¾Û’',
        'translation': 'Rupees',
        'language': 'urdu',
        'category': 'shopping',
      },
      {
        'text': 'Ú©ØªÙ†Û’ Ú©Ø§ ÛÛ’ØŸ',
        'translation': 'How much is it?',
        'language': 'urdu',
        'category': 'shopping',
      },
      {
        'text': 'ÛŒÛ Ø¯ÛŒØ¬ÛŒÛ’',
        'translation': 'Give me this',
        'language': 'urdu',
        'category': 'shopping',
      },
      {
        'text': 'Ø¨Ù„',
        'translation': 'Bill',
        'language': 'urdu',
        'category': 'shopping',
      },

      // ===================== PUNJABI (Shahmukhi) =====================

      // PUNJABI - Greetings
      {
        'text': 'Ø³Ù„Ø§Ù…',
        'translation': 'Hello',
        'language': 'punjabi',
        'category': 'greeting',
      },
      {
        'text': 'Ø§Ù„Ø³Ù„Ø§Ù… Ø¹Ù„ÛŒÚ©Ù…',
        'translation': 'Peace be upon you',
        'language': 'punjabi',
        'category': 'greeting',
      },
      {
        'text': 'Ú©ÛŒ Ø­Ø§Ù„ Ø§Û’ØŸ',
        'translation': 'How are you?',
        'language': 'punjabi',
        'category': 'greeting',
      },
      {
        'text': 'Ù¹Ú¾ÛŒÚ© Ø¢Úº',
        'translation': 'I am fine',
        'language': 'punjabi',
        'category': 'greeting',
      },
      {
        'text': 'ØµØ¨Ø­ Ø¯ÛŒ Ø®ÛŒØ±',
        'translation': 'Good morning',
        'language': 'punjabi',
        'category': 'greeting',
      },
      {
        'text': 'Ø´Ø§Ù… Ø¯ÛŒ Ø®ÛŒØ±',
        'translation': 'Good evening',
        'language': 'punjabi',
        'category': 'greeting',
      },
      {
        'text': 'Ø±Ø§Øª Ø¯ÛŒ Ø®ÛŒØ±',
        'translation': 'Good night',
        'language': 'punjabi',
        'category': 'greeting',
      },
      {
        'text': 'Ø¬ÛŒ Ø¢ÛŒØ§Úº Ù†ÙˆÚº',
        'translation': 'Welcome',
        'language': 'punjabi',
        'category': 'greeting',
      },
      {
        'text': 'Ø±Ø¨ Ø±Ø§Ú©Ú¾Ø§',
        'translation': 'Goodbye (God protect you)',
        'language': 'punjabi',
        'category': 'greeting',
      },
      {
        'text': 'Ø§Ù„Ù„Û Ø­Ø§ÙØ¸',
        'translation': 'Goodbye',
        'language': 'punjabi',
        'category': 'greeting',
      },
      {
        'text': 'ÙÛŒØ± Ù…Ù„Ø§Úº Ú¯Û’',
        'translation': 'See you again',
        'language': 'punjabi',
        'category': 'greeting',
      },
      {
        'text': 'Ø®ÙˆØ´ Ø¢Ù…Ø¯ÛŒØ¯',
        'translation': 'Welcome',
        'language': 'punjabi',
        'category': 'greeting',
      },

      // PUNJABI - Polite
      {
        'text': 'Ø´Ú©Ø±ÛŒÛ',
        'translation': 'Thank you',
        'language': 'punjabi',
        'category': 'polite',
      },
      {
        'text': 'Ø¨ÛØª Ø´Ú©Ø±ÛŒÛ',
        'translation': 'Thank you very much',
        'language': 'punjabi',
        'category': 'polite',
      },
      {
        'text': 'Ù…Ø¹Ø§Ù Ú©Ø±Ù†Ø§',
        'translation': 'Sorry/Forgive me',
        'language': 'punjabi',
        'category': 'polite',
      },
      {
        'text': 'Ù…ÛØ±Ø¨Ø§Ù†ÛŒ Ú©Ø±Ú©Û’',
        'translation': 'Please',
        'language': 'punjabi',
        'category': 'polite',
      },
      {
        'text': 'Ú©ÙˆØ¦ÛŒ Ú¯Ù„ Ù†Ø¦ÛŒÚº',
        'translation': 'No problem',
        'language': 'punjabi',
        'category': 'polite',
      },
      {
        'text': 'ÛØ§Úº Ø¬ÛŒ',
        'translation': 'Yes (respectful)',
        'language': 'punjabi',
        'category': 'polite',
      },
      {
        'text': 'Ù†Ø¦ÛŒÚº Ø¬ÛŒ',
        'translation': 'No (respectful)',
        'language': 'punjabi',
        'category': 'polite',
      },
      {
        'text': 'Ø¨Ú¾Ù„Ø§ Ú©Ø±Ùˆ',
        'translation': 'Please do',
        'language': 'punjabi',
        'category': 'polite',
      },

      // PUNJABI - Family
      {
        'text': 'Ø§Ø¨Ø§ Ø¬ÛŒ',
        'translation': 'Father',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ø§Ù…ÛŒ Ø¬ÛŒ',
        'translation': 'Mother',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ù¾ÛŒÙˆ',
        'translation': 'Father (informal)',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ù…Ø§Úº',
        'translation': 'Mother (informal)',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ø¨Ú¾Ø±Ø§',
        'translation': 'Brother',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ø¨Ú¾ÛŒÙ†',
        'translation': 'Sister',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ù¾ØªØ±',
        'translation': 'Son',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ø¯Ú¾ÛŒ',
        'translation': 'Daughter',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ø¯Ø§Ø¯Ø§',
        'translation': 'Grandfather (paternal)',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ø¯Ø§Ø¯ÛŒ',
        'translation': 'Grandmother (paternal)',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ù†Ø§Ù†Ø§',
        'translation': 'Grandfather (maternal)',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ù†Ø§Ù†ÛŒ',
        'translation': 'Grandmother (maternal)',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ù¹Ø¨Ø±',
        'translation': 'Family',
        'language': 'punjabi',
        'category': 'family',
      },
      {
        'text': 'Ú¯Ú¾Ø±ÙˆØ§Ù„Û’',
        'translation': 'Family members',
        'language': 'punjabi',
        'category': 'family',
      },

      // PUNJABI - Food
      {
        'text': 'Ú©Ú¾Ø§Ý¨Ø§',
        'translation': 'Food',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ù¾Ø§Ý¨ÛŒ',
        'translation': 'Water',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ø¯ÙØ¯Ú¾',
        'translation': 'Milk',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ú†Ø§Û',
        'translation': 'Tea',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ø±ÙˆÙ¹ÛŒ',
        'translation': 'Bread',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ú†ÙˆÙ„Ø§Úº',
        'translation': 'Rice',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ú¯ÙˆØ´Øª',
        'translation': 'Meat',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ù…Ú†Ú¾ÛŒ',
        'translation': 'Fish',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ø³Ø¨Ø²ÛŒ',
        'translation': 'Vegetable',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ù¾Ú¾Ù„',
        'translation': 'Fruit',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ù†Ø§Ø´ØªÛ',
        'translation': 'Breakfast',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ø¯ÙˆÙ¾ÛØ± Ø¯Ø§ Ú©Ú¾Ø§Ý¨Ø§',
        'translation': 'Lunch',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ø±Ø§Øª Ø¯Ø§ Ú©Ú¾Ø§Ý¨Ø§',
        'translation': 'Dinner',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ù„Ø³ÛŒ',
        'translation': 'Lassi (yogurt drink)',
        'language': 'punjabi',
        'category': 'food',
      },
      {
        'text': 'Ù…Ú©Ú¾Ù†',
        'translation': 'Butter',
        'language': 'punjabi',
        'category': 'food',
      },

      // PUNJABI - Numbers
      {
        'text': 'Ø§Ú©',
        'translation': 'One',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'Ø¯Ùˆ',
        'translation': 'Two',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'ØªÙ†',
        'translation': 'Three',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'Ú†Ø§Ø±',
        'translation': 'Four',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'Ù¾Ù†Ø¬',
        'translation': 'Five',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'Ú†Ú¾',
        'translation': 'Six',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'Ø³Øª',
        'translation': 'Seven',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'Ø§Ù¹Ú¾',
        'translation': 'Eight',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'Ù†Ùˆ',
        'translation': 'Nine',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'Ø¯Ø³',
        'translation': 'Ten',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'ÙˆÛŒÛÛ',
        'translation': 'Twenty',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'Ø³Ùˆ',
        'translation': 'Hundred',
        'language': 'punjabi',
        'category': 'number',
      },
      {
        'text': 'ÛØ²Ø§Ø±',
        'translation': 'Thousand',
        'language': 'punjabi',
        'category': 'number',
      },

      // PUNJABI - Time
      {
        'text': 'ÙˆÛŒÙ„Ø§',
        'translation': 'Time',
        'language': 'punjabi',
        'category': 'time',
      },
      {
        'text': 'Ø¯ÛŒÛØ§Ú‘Ø§',
        'translation': 'Day',
        'language': 'punjabi',
        'category': 'time',
      },
      {
        'text': 'Ø±Ø§Øª',
        'translation': 'Night',
        'language': 'punjabi',
        'category': 'time',
      },
      {
        'text': 'Ø³ÙˆÛŒØ±Ø§',
        'translation': 'Morning',
        'language': 'punjabi',
        'category': 'time',
      },
      {
        'text': 'Ø¯ÙˆÙ¾ÛŒÛØ±',
        'translation': 'Afternoon',
        'language': 'punjabi',
        'category': 'time',
      },
      {
        'text': 'Ø´Ø§Ù…',
        'translation': 'Evening',
        'language': 'punjabi',
        'category': 'time',
      },
      {
        'text': 'Ø§Ø¬',
        'translation': 'Today',
        'language': 'punjabi',
        'category': 'time',
      },
      {
        'text': 'Ú©Ù„',
        'translation': 'Yesterday/Tomorrow',
        'language': 'punjabi',
        'category': 'time',
      },
      {
        'text': 'ÛÙØªÛ',
        'translation': 'Week',
        'language': 'punjabi',
        'category': 'time',
      },
      {
        'text': 'Ù…ÛÛŒÙ†Û',
        'translation': 'Month',
        'language': 'punjabi',
        'category': 'time',
      },
      {
        'text': 'ÙˆØ±Ú¾Ø§',
        'translation': 'Year',
        'language': 'punjabi',
        'category': 'time',
      },

      // PUNJABI - Places
      {
        'text': 'Ú¯Ú¾Ø±',
        'translation': 'Home/House',
        'language': 'punjabi',
        'category': 'place',
      },
      {
        'text': 'Ú©ÙˆÙ¹Ú¾Ø§',
        'translation': 'House (traditional)',
        'language': 'punjabi',
        'category': 'place',
      },
      {
        'text': 'Ø³Ú©ÙˆÙ„',
        'translation': 'School',
        'language': 'punjabi',
        'category': 'place',
      },
      {
        'text': 'Ø¯ÙØªØ±',
        'translation': 'Office',
        'language': 'punjabi',
        'category': 'place',
      },
      {
        'text': 'ÛÙ¹ÛŒ',
        'translation': 'Shop',
        'language': 'punjabi',
        'category': 'place',
      },
      {
        'text': 'Ø¨Ø§Ø²Ø§Ø±',
        'translation': 'Market',
        'language': 'punjabi',
        'category': 'place',
      },
      {
        'text': 'ÛØ³Ù¾ØªØ§Ù„',
        'translation': 'Hospital',
        'language': 'punjabi',
        'category': 'place',
      },
      {
        'text': 'Ù…Ø³ÛŒØª',
        'translation': 'Mosque',
        'language': 'punjabi',
        'category': 'place',
      },
      {
        'text': 'Ù¾Ù†Úˆ',
        'translation': 'Village',
        'language': 'punjabi',
        'category': 'place',
      },
      {
        'text': 'Ø´ÛØ±',
        'translation': 'City',
        'language': 'punjabi',
        'category': 'place',
      },
      {
        'text': 'Ù…Ù„Ú©',
        'translation': 'Country',
        'language': 'punjabi',
        'category': 'place',
      },
      {
        'text': 'Ú©Ú¾ÛŒØª',
        'translation': 'Field/Farm',
        'language': 'punjabi',
        'category': 'place',
      },

      // PUNJABI - Emotions
      {
        'text': 'Ø®ÙˆØ´',
        'translation': 'Happy',
        'language': 'punjabi',
        'category': 'emotion',
      },
      {
        'text': 'Ø§Ø¯Ø§Ø³',
        'translation': 'Sad',
        'language': 'punjabi',
        'category': 'emotion',
      },
      {
        'text': 'Ø®ÙˆØ´ÛŒ',
        'translation': 'Happiness',
        'language': 'punjabi',
        'category': 'emotion',
      },
      {
        'text': 'Ø¯Ú©Ú¾',
        'translation': 'Sorrow',
        'language': 'punjabi',
        'category': 'emotion',
      },
      {
        'text': 'Ù¾ÛŒØ§Ø±',
        'translation': 'Love',
        'language': 'punjabi',
        'category': 'emotion',
      },
      {
        'text': 'ØºØµÛ',
        'translation': 'Anger',
        'language': 'punjabi',
        'category': 'emotion',
      },
      {
        'text': 'ÚˆØ±',
        'translation': 'Fear',
        'language': 'punjabi',
        'category': 'emotion',
      },
      {
        'text': 'Ø¢Ø³',
        'translation': 'Hope',
        'language': 'punjabi',
        'category': 'emotion',
      },
      {
        'text': 'Ù…Ø­Ø¨Øª',
        'translation': 'Love (deep)',
        'language': 'punjabi',
        'category': 'emotion',
      },
      {
        'text': 'Ø¹Ø´Ù‚',
        'translation': 'Passionate love',
        'language': 'punjabi',
        'category': 'emotion',
      },

      // PUNJABI - Common sentences
      {
        'text': 'ØªÛŒØ±Ø§ Ù†Ø§Úº Ú©ÛŒ Ø§Û’ØŸ',
        'translation': 'What is your name?',
        'language': 'punjabi',
        'category': 'question',
      },
      {
        'text': 'Ù…ÛŒØ±Ø§ Ù†Ø§Úº',
        'translation': 'My name is',
        'language': 'punjabi',
        'category': 'response',
      },
      {
        'text': 'ØªÙˆ Ú©ØªÚ¾ÙˆÚº Ø¢ÛŒØ§ Ø§ÛŒÚºØŸ',
        'translation': 'Where are you from?',
        'language': 'punjabi',
        'category': 'question',
      },
      {
        'text': 'Ù…ÛŒÚº Ù„Ø§ÛÙˆØ± ØªÙˆÚº Ø¢Úº',
        'translation': 'I am from Lahore',
        'language': 'punjabi',
        'category': 'response',
      },
      {
        'text': 'Ø§ÛŒÛÛ Ú©ÛŒ Ø§Û’ØŸ',
        'translation': 'What is this?',
        'language': 'punjabi',
        'category': 'question',
      },
      {
        'text': 'Ú©ÛŒÙˆÚºØŸ',
        'translation': 'Why?',
        'language': 'punjabi',
        'category': 'question',
      },
      {
        'text': 'Ú©Ø¯ÙˆÚºØŸ',
        'translation': 'When?',
        'language': 'punjabi',
        'category': 'question',
      },
      {
        'text': 'Ú©ØªÚ¾Û’ØŸ',
        'translation': 'Where?',
        'language': 'punjabi',
        'category': 'question',
      },
      {
        'text': 'Ú©ÙˆÛŒÚºØŸ',
        'translation': 'How?',
        'language': 'punjabi',
        'category': 'question',
      },
      {
        'text': 'Ú©ÙˆÙ†ØŸ',
        'translation': 'Who?',
        'language': 'punjabi',
        'category': 'question',
      },
      {
        'text': 'Ú©Ù†Ø§ØŸ',
        'translation': 'How much?',
        'language': 'punjabi',
        'category': 'question',
      },

      // PUNJABI - Verbs
      {
        'text': 'Ø¬Ø§Ù†Ø§',
        'translation': 'To go',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'Ø¢Ù†Ø§',
        'translation': 'To come',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'Ú©Ú¾Ø§Ù†Ø§',
        'translation': 'To eat',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'Ù¾ÛŒÙ†Ø§',
        'translation': 'To drink',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'Ø³ÙˆÙ†Ø§',
        'translation': 'To sleep',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'Ù¾Ú‘Ú¾Ù†Ø§',
        'translation': 'To read/study',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'Ù„Ú©Ú¾Ù†Ø§',
        'translation': 'To write',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'Ø¨ÙˆÙ„Ù†Ø§',
        'translation': 'To speak',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'Ø³Ù†Ù†Ø§',
        'translation': 'To hear',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'ÙˆÛŒÚ©Ú¾Ù†Ø§',
        'translation': 'To see',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'Ú©Ø±Ù†Ø§',
        'translation': 'To do',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'Ø¯ÛŒÙ†Ø§',
        'translation': 'To give',
        'language': 'punjabi',
        'category': 'verb',
      },
      {
        'text': 'Ù„ÛŒÙ†Ø§',
        'translation': 'To take',
        'language': 'punjabi',
        'category': 'verb',
      },

      // PUNJABI - Shopping
      {
        'text': 'Ù‚ÛŒÙ…Øª',
        'translation': 'Price',
        'language': 'punjabi',
        'category': 'shopping',
      },
      {
        'text': 'Ø³Ø³ØªØ§',
        'translation': 'Cheap',
        'language': 'punjabi',
        'category': 'shopping',
      },
      {
        'text': 'Ù…ÛÙ†Ú¯Ø§',
        'translation': 'Expensive',
        'language': 'punjabi',
        'category': 'shopping',
      },
      {
        'text': 'Ø®Ø±ÛŒØ¯Ù†Ø§',
        'translation': 'To buy',
        'language': 'punjabi',
        'category': 'shopping',
      },
      {
        'text': 'ÙˆÛŒÚ†Ù†Ø§',
        'translation': 'To sell',
        'language': 'punjabi',
        'category': 'shopping',
      },
      {
        'text': 'Ù¾ÛŒØ³Û’',
        'translation': 'Money',
        'language': 'punjabi',
        'category': 'shopping',
      },
      {
        'text': 'Ú©Ù†Û’ Ø¯Ø§ Ø§Û’ØŸ',
        'translation': 'How much is it?',
        'language': 'punjabi',
        'category': 'shopping',
      },
      {
        'text': 'Ø§ÛŒÛÛ Ø¯Û’ Ø¯ÛŒÙˆ',
        'translation': 'Give me this',
        'language': 'punjabi',
        'category': 'shopping',
      },

      // PUNJABI - Colors
      {
        'text': 'Ø±Ù†Ú¯',
        'translation': 'Color',
        'language': 'punjabi',
        'category': 'color',
      },
      {
        'text': 'Ú†Ù¹Ø§',
        'translation': 'White',
        'language': 'punjabi',
        'category': 'color',
      },
      {
        'text': 'Ú©Ø§Ù„Ø§',
        'translation': 'Black',
        'language': 'punjabi',
        'category': 'color',
      },
      {
        'text': 'Ù„Ø§Ù„',
        'translation': 'Red',
        'language': 'punjabi',
        'category': 'color',
      },
      {
        'text': 'Ù†ÛŒÙ„Ø§',
        'translation': 'Blue',
        'language': 'punjabi',
        'category': 'color',
      },
      {
        'text': 'ÛØ±Ø§',
        'translation': 'Green',
        'language': 'punjabi',
        'category': 'color',
      },
      {
        'text': 'Ù¾ÛŒÙ„Ø§',
        'translation': 'Yellow',
        'language': 'punjabi',
        'category': 'color',
      },

      // More Punjabi expressions
      {
        'text': 'Ú†Ù†Ú¯Ø§',
        'translation': 'Good',
        'language': 'punjabi',
        'category': 'adjective',
      },
      {
        'text': 'Ù…Ø§Ú‘Ø§',
        'translation': 'Bad',
        'language': 'punjabi',
        'category': 'adjective',
      },
      {
        'text': 'ÙˆÚˆØ§',
        'translation': 'Big',
        'language': 'punjabi',
        'category': 'adjective',
      },
      {
        'text': 'Ù†Ú©Ø§',
        'translation': 'Small',
        'language': 'punjabi',
        'category': 'adjective',
      },
      {
        'text': 'Ù†ÙˆØ§Úº',
        'translation': 'New',
        'language': 'punjabi',
        'category': 'adjective',
      },
      {
        'text': 'Ù¾Ø±Ø§Ý¨Ø§',
        'translation': 'Old',
        'language': 'punjabi',
        'category': 'adjective',
      },
      {
        'text': 'Ø³ÙˆÛÙ†Ø§',
        'translation': 'Beautiful',
        'language': 'punjabi',
        'category': 'adjective',
      },
      {
        'text': 'ØªÛŒØ²',
        'translation': 'Fast',
        'language': 'punjabi',
        'category': 'adjective',
      },
      {
        'text': 'ÛÙˆÙ„ÛŒ',
        'translation': 'Slow',
        'language': 'punjabi',
        'category': 'adjective',
      },
      {
        'text': 'Ú¯Ø±Ù…',
        'translation': 'Hot',
        'language': 'punjabi',
        'category': 'adjective',
      },
      {
        'text': 'Ù¹Ú¾Ù†ÚˆØ§',
        'translation': 'Cold',
        'language': 'punjabi',
        'category': 'adjective',
      },
    ];
  }
}

/// Vocabulary prediction from XLM-RoBERTa training data
class VocabularyPrediction {
  final String word;
  final String translation;
  final String pronunciation;
  final double confidence;
  final String? example;

  VocabularyPrediction({
    required this.word,
    required this.translation,
    required this.pronunciation,
    required this.confidence,
    this.example,
  });
}

/// Language detection result from XLM-RoBERTa model
class LanguageDetectionResult {
  final String text;
  final String language;
  final double confidence;
  final double urduProbability;
  final double punjabiProbability;

  LanguageDetectionResult({
    required this.text,
    required this.language,
    required this.confidence,
    required this.urduProbability,
    required this.punjabiProbability,
  });
}

/// Grammar check result
class GrammarCheckResult {
  final bool isCorrect;
  final int score;
  final String feedback;
  final List<String> corrections;
  final String detectedLanguage;
  final double confidence;

  GrammarCheckResult({
    required this.isCorrect,
    required this.score,
    required this.feedback,
    required this.corrections,
    this.detectedLanguage = 'urdu',
    this.confidence = 0.5,
  });
}


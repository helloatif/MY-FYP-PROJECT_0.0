import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../providers/learning_provider.dart';
import '../../providers/gamification_provider.dart';
import '../../services/voice_service.dart';
import '../../services/chapter_service.dart';
import '../../data/vocabulary_data.dart';

/// Question types for the chapter quiz
enum QuestionType {
  writtenInput, // User types the translation
  multipleChoice, // MCQ with 4 options
  fillInBlank, // Fill in the blank
  pronunciation, // Speech-to-text pronunciation check
}

/// Quiz question model
class ChapterQuizQuestion {
  final String id;
  final QuestionType type;
  final String question;
  final String correctAnswer;
  final List<String>? options; // For MCQ
  final String? urduWord; // The original word
  final String? pronunciation; // Pronunciation guide
  String? userAnswer;
  bool? isCorrect;

  ChapterQuizQuestion({
    required this.id,
    required this.type,
    required this.question,
    required this.correctAnswer,
    this.options,
    this.urduWord,
    this.pronunciation,
    this.userAnswer,
    this.isCorrect,
  });
}

class ChapterQuizScreen extends StatefulWidget {
  final ChapterModel chapter;

  const ChapterQuizScreen({super.key, required this.chapter});

  @override
  State<ChapterQuizScreen> createState() => _ChapterQuizScreenState();
}

class _ChapterQuizScreenState extends State<ChapterQuizScreen>
    with TickerProviderStateMixin {
  late List<ChapterQuizQuestion> _questions;
  int _currentQuestionIndex = 0;
  bool _showResult = false;
  bool _isAnswerChecked = false;
  bool _isListening = false;
  String _recognizedText = '';

  final TextEditingController _answerController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _generateQuestions();
    VoiceService.initialize();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    _animationController.dispose();
    VoiceService.stop();
    super.dispose();
  }

  /// Generate 20 questions from chapter vocabulary
  void _generateQuestions() {
    final chapterId = widget.chapter.id;
    final lessonsList =
        VocabularyData.urduLessons[chapterId] ??
        VocabularyData.punjabiLessons[chapterId] ??
        [];

    // Collect all words from all lessons
    final allWords = lessonsList.expand((lesson) => lesson.words).toList();

    if (allWords.isEmpty) {
      // Fallback if no words
      _questions = _generateFallbackQuestions();
      return;
    }

    // Shuffle words
    allWords.shuffle(Random());

    // Take enough words for 20 questions (may need fewer unique words with different question types)
    final selectedWords = allWords.take(min(25, allWords.length)).toList();

    _questions = [];
    final random = Random();

    // Distribute question types: 5 each of 4 types = 20 questions
    // Written Input: 5, MCQ: 5, Fill in Blank: 5, Pronunciation: 5
    int writtenCount = 0, mcqCount = 0, fillCount = 0, pronCount = 0;

    for (int i = 0; i < 20 && i < selectedWords.length; i++) {
      final word = selectedWords[i % selectedWords.length];
      QuestionType type;

      // Distribute evenly
      if (writtenCount < 5) {
        type = QuestionType.writtenInput;
        writtenCount++;
      } else if (mcqCount < 5) {
        type = QuestionType.multipleChoice;
        mcqCount++;
      } else if (fillCount < 5) {
        type = QuestionType.fillInBlank;
        fillCount++;
      } else {
        type = QuestionType.pronunciation;
        pronCount++;
      }

      _questions.add(
        _createQuestion(
          id: 'q_$i',
          word: word,
          type: type,
          allWords: allWords,
          random: random,
        ),
      );
    }

    // Shuffle the questions so types are mixed
    _questions.shuffle(random);
  }

  /// Create a single question based on type
  ChapterQuizQuestion _createQuestion({
    required String id,
    required VocabWord word,
    required QuestionType type,
    required List<VocabWord> allWords,
    required Random random,
  }) {
    switch (type) {
      case QuestionType.writtenInput:
        return ChapterQuizQuestion(
          id: id,
          type: type,
          question: 'Write the English translation for:\n\n"${word.urdu}"',
          correctAnswer: word.english.trim().toLowerCase(),
          urduWord: word.urdu,
          pronunciation: word.pronunciation,
        );

      case QuestionType.multipleChoice:
        // Generate 3 wrong options
        final wrongOptions =
            allWords.where((w) => w.english != word.english).take(10).toList()
              ..shuffle(random);
        final options = [
          word.english,
          ...wrongOptions.take(3).map((w) => w.english),
        ]..shuffle(random);

        return ChapterQuizQuestion(
          id: id,
          type: type,
          question: 'What does "${word.urdu}" mean in English?',
          correctAnswer: word.english,
          options: options,
          urduWord: word.urdu,
          pronunciation: word.pronunciation,
        );

      case QuestionType.fillInBlank:
        // Create fill in the blank from example sentence
        String sentence = word.exampleEnglish ?? word.english;
        String blank = word.english.split(' ').first;
        String questionSentence = sentence.replaceFirst(
          RegExp(blank, caseSensitive: false),
          '________',
        );

        return ChapterQuizQuestion(
          id: id,
          type: type,
          question:
              'Fill in the blank:\n\n"$questionSentence"\n\nHint: ${word.urdu}',
          correctAnswer: blank.toLowerCase(),
          urduWord: word.urdu,
          pronunciation: word.pronunciation,
        );

      case QuestionType.pronunciation:
        return ChapterQuizQuestion(
          id: id,
          type: type,
          question:
              'Pronounce this word correctly:\n\n"${word.urdu}"\n\nPronunciation: ${word.pronunciation}',
          correctAnswer: word.urdu,
          urduWord: word.urdu,
          pronunciation: word.pronunciation,
        );
    }
  }

  /// Fallback questions if no vocabulary data
  List<ChapterQuizQuestion> _generateFallbackQuestions() {
    return List.generate(
      20,
      (i) => ChapterQuizQuestion(
        id: 'fallback_$i',
        type: QuestionType.multipleChoice,
        question: 'Sample question ${i + 1}',
        correctAnswer: 'Answer',
        options: ['Answer', 'Wrong 1', 'Wrong 2', 'Wrong 3'],
      ),
    );
  }

  /// Check the current answer
  void _checkAnswer() {
    final question = _questions[_currentQuestionIndex];
    final userAnswer = question.type == QuestionType.pronunciation
        ? _recognizedText
        : _answerController.text.trim();

    setState(() {
      question.userAnswer = userAnswer;

      if (question.type == QuestionType.pronunciation) {
        // For pronunciation, use similarity scoring
        final similarity = _calculateSimilarity(
          question.correctAnswer.toLowerCase(),
          userAnswer.toLowerCase(),
        );
        question.isCorrect = similarity >= 0.6; // 60% similarity threshold
      } else if (question.type == QuestionType.multipleChoice) {
        question.isCorrect = userAnswer == question.correctAnswer;
      } else {
        // For written and fill-in-blank, normalize and compare
        question.isCorrect =
            _normalizeAnswer(userAnswer) ==
            _normalizeAnswer(question.correctAnswer);
      }

      _isAnswerChecked = true;
    });

    _animationController.forward().then((_) => _animationController.reverse());
  }

  /// Normalize answer for comparison
  String _normalizeAnswer(String answer) {
    return answer.toLowerCase().trim().replaceAll(RegExp(r'[^\w\s]'), '');
  }

  /// Calculate similarity between two strings
  double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final longer = s1.length > s2.length ? s1 : s2;
    final shorter = s1.length > s2.length ? s2 : s1;

    if (longer.isEmpty) return 1.0;

    final distance = _levenshteinDistance(longer, shorter);
    return (longer.length - distance) / longer.length;
  }

  /// Levenshtein distance
  int _levenshteinDistance(String s1, String s2) {
    final len1 = s1.length;
    final len2 = s2.length;
    final matrix = List.generate(len1 + 1, (_) => List.filled(len2 + 1, 0));

    for (var i = 0; i <= len1; i++) matrix[i][0] = i;
    for (var j = 0; j <= len2; j++) matrix[0][j] = j;

    for (var i = 1; i <= len1; i++) {
      for (var j = 1; j <= len2; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce(min);
      }
    }
    return matrix[len1][len2];
  }

  /// Go to next question
  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isAnswerChecked = false;
        _answerController.clear();
        _recognizedText = '';
      });
    } else {
      _showResults();
    }
  }

  /// Show final results
  void _showResults() {
    final correctCount = _questions.where((q) => q.isCorrect == true).length;
    final score = (correctCount / 20) * 100;
    final passed = score >= 80;

    setState(() {
      _showResult = true;
    });

    // If passed, unlock next chapter
    if (passed) {
      final learningProvider = context.read<LearningProvider>();
      final gamificationProvider = context.read<GamificationProvider>();

      // Only award XP on first time passing (not on retakes)
      final alreadyPassed = learningProvider.isChapterQuizPassed(
        widget.chapter.id,
      );

      // Mark chapter as completed with quiz passed
      learningProvider.completeChapterQuiz(widget.chapter.id, score);

      // Award 50 XP only on first pass
      if (!alreadyPassed) {
        gamificationProvider.addPoints(50);
      }
    }
  }

  /// Start listening for pronunciation
  Future<void> _startListening() async {
    setState(() {
      _isListening = true;
      _recognizedText = '';
    });

    await VoiceService.listen(
      language: widget.chapter.language,
      onResult: (text) {
        setState(() {
          _recognizedText = text;
        });
      },
      onStart: () {},
      onStop: () {
        setState(() {
          _isListening = false;
        });
      },
    );
  }

  /// Speak the word for pronunciation help
  Future<void> _speakWord(String word) async {
    await VoiceService.speak(word, widget.chapter.language);
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return _buildResultScreen();
    }

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textDark),
          onPressed: () => _showExitDialog(),
        ),
        title: Text(
          'Chapter Quiz',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),

            // Question content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildQuestionCard(),
              ),
            ),

            // Bottom buttons
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of 20',
                style: const TextStyle(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildQuestionTypeChip(),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / 20,
            backgroundColor: AppTheme.textDark.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.orange),
            borderRadius: BorderRadius.circular(4),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTypeChip() {
    final question = _questions[_currentQuestionIndex];
    String label;
    IconData icon;
    Color color;

    switch (question.type) {
      case QuestionType.writtenInput:
        label = 'Written';
        icon = Icons.edit_note;
        color = Colors.blue;
        break;
      case QuestionType.multipleChoice:
        label = 'MCQ';
        icon = Icons.radio_button_checked;
        color = Colors.green;
        break;
      case QuestionType.fillInBlank:
        label = 'Fill Blank';
        icon = Icons.short_text;
        color = Colors.orange;
        break;
      case QuestionType.pronunciation:
        label = 'Pronounce';
        icon = Icons.mic;
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = _questions[_currentQuestionIndex];

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.textDark.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question text
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // Speak button for pronunciation help
            if (question.urduWord != null) ...[
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _speakWord(question.urduWord!),
                  icon: const Icon(Icons.volume_up),
                  label: const Text('Listen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Answer input based on type
            _buildAnswerInput(question),

            // Feedback after checking
            if (_isAnswerChecked) _buildFeedback(question),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerInput(ChapterQuizQuestion question) {
    switch (question.type) {
      case QuestionType.writtenInput:
      case QuestionType.fillInBlank:
        return TextField(
          controller: _answerController,
          enabled: !_isAnswerChecked,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: question.type == QuestionType.fillInBlank
                ? 'Type the missing word...'
                : 'Type your answer...',
            filled: true,
            fillColor: _isAnswerChecked
                ? (question.isCorrect == true
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1))
                : AppTheme.lightGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        );

      case QuestionType.multipleChoice:
        return Column(
          children: question.options!.map((option) {
            final isSelected = question.userAnswer == option;
            final isCorrect = option == question.correctAnswer;

            Color? bgColor;
            Color? borderColor;

            if (_isAnswerChecked) {
              if (isCorrect) {
                bgColor = Colors.green.withOpacity(0.2);
                borderColor = Colors.green;
              } else if (isSelected && !isCorrect) {
                bgColor = Colors.red.withOpacity(0.2);
                borderColor = Colors.red;
              }
            } else if (isSelected) {
              bgColor = AppTheme.orange.withOpacity(0.2);
              borderColor = AppTheme.orange;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: _isAnswerChecked
                    ? null
                    : () {
                        setState(() {
                          question.userAnswer = option;
                          _answerController.text = option;
                        });
                      },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor ?? AppTheme.textDark.withOpacity(0.2),
                      width: isSelected || (_isAnswerChecked && isCorrect)
                          ? 2
                          : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textDark,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (_isAnswerChecked && isCorrect)
                        const Icon(Icons.check_circle, color: Colors.green),
                      if (_isAnswerChecked && isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: Colors.red),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );

      case QuestionType.pronunciation:
        return Column(
          children: [
            // Recognized text display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isAnswerChecked
                    ? (question.isCorrect == true
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1))
                    : AppTheme.lightGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isListening
                      ? AppTheme.orange
                      : AppTheme.textDark.withOpacity(0.2),
                  width: _isListening ? 2 : 1,
                ),
              ),
              child: Text(
                _recognizedText.isEmpty
                    ? 'Tap the microphone and speak...'
                    : _recognizedText,
                style: TextStyle(
                  fontSize: 18,
                  color: _recognizedText.isEmpty
                      ? Colors.grey
                      : AppTheme.textDark,
                  fontStyle: _recognizedText.isEmpty
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Microphone button
            GestureDetector(
              onTap: _isAnswerChecked ? null : _startListening,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _isListening ? Colors.red : AppTheme.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (_isListening ? Colors.red : AppTheme.orange)
                          .withOpacity(0.4),
                      blurRadius: _isListening ? 20 : 10,
                      spreadRadius: _isListening ? 2 : 0,
                    ),
                  ],
                ),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
            if (_isListening)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Listening...',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        );
    }
  }

  Widget _buildFeedback(ChapterQuizQuestion question) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: question.isCorrect == true
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: question.isCorrect == true ? Colors.green : Colors.red,
        ),
      ),
      child: Row(
        children: [
          Icon(
            question.isCorrect == true ? Icons.check_circle : Icons.cancel,
            color: question.isCorrect == true ? Colors.green : Colors.red,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.isCorrect == true ? 'Correct!' : 'Incorrect',
                  style: TextStyle(
                    color: question.isCorrect == true
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (question.isCorrect != true) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Correct answer: ${question.correctAnswer}',
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    final question = _questions[_currentQuestionIndex];
    final canCheck = question.type == QuestionType.multipleChoice
        ? question.userAnswer != null && question.userAnswer!.isNotEmpty
        : question.type == QuestionType.pronunciation
        ? _recognizedText.isNotEmpty
        : _answerController.text.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: _isAnswerChecked
            ? ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(
                  _currentQuestionIndex < 19 ? 'Next Question' : 'See Results',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: canCheck ? _checkAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canCheck
                      ? AppTheme.textDark
                      : AppTheme.textDark.withOpacity(0.3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text(
                  'Check Answer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final correctCount = _questions.where((q) => q.isCorrect == true).length;
    final score = (correctCount / 20) * 100;
    final passed = score >= 80;

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Result icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: passed
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    passed ? Icons.emoji_events : Icons.refresh,
                    size: 60,
                    color: passed ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 24),

                // Result title
                Text(
                  passed ? 'Congratulations! 🎉' : 'Keep Practicing!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Score
                Text(
                  'You scored',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textDark.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${score.toInt()}%',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: passed ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$correctCount out of 20 correct',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textDark.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),

                // Pass/Fail message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: passed
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: passed
                          ? Colors.green.withOpacity(0.3)
                          : Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    passed
                        ? '✅ You passed! The next chapter is now unlocked.'
                        : '⚠️ You need 80% to pass and unlock the next chapter. Review the lessons and try again!',
                    style: TextStyle(
                      color: passed ? Colors.green[800] : Colors.orange[800],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                if (passed) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: AppTheme.orange),
                        const SizedBox(width: 8),
                        Text(
                          '+50 XP Earned!',
                          style: TextStyle(
                            color: Colors.amber[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Action buttons
                if (!passed)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentQuestionIndex = 0;
                        _showResult = false;
                        _isAnswerChecked = false;
                        _answerController.clear();
                        _recognizedText = '';
                        _generateQuestions(); // Regenerate questions
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    passed ? 'Continue Learning' : 'Review Lessons',
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Your progress will be lost. Are you sure you want to exit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit quiz
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

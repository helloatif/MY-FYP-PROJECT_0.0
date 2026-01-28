import 'dart:math';
import '../data/vocabulary_data.dart';
import 'huggingface_api_service.dart';

/// Quiz types supported by the system
enum QuizType {
  vocabulary, // Word translation quizzes
  grammar, // Grammar correction quizzes
  comprehension, // Reading comprehension
  listening, // Audio-based quizzes
  typing, // Type the translation
  matching, // Match pairs
}

/// Quiz question model
class QuizQuestion {
  final String id;
  final QuizType type;
  final String subtype;
  final String question;
  final String? questionUrdu;
  final List<String>? options;
  final String correctAnswer;
  final int? correctIndex;
  final String language;
  final String difficulty;
  final String? hint;
  final String? audioUrl;

  // For scoring
  String? userAnswer;
  QuizScoreResult? scoreResult;
  bool isAnswered = false;

  QuizQuestion({
    required this.id,
    required this.type,
    this.subtype = '',
    required this.question,
    this.questionUrdu,
    this.options,
    required this.correctAnswer,
    this.correctIndex,
    required this.language,
    this.difficulty = 'easy',
    this.hint,
    this.audioUrl,
  });

  bool get isMultipleChoice => options != null && options!.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'subtype': subtype,
    'question': question,
    'options': options,
    'correctAnswer': correctAnswer,
    'correctIndex': correctIndex,
    'language': language,
    'difficulty': difficulty,
  };
}

/// Quiz result for a complete quiz session
class QuizSessionResult {
  final String chapterId;
  final int lessonIndex;
  final List<QuizQuestion> questions;
  final int totalQuestions;
  final int correctAnswers;
  final int totalScore;
  final double averageScore;
  final Duration timeTaken;
  final List<String> weakWords;
  final List<String> masteredWords;

  QuizSessionResult({
    required this.chapterId,
    required this.lessonIndex,
    required this.questions,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalScore,
    required this.averageScore,
    required this.timeTaken,
    required this.weakWords,
    required this.masteredWords,
  });

  bool get passed => averageScore >= 60;

  String get grade {
    if (averageScore >= 90) return 'A+';
    if (averageScore >= 80) return 'A';
    if (averageScore >= 70) return 'B';
    if (averageScore >= 60) return 'C';
    if (averageScore >= 50) return 'D';
    return 'F';
  }

  String get emoji {
    if (averageScore >= 90) return '🏆';
    if (averageScore >= 80) return '⭐';
    if (averageScore >= 70) return '👍';
    if (averageScore >= 60) return '👌';
    return '📚';
  }
}

/// Service to generate chapter-wise quizzes using HuggingFace model
class QuizGeneratorService {
  static final Random _random = Random();

  /// Generate quiz for a specific lesson
  static Future<List<QuizQuestion>> generateLessonQuiz({
    required String chapterId,
    required int lessonIndex,
    required String language,
    int questionCount = 10,
    List<QuizType>? types,
  }) async {
    final questions = <QuizQuestion>[];
    final vocabulary = _getVocabulary(chapterId, lessonIndex, language);

    if (vocabulary == null || vocabulary.words.isEmpty) {
      return questions;
    }

    types ??= [QuizType.vocabulary, QuizType.typing, QuizType.matching];

    // Distribute questions across types
    final questionsPerType = (questionCount / types.length).ceil();

    for (var type in types) {
      switch (type) {
        case QuizType.vocabulary:
          questions.addAll(
            _generateVocabularyQuestions(
              vocabulary,
              language,
              questionsPerType,
            ),
          );
          break;
        case QuizType.typing:
          questions.addAll(
            _generateTypingQuestions(vocabulary, language, questionsPerType),
          );
          break;
        case QuizType.matching:
          questions.addAll(
            _generateMatchingQuestions(vocabulary, language, questionsPerType),
          );
          break;
        case QuizType.grammar:
          questions.addAll(
            _generateGrammarQuestions(vocabulary, language, questionsPerType),
          );
          break;
        default:
          break;
      }
    }

    // Shuffle and limit
    questions.shuffle();
    return questions.take(questionCount).toList();
  }

  /// Generate vocabulary quiz (multiple choice)
  static List<QuizQuestion> _generateVocabularyQuestions(
    LessonVocabulary vocabulary,
    String language,
    int count,
  ) {
    final questions = <QuizQuestion>[];
    final words = vocabulary.words;

    for (int i = 0; i < count && i < words.length; i++) {
      final word = words[i];

      // Type 1: English to Native
      final wrongOptions =
          words.where((w) => w.urdu != word.urdu).map((w) => w.urdu).toList()
            ..shuffle();

      final options = [word.urdu, ...wrongOptions.take(3)];
      options.shuffle();

      questions.add(
        QuizQuestion(
          id: 'vocab_${DateTime.now().millisecondsSinceEpoch}_$i',
          type: QuizType.vocabulary,
          subtype: 'english_to_native',
          question:
              'What is "${word.english}" in ${language == 'urdu' ? 'Urdu' : 'Punjabi'}?',
          options: options,
          correctAnswer: word.urdu,
          correctIndex: options.indexOf(word.urdu),
          language: language,
          difficulty: 'easy',
          hint: word.pronunciation,
        ),
      );

      // Type 2: Native to English
      if (i + 1 < count) {
        final wrongEnglish =
            words
                .where((w) => w.english != word.english)
                .map((w) => w.english)
                .toList()
              ..shuffle();

        final engOptions = [word.english, ...wrongEnglish.take(3)];
        engOptions.shuffle();

        questions.add(
          QuizQuestion(
            id: 'vocab_${DateTime.now().millisecondsSinceEpoch}_${i}_rev',
            type: QuizType.vocabulary,
            subtype: 'native_to_english',
            question: 'What does "${word.urdu}" mean?',
            questionUrdu: word.urdu,
            options: engOptions,
            correctAnswer: word.english,
            correctIndex: engOptions.indexOf(word.english),
            language: language,
            difficulty: 'easy',
          ),
        );
      }
    }

    return questions;
  }

  /// Generate typing questions (user types the answer)
  static List<QuizQuestion> _generateTypingQuestions(
    LessonVocabulary vocabulary,
    String language,
    int count,
  ) {
    final questions = <QuizQuestion>[];
    final words = vocabulary.words.toList()..shuffle();

    for (int i = 0; i < count && i < words.length; i++) {
      final word = words[i];

      questions.add(
        QuizQuestion(
          id: 'typing_${DateTime.now().millisecondsSinceEpoch}_$i',
          type: QuizType.typing,
          subtype: 'translate',
          question:
              'Type "${word.english}" in ${language == 'urdu' ? 'Urdu' : 'Punjabi'}:',
          correctAnswer: word.urdu,
          language: language,
          difficulty: 'medium',
          hint: 'Pronunciation: ${word.pronunciation}',
        ),
      );
    }

    return questions;
  }

  /// Generate matching questions
  static List<QuizQuestion> _generateMatchingQuestions(
    LessonVocabulary vocabulary,
    String language,
    int count,
  ) {
    final questions = <QuizQuestion>[];
    final words = vocabulary.words.toList()..shuffle();

    // Create match pairs
    final pairs = words.take(4).toList();
    final nativeWords = pairs.map((w) => w.urdu).toList();
    final englishWords = pairs.map((w) => w.english).toList()..shuffle();

    questions.add(
      QuizQuestion(
        id: 'match_${DateTime.now().millisecondsSinceEpoch}',
        type: QuizType.matching,
        subtype: 'pairs',
        question: 'Match the words:',
        options: [...nativeWords, ...englishWords],
        correctAnswer: pairs.map((w) => '${w.urdu}:${w.english}').join(','),
        language: language,
        difficulty: 'medium',
      ),
    );

    return questions;
  }

  /// Generate grammar questions
  static List<QuizQuestion> _generateGrammarQuestions(
    LessonVocabulary vocabulary,
    String language,
    int count,
  ) {
    final questions = <QuizQuestion>[];

    // Find sentences in vocabulary
    final sentences = vocabulary.words
        .where((w) => w.urdu.split(' ').length > 2)
        .toList();

    for (int i = 0; i < count && i < sentences.length; i++) {
      final sentence = sentences[i];

      // Create grammar validation question
      questions.add(
        QuizQuestion(
          id: 'grammar_${DateTime.now().millisecondsSinceEpoch}_$i',
          type: QuizType.grammar,
          subtype: 'validation',
          question: 'Is this sentence correct?\n"${sentence.urdu}"',
          questionUrdu: sentence.urdu,
          options: ['Yes ✓', 'No ✗'],
          correctAnswer: 'Yes ✓',
          correctIndex: 0,
          language: language,
          difficulty: 'medium',
        ),
      );
    }

    return questions;
  }

  /// Score a quiz answer using HuggingFace model
  static Future<QuizScoreResult> scoreAnswer(
    QuizQuestion question,
    String userAnswer,
  ) async {
    if (question.isMultipleChoice) {
      // For MCQ, check exact match
      final isCorrect = userAnswer == question.correctAnswer;
      return QuizScoreResult(
        score: isCorrect ? 100 : 0,
        feedback: isCorrect ? 'Correct!' : 'Incorrect',
        feedbackUrdu: isCorrect ? 'درست!' : 'غلط',
        emoji: isCorrect ? '✅' : '❌',
        isCorrect: isCorrect,
        confidence: 100,
        userInput: userAnswer,
        correctAnswer: question.correctAnswer,
      );
    } else {
      // For typing questions, use HuggingFace model
      return await HuggingFaceApiService.scoreAnswer(
        userInput: userAnswer,
        correctAnswer: question.correctAnswer,
      );
    }
  }

  /// Calculate quiz session result
  static QuizSessionResult calculateResult({
    required String chapterId,
    required int lessonIndex,
    required List<QuizQuestion> questions,
    required Duration timeTaken,
  }) {
    int correctCount = 0;
    int totalScore = 0;
    final weakWords = <String>[];
    final masteredWords = <String>[];

    for (var q in questions) {
      if (q.scoreResult != null) {
        totalScore += q.scoreResult!.score;
        if (q.scoreResult!.isCorrect) {
          correctCount++;
          masteredWords.add(q.correctAnswer);
        } else {
          weakWords.add(q.correctAnswer);
        }
      }
    }

    final avgScore = questions.isNotEmpty ? totalScore / questions.length : 0.0;

    return QuizSessionResult(
      chapterId: chapterId,
      lessonIndex: lessonIndex,
      questions: questions,
      totalQuestions: questions.length,
      correctAnswers: correctCount,
      totalScore: totalScore,
      averageScore: avgScore,
      timeTaken: timeTaken,
      weakWords: weakWords,
      masteredWords: masteredWords,
    );
  }

  /// Get vocabulary for chapter/lesson
  static LessonVocabulary? _getVocabulary(
    String chapterId,
    int lessonIndex,
    String language,
  ) {
    final lessons = language == 'urdu'
        ? VocabularyData.urduLessons[chapterId]
        : VocabularyData.punjabiLessons[chapterId];

    if (lessons != null && lessonIndex < lessons.length) {
      return lessons[lessonIndex];
    }
    return null;
  }

  /// Generate a mixed quiz with all question types
  static Future<List<QuizQuestion>> generateMixedQuiz({
    required String chapterId,
    required int lessonIndex,
    required String language,
    int questionCount = 10,
  }) async {
    return generateLessonQuiz(
      chapterId: chapterId,
      lessonIndex: lessonIndex,
      language: language,
      questionCount: questionCount,
      types: [QuizType.vocabulary, QuizType.typing, QuizType.grammar],
    );
  }

  /// Generate chapter review quiz (all lessons combined)
  static Future<List<QuizQuestion>> generateChapterReviewQuiz({
    required String chapterId,
    required String language,
    int questionCount = 20,
  }) async {
    final questions = <QuizQuestion>[];

    // Get all lessons in chapter
    final lessons = language == 'urdu'
        ? VocabularyData.urduLessons[chapterId]
        : VocabularyData.punjabiLessons[chapterId];

    if (lessons == null) return questions;

    // Generate questions from each lesson
    final questionsPerLesson = (questionCount / lessons.length).ceil();

    for (int i = 0; i < lessons.length; i++) {
      final lessonQuestions = await generateLessonQuiz(
        chapterId: chapterId,
        lessonIndex: i,
        language: language,
        questionCount: questionsPerLesson,
      );
      questions.addAll(lessonQuestions);
    }

    questions.shuffle();
    return questions.take(questionCount).toList();
  }
}

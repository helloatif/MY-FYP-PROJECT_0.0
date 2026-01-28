import 'package:flutter/foundation.dart';

class Chapter {
  final String id;
  final String title;
  final String description; // English translation/description
  final String language; // 'urdu', 'punjabi'
  final int lessonCount;
  final bool isLocked;
  final double progress;

  Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.lessonCount,
    this.isLocked = true,
    this.progress = 0,
  });
}

class Lesson {
  final String id;
  final String chapterId;
  final String title;
  final String content;
  final List<String> vocabularyWords;
  final String? audioUrl;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.content,
    required this.vocabularyWords,
    this.audioUrl,
    this.isCompleted = false,
  });
}

class Quiz {
  final String id;
  final String lessonId;
  final List<QuizQuestion> questions;
  final bool isCompleted;
  final int score;

  Quiz({
    required this.id,
    required this.lessonId,
    required this.questions,
    this.isCompleted = false,
    this.score = 0,
  });
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String selectedAnswer;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.selectedAnswer = '',
  });
}

class LearningProvider extends ChangeNotifier {
  List<Chapter> _urduChapters = [];
  List<Chapter> _punjabiChapters = [];
  final List<Lesson> _lessons = [];
  final List<Quiz> _quizzes = [];

  // Track completed lessons per chapter (chapterId -> Set of completed lesson indices)
  final Map<String, Set<int>> _completedLessonsPerChapter = {};

  List<Chapter> get urduChapters => _urduChapters;
  List<Chapter> get punjabiChapters => _punjabiChapters;
  List<Lesson> get lessons => _lessons;
  List<Quiz> get quizzes => _quizzes;

  LearningProvider() {
    _initializeChapters();
  }

  void _initializeChapters() {
    // Initialize Urdu Chapters (10 chapters, 5 lessons each = 50 lessons)
    _urduChapters = [
      Chapter(
        id: 'urdu_ch1',
        title: 'بنیادی الفاظ',
        description: 'Basic Words - Learn essential Urdu vocabulary',
        language: 'urdu',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'urdu_ch2',
        title: 'روزمرہ کی گفتگو',
        description: 'Daily Conversation - Common phrases for everyday use',
        language: 'urdu',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'urdu_ch3',
        title: 'قواعد النحو',
        description: 'Grammar Rules - Master Urdu sentence structure',
        language: 'urdu',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'urdu_ch4',
        title: 'مواصلات اور سفر',
        description:
            'Communication & Travel - Navigate and communicate while traveling',
        language: 'urdu',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'urdu_ch5',
        title: 'کھانا اور پکانا',
        description: 'Food & Cooking - Learn food-related vocabulary',
        language: 'urdu',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'urdu_ch6',
        title: 'صحت اور جسم',
        description: 'Health & Body - Medical and body-related terms',
        language: 'urdu',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'urdu_ch7',
        title: 'تعلیم اور سیکھنا',
        description: 'Education & Learning - Academic vocabulary',
        language: 'urdu',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'urdu_ch8',
        title: 'کام اور پیشے',
        description: 'Work & Professions - Career and workplace terms',
        language: 'urdu',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'urdu_ch9',
        title: 'ٹیکنالوجی',
        description: 'Technology - Modern tech vocabulary',
        language: 'urdu',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'urdu_ch10',
        title: 'ثقافت اور مذہب',
        description: 'Culture & Religion - Cultural and religious terms',
        language: 'urdu',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
    ];

    // Initialize Punjabi Chapters (10 chapters, 5 lessons each = 50 lessons)
    _punjabiChapters = [
      Chapter(
        id: 'punjabi_ch1',
        title: 'بنیادی الفاظ',
        description: 'Basic Words - Learn essential Punjabi vocabulary',
        language: 'punjabi',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'punjabi_ch2',
        title: 'روزمرہ دے کم',
        description: 'Daily Tasks - Common phrases for everyday activities',
        language: 'punjabi',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'punjabi_ch3',
        title: 'جذبات',
        description: 'Emotions - Express your feelings in Punjabi',
        language: 'punjabi',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'punjabi_ch4',
        title: 'مواصلات تے سفر',
        description:
            'Communication & Travel - Navigate and communicate while traveling',
        language: 'punjabi',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'punjabi_ch5',
        title: 'کھاݨ پکاݨ',
        description: 'Food & Cooking - Learn food-related vocabulary',
        language: 'punjabi',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'punjabi_ch6',
        title: 'صحت تے جسم',
        description: 'Health & Body - Medical and body-related terms',
        language: 'punjabi',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'punjabi_ch7',
        title: 'پڑھائی',
        description: 'Education - Academic and learning vocabulary',
        language: 'punjabi',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'punjabi_ch8',
        title: 'کم تے پیشے',
        description: 'Work & Professions - Career and workplace terms',
        language: 'punjabi',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'punjabi_ch9',
        title: 'ٹیکنالوجی',
        description: 'Technology - Modern tech vocabulary',
        language: 'punjabi',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
      Chapter(
        id: 'punjabi_ch10',
        title: 'ثقافت تے مذہب',
        description: 'Culture & Religion - Cultural and religious terms',
        language: 'punjabi',
        lessonCount: 5,
        isLocked: false,
        progress: 0,
      ),
    ];
  }

  void addLesson(Lesson lesson) {
    _lessons.add(lesson);
    notifyListeners();
  }

  void completeLesson(String lessonId) {
    final index = _lessons.indexWhere((l) => l.id == lessonId);
    if (index != -1) {
      notifyListeners();
    }
  }

  // Mark a specific lesson in a chapter as completed
  void markLessonCompleted(String chapterId, int lessonIndex) {
    if (!_completedLessonsPerChapter.containsKey(chapterId)) {
      _completedLessonsPerChapter[chapterId] = {};
    }
    _completedLessonsPerChapter[chapterId]!.add(lessonIndex);

    // Update chapter progress
    _updateChapterProgress(chapterId);
    notifyListeners();
  }

  // Get count of completed lessons for a chapter
  int getCompletedLessonsCount(String chapterId) {
    return _completedLessonsPerChapter[chapterId]?.length ?? 0;
  }

  // Check if a specific lesson is completed
  bool isLessonCompleted(String chapterId, int lessonIndex) {
    return _completedLessonsPerChapter[chapterId]?.contains(lessonIndex) ??
        false;
  }

  // Update chapter progress based on completed lessons
  void _updateChapterProgress(String chapterId) {
    final completedCount = getCompletedLessonsCount(chapterId);

    // Find and update the chapter
    for (int i = 0; i < _urduChapters.length; i++) {
      if (_urduChapters[i].id == chapterId) {
        final totalLessons = _urduChapters[i].lessonCount;
        final newProgress = completedCount / totalLessons;
        _urduChapters[i] = Chapter(
          id: _urduChapters[i].id,
          title: _urduChapters[i].title,
          description: _urduChapters[i].description,
          language: _urduChapters[i].language,
          lessonCount: _urduChapters[i].lessonCount,
          isLocked: _urduChapters[i].isLocked,
          progress: newProgress,
        );
        return;
      }
    }

    for (int i = 0; i < _punjabiChapters.length; i++) {
      if (_punjabiChapters[i].id == chapterId) {
        final totalLessons = _punjabiChapters[i].lessonCount;
        final newProgress = completedCount / totalLessons;
        _punjabiChapters[i] = Chapter(
          id: _punjabiChapters[i].id,
          title: _punjabiChapters[i].title,
          description: _punjabiChapters[i].description,
          language: _punjabiChapters[i].language,
          lessonCount: _punjabiChapters[i].lessonCount,
          isLocked: _punjabiChapters[i].isLocked,
          progress: newProgress,
        );
        return;
      }
    }
  }

  void addQuiz(Quiz quiz) {
    _quizzes.add(quiz);
    notifyListeners();
  }

  void completeQuiz(String quizId, int score) {
    final index = _quizzes.indexWhere((q) => q.id == quizId);
    if (index != -1) {
      notifyListeners();
    }
  }

  void unlockNextChapter(String language) {
    if (language == 'urdu') {
      for (int i = 0; i < _urduChapters.length - 1; i++) {
        if (_urduChapters[i].progress >= 100 && _urduChapters[i + 1].isLocked) {
          _urduChapters[i + 1] = Chapter(
            id: _urduChapters[i + 1].id,
            title: _urduChapters[i + 1].title,
            description: _urduChapters[i + 1].description,
            language: _urduChapters[i + 1].language,
            lessonCount: _urduChapters[i + 1].lessonCount,
            isLocked: false,
          );
        }
      }
    } else {
      for (int i = 0; i < _punjabiChapters.length - 1; i++) {
        if (_punjabiChapters[i].progress >= 100 &&
            _punjabiChapters[i + 1].isLocked) {
          _punjabiChapters[i + 1] = Chapter(
            id: _punjabiChapters[i + 1].id,
            title: _punjabiChapters[i + 1].title,
            description: _punjabiChapters[i + 1].description,
            language: _punjabiChapters[i + 1].language,
            lessonCount: _punjabiChapters[i + 1].lessonCount,
            isLocked: false,
          );
        }
      }
    }
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../data/vocabulary_data.dart';

/// Chapter model for organizing learning content
class ChapterModel {
  final String id;
  final String title;
  final String titleEnglish;
  final String description;
  final String language;
  final IconData icon;
  final Color color;
  final int lessonCount;
  final List<String> topics;
  bool isLocked;
  double progress;
  int completedLessons;

  ChapterModel({
    required this.id,
    required this.title,
    required this.titleEnglish,
    required this.description,
    required this.language,
    required this.icon,
    required this.color,
    this.lessonCount = 5,
    this.topics = const [],
    this.isLocked = true,
    this.progress = 0.0,
    this.completedLessons = 0,
  });

  /// Get vocabulary for this chapter
  List<LessonVocabulary> getLessons() {
    if (language == 'urdu') {
      return VocabularyData.urduLessons[id] ?? [];
    } else {
      return VocabularyData.punjabiLessons[id] ?? [];
    }
  }

  /// Get specific lesson
  LessonVocabulary? getLesson(int index) {
    final lessons = getLessons();
    if (index < lessons.length) {
      return lessons[index];
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'titleEnglish': titleEnglish,
    'description': description,
    'language': language,
    'lessonCount': lessonCount,
    'isLocked': isLocked,
    'progress': progress,
    'completedLessons': completedLessons,
  };
}

/// Service to manage chapter-wise learning content
class ChapterService {
  /// Get all Urdu chapters
  static List<ChapterModel> getUrduChapters() {
    return [
      ChapterModel(
        id: 'urdu_ch1',
        title: 'بنیادی الفاظ',
        titleEnglish: 'Basic Words & Greetings',
        description: 'Learn greetings, numbers, colors, and basic vocabulary',
        language: 'urdu',
        icon: Icons.waving_hand,
        color: Colors.green,
        topics: ['Greetings', 'Numbers 1-100', 'Colors', 'Days & Months'],
        isLocked: false,
      ),
      ChapterModel(
        id: 'urdu_ch2',
        title: 'روزمرہ گفتگو',
        titleEnglish: 'Daily Conversation',
        description: 'Common phrases for everyday communication',
        language: 'urdu',
        icon: Icons.chat_bubble,
        color: Colors.blue,
        topics: ['Introductions', 'Questions', 'Directions', 'Weather'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'urdu_ch3',
        title: 'گرامر کی بنیاد',
        titleEnglish: 'Grammar Basics',
        description: 'Pronouns, verbs, and sentence structure',
        language: 'urdu',
        icon: Icons.menu_book,
        color: Colors.purple,
        topics: ['Pronouns', 'Verbs', 'Tenses', 'Sentence Structure'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'urdu_ch4',
        title: 'سفر اور ٹرانسپورٹ',
        titleEnglish: 'Travel & Transport',
        description: 'Vocabulary for traveling and transportation',
        language: 'urdu',
        icon: Icons.directions_car,
        color: Colors.orange,
        topics: ['Vehicles', 'Places', 'Directions', 'Tickets'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'urdu_ch5',
        title: 'کھانا پینا',
        titleEnglish: 'Food & Drinks',
        description: 'Food items, cooking, and restaurant vocabulary',
        language: 'urdu',
        icon: Icons.restaurant,
        color: Colors.red,
        topics: ['Vegetables', 'Fruits', 'Dishes', 'Restaurant'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'urdu_ch6',
        title: 'صحت و طب',
        titleEnglish: 'Health & Body',
        description: 'Body parts, health, and medical terms',
        language: 'urdu',
        icon: Icons.medical_services,
        color: Colors.teal,
        topics: ['Body Parts', 'Symptoms', 'Medicine', 'Hospital'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'urdu_ch7',
        title: 'تعلیم',
        titleEnglish: 'Education',
        description: 'School, studies, and academic vocabulary',
        language: 'urdu',
        icon: Icons.school,
        color: Colors.indigo,
        topics: ['School', 'Subjects', 'Stationery', 'Exams'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'urdu_ch8',
        title: 'کام اور پیشے',
        titleEnglish: 'Work & Professions',
        description: 'Jobs, workplace, and business vocabulary',
        language: 'urdu',
        icon: Icons.work,
        color: Colors.brown,
        topics: ['Professions', 'Office', 'Business', 'Money'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'urdu_ch9',
        title: 'ٹیکنالوجی',
        titleEnglish: 'Technology',
        description: 'Modern technology and digital vocabulary',
        language: 'urdu',
        icon: Icons.computer,
        color: Colors.cyan,
        topics: ['Devices', 'Internet', 'Social Media', 'Apps'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'urdu_ch10',
        title: 'ثقافت و روایات',
        titleEnglish: 'Culture & Traditions',
        description: 'Festivals, family, and cultural vocabulary',
        language: 'urdu',
        icon: Icons.celebration,
        color: Colors.pink,
        topics: ['Festivals', 'Family', 'Traditions', 'Celebrations'],
        isLocked: true,
      ),
    ];
  }

  /// Get all Punjabi chapters
  static List<ChapterModel> getPunjabiChapters() {
    return [
      ChapterModel(
        id: 'punjabi_ch1',
        title: 'بنیادی الفاظ',
        titleEnglish: 'Basic Words & Greetings',
        description: 'Learn greetings, numbers, colors, and basic vocabulary',
        language: 'punjabi',
        icon: Icons.waving_hand,
        color: Colors.green,
        topics: ['Greetings', 'Numbers 1-100', 'Colors', 'Days & Months'],
        isLocked: false,
      ),
      ChapterModel(
        id: 'punjabi_ch2',
        title: 'روزانہ گل بات',
        titleEnglish: 'Daily Conversation',
        description: 'Common phrases for everyday communication',
        language: 'punjabi',
        icon: Icons.chat_bubble,
        color: Colors.blue,
        topics: ['Introductions', 'Questions', 'Directions', 'Weather'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'punjabi_ch3',
        title: 'گرامر دی بنیاد',
        titleEnglish: 'Grammar Basics',
        description: 'Pronouns, verbs, and sentence structure',
        language: 'punjabi',
        icon: Icons.menu_book,
        color: Colors.purple,
        topics: ['Pronouns', 'Verbs', 'Tenses', 'Sentence Structure'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'punjabi_ch4',
        title: 'سفر تے آوا جائی',
        titleEnglish: 'Travel & Transport',
        description: 'Vocabulary for traveling and transportation',
        language: 'punjabi',
        icon: Icons.directions_car,
        color: Colors.orange,
        topics: ['Vehicles', 'Places', 'Directions', 'Tickets'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'punjabi_ch5',
        title: 'کھانا پینا',
        titleEnglish: 'Food & Drinks',
        description: 'Food items, cooking, and restaurant vocabulary',
        language: 'punjabi',
        icon: Icons.restaurant,
        color: Colors.red,
        topics: ['Vegetables', 'Fruits', 'Dishes', 'Restaurant'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'punjabi_ch6',
        title: 'صحت تے جسم',
        titleEnglish: 'Health & Body',
        description: 'Body parts, health, and medical terms',
        language: 'punjabi',
        icon: Icons.medical_services,
        color: Colors.teal,
        topics: ['Body Parts', 'Symptoms', 'Medicine', 'Hospital'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'punjabi_ch7',
        title: 'پڑھائی',
        titleEnglish: 'Education',
        description: 'School, studies, and academic vocabulary',
        language: 'punjabi',
        icon: Icons.school,
        color: Colors.indigo,
        topics: ['School', 'Subjects', 'Stationery', 'Exams'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'punjabi_ch8',
        title: 'کم کاج تے پیشے',
        titleEnglish: 'Work & Professions',
        description: 'Jobs, workplace, and business vocabulary',
        language: 'punjabi',
        icon: Icons.work,
        color: Colors.brown,
        topics: ['Professions', 'Office', 'Business', 'Money'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'punjabi_ch9',
        title: 'ٹیکنالوجی',
        titleEnglish: 'Technology',
        description: 'Modern technology and digital vocabulary',
        language: 'punjabi',
        icon: Icons.computer,
        color: Colors.cyan,
        topics: ['Devices', 'Internet', 'Social Media', 'Apps'],
        isLocked: true,
      ),
      ChapterModel(
        id: 'punjabi_ch10',
        title: 'سبھیاچار تے رواج',
        titleEnglish: 'Culture & Traditions',
        description: 'Festivals, family, and cultural vocabulary',
        language: 'punjabi',
        icon: Icons.celebration,
        color: Colors.pink,
        topics: ['Festivals', 'Family', 'Traditions', 'Celebrations'],
        isLocked: true,
      ),
    ];
  }

  /// Get chapters by language
  static List<ChapterModel> getChapters(String language) {
    if (language == 'urdu') {
      return getUrduChapters();
    } else {
      return getPunjabiChapters();
    }
  }

  /// Get specific chapter
  static ChapterModel? getChapter(String chapterId) {
    final allChapters = [...getUrduChapters(), ...getPunjabiChapters()];
    try {
      return allChapters.firstWhere((c) => c.id == chapterId);
    } catch (e) {
      return null;
    }
  }

  /// Unlock next chapter
  static void unlockNextChapter(
    List<ChapterModel> chapters,
    String currentChapterId,
  ) {
    for (int i = 0; i < chapters.length - 1; i++) {
      if (chapters[i].id == currentChapterId) {
        chapters[i + 1].isLocked = false;
        break;
      }
    }
  }

  /// Calculate overall progress
  static double calculateOverallProgress(List<ChapterModel> chapters) {
    if (chapters.isEmpty) return 0.0;

    double totalProgress = 0;
    for (var chapter in chapters) {
      totalProgress += chapter.progress;
    }
    return totalProgress / chapters.length;
  }
}

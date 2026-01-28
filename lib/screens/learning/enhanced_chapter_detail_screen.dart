import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../providers/learning_provider.dart';
import '../../providers/adaptive_learning_provider.dart';
import '../../data/vocabulary_data.dart';
import 'lesson_screen.dart';
import 'adaptive_quiz_screen.dart';

class EnhancedChapterDetailScreen extends StatelessWidget {
  final Chapter chapter;
  final String language;

  const EnhancedChapterDetailScreen({
    super.key,
    required this.chapter,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    // Get lessons for this chapter from vocabulary data
    final lessonsData = language == 'urdu'
        ? VocabularyData.urduLessons[chapter.id] ?? []
        : VocabularyData.punjabiLessons[chapter.id] ?? [];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundGradientStart,
              AppTheme.backgroundGradientEnd,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryGreen,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppTheme.primaryGreen, AppTheme.darkGreen],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              language == 'urdu'
                                  ? 'URDU CHAPTER'
                                  : 'PUNJABI CHAPTER',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            chapter.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_stories,
                                size: 16,
                                color: AppTheme.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${lessonsData.length} Lessons',
                                style: const TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.stars_rounded,
                                size: 16,
                                color: AppTheme.yellow,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${lessonsData.length * 15} XP Total',
                                style: const TextStyle(
                                  color: AppTheme.yellow,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Progress Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Chapter Progress',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            '${(chapter.progress * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: chapter.progress,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(
                            AppTheme.primaryGreen,
                          ),
                          minHeight: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Lessons List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index >= lessonsData.length) return null;
                  final lessonData = lessonsData[index];
                  final learningProvider = Provider.of<LearningProvider>(
                    context,
                    listen: false,
                  );

                  // First lesson is always unlocked
                  // Subsequent lessons unlock when previous lesson is completed
                  final isCompleted = learningProvider.isLessonCompleted(
                    chapter.id,
                    index,
                  );
                  final isUnlocked =
                      index == 0 ||
                      learningProvider.isLessonCompleted(chapter.id, index - 1);

                  return ModernLessonCard(
                    lessonNumber: index + 1,
                    lessonData: lessonData,
                    isCompleted: isCompleted,
                    isUnlocked: isUnlocked,
                    chapter: chapter,
                    language: language,
                    onTap: isUnlocked
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => LessonScreen(
                                  chapter: chapter,
                                  lessonIndex: index,
                                ),
                              ),
                            );
                          }
                        : null,
                  );
                }, childCount: lessonsData.length),
              ),
            ),

            // Quiz Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Consumer<AdaptiveLearningProvider>(
                  builder: (context, adaptive, _) {
                    final needsRelearning = adaptive.needsRelearning(
                      chapter.id,
                    );
                    final lastScore = adaptive.chapterScores[chapter.id];

                    return Column(
                      children: [
                        if (needsRelearning && lastScore != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.red, width: 2),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.warning_rounded,
                                  color: AppTheme.red,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Review Required',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.red,
                                        ),
                                      ),
                                      Text(
                                        'Last score: $lastScore%. Complete lessons again before retaking quiz.',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.textDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ElevatedButton(
                          onPressed: lessonsData.isEmpty
                              ? null
                              : () {
                                  // Take quiz for the first lesson as a chapter overview
                                  final firstLesson = lessonsData.first;

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => AdaptiveQuizScreen(
                                        chapter: chapter,
                                        lessonData: firstLesson,
                                        lessonNumber: 1,
                                      ),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: needsRelearning
                                ? AppTheme.orange
                                : AppTheme.primaryGreen,
                            foregroundColor: AppTheme.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                needsRelearning
                                    ? Icons.refresh_rounded
                                    : Icons.quiz_rounded,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                needsRelearning
                                    ? 'Retake Quiz'
                                    : 'Take Chapter Quiz',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Bottom spacing
            const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
          ],
        ),
      ),
    );
  }
}

class ModernLessonCard extends StatelessWidget {
  final int lessonNumber;
  final LessonVocabulary lessonData;
  final bool isCompleted;
  final bool isUnlocked;
  final VoidCallback? onTap;
  final Chapter chapter;
  final String language;

  const ModernLessonCard({
    super.key,
    required this.lessonNumber,
    required this.lessonData,
    required this.isCompleted,
    required this.isUnlocked,
    this.onTap,
    required this.chapter,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isCompleted
        ? AppTheme.primaryGreen
        : isUnlocked
        ? AppTheme.blue
        : Colors.grey.shade400;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        elevation: isUnlocked ? 2 : 0,
        shadowColor: statusColor.withOpacity(0.2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
            ),
            child: Row(
              children: [
                // Lesson Number Badge
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$lessonNumber',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      if (isCompleted)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 14,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      if (!isUnlocked)
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white70,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Lesson Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lessonData.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked
                                    ? AppTheme.textDark
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          // Quiz button for completed lessons
                          if (isCompleted)
                            Consumer<AdaptiveLearningProvider>(
                              builder: (context, adaptive, _) {
                                final lessonId =
                                    '${chapter.id}_lesson$lessonNumber';
                                final lastScore =
                                    adaptive.lessonScores[lessonId];
                                final needsReview =
                                    lastScore != null && lastScore < 60;

                                return IconButton(
                                  icon: Icon(
                                    Icons.quiz_rounded,
                                    color: needsReview
                                        ? AppTheme.orange
                                        : AppTheme.blue,
                                    size: 24,
                                  ),
                                  tooltip: 'Take Quiz',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => AdaptiveQuizScreen(
                                          chapter: chapter,
                                          lessonData: lessonData,
                                          lessonNumber: lessonNumber,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.article_rounded,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${lessonData.words.length} words',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.stars_rounded,
                            size: 14,
                            color: AppTheme.orange,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '15 XP',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Icon
                Icon(
                  isCompleted
                      ? Icons.check_circle
                      : isUnlocked
                      ? Icons.play_circle
                      : Icons.lock,
                  color: statusColor,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

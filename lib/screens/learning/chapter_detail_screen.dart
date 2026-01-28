import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../providers/learning_provider.dart';
import 'lesson_screen.dart';

class ChapterDetailScreen extends StatelessWidget {
  final Chapter chapter;
  final String language;

  const ChapterDetailScreen({
    super.key,
    required this.chapter,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: Text(chapter.title),
        backgroundColor: AppTheme.primaryGreen,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Chapter Header Card
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_stories,
                      size: 40,
                      color: AppTheme.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    chapter.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    language == 'urdu' ? 'اردو → English' : 'پنجابی → English',
                    style: const TextStyle(fontSize: 16, color: AppTheme.white),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatChip(
                        icon: Icons.auto_stories,
                        label: '${chapter.lessonCount} lessons',
                      ),
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.stars,
                        label: '${chapter.lessonCount * 10} XP',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: chapter.progress,
                      backgroundColor: AppTheme.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation(AppTheme.white),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(chapter.progress * 100).toInt()}% Complete',
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lessons List
          Expanded(
            child: Consumer<LearningProvider>(
              builder: (context, learningProvider, _) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chapter.lessonCount,
                  itemBuilder: (context, index) {
                    // First lesson is always unlocked
                    // Subsequent lessons unlock when previous lesson is completed
                    final isCompleted = learningProvider.isLessonCompleted(
                      chapter.id,
                      index,
                    );
                    final isLocked =
                        index > 0 &&
                        !learningProvider.isLessonCompleted(
                          chapter.id,
                          index - 1,
                        );

                    return _LessonCard(
                      lessonNumber: index + 1,
                      title: 'Lesson ${index + 1}',
                      isCompleted: isCompleted,
                      isLocked: isLocked,
                      xp: 10,
                      onTap: () {
                        // Navigate to lesson
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LessonScreen(
                              chapter: chapter,
                              lessonIndex: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final int lessonNumber;
  final String title;
  final bool isCompleted;
  final bool isLocked;
  final int xp;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lessonNumber,
    required this.title,
    required this.isCompleted,
    required this.isLocked,
    required this.xp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isLocked ? 0 : 2,
      color: isLocked ? Colors.grey.shade100 : AppTheme.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCompleted
            ? const BorderSide(color: AppTheme.primaryGreen, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.grey.shade300
                      : isCompleted
                      ? AppTheme.primaryGreen.withOpacity(0.2)
                      : Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isLocked
                      ? const Icon(Icons.lock, color: Colors.grey)
                      : isCompleted
                      ? const Icon(
                          Icons.check_circle,
                          color: AppTheme.primaryGreen,
                        )
                      : Text(
                          '$lessonNumber',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isLocked ? Colors.grey : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.stars,
                          size: 16,
                          color: isLocked ? Colors.grey : Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+$xp XP',
                          style: TextStyle(
                            fontSize: 14,
                            color: isLocked
                                ? Colors.grey
                                : AppTheme.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isLocked)
                Icon(
                  isCompleted ? Icons.replay : Icons.arrow_forward_ios,
                  color: isCompleted
                      ? AppTheme.primaryGreen
                      : Colors.grey.shade400,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../providers/learning_provider.dart';
import '../../providers/user_provider.dart';
import 'chapter_detail_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LearningProvider, UserProvider>(
      builder: (context, learning, user, _) {
        final selectedLanguage = user.user?.selectedLanguage ?? 'urdu';
        final chapters = selectedLanguage == 'urdu'
            ? learning.urduChapters
            : learning.punjabiChapters;

        return Scaffold(
          backgroundColor: AppTheme.lightGray,
          body: CustomScrollView(
            slivers: [
              // App Bar with gradient
              SliverAppBar(
                expandedHeight: 180,
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.primaryGreen,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryGreen,
                          AppTheme.primaryGreen.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.language,
                                        size: 16,
                                        color: AppTheme.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        selectedLanguage == 'urdu'
                                            ? 'Urdu → English'
                                            : 'Punjabi → English',
                                        style: const TextStyle(
                                          color: AppTheme.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Your Learning Path',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Learning Path - Duolingo Style
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index >= chapters.length) return null;
                    final chapter = chapters[index];
                    final isLast = index == chapters.length - 1;

                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Column(
                        children: [
                          ChapterNode(
                            chapter: chapter,
                            chapterNumber: index + 1,
                            language: selectedLanguage,
                          ),
                          if (!isLast) const PathConnector(),
                        ],
                      ),
                    );
                  }, childCount: chapters.length),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Duolingo-style Chapter Node
class ChapterNode extends StatelessWidget {
  final Chapter chapter;
  final int chapterNumber;
  final String language;

  const ChapterNode({
    super.key,
    required this.chapter,
    required this.chapterNumber,
    required this.language,
  });

  Color _getProgressColor(double progress) {
    if (progress == 0) return Colors.grey;
    if (progress < 0.5) return Colors.orange;
    if (progress < 1.0) return Colors.blue;
    return AppTheme.primaryGreen;
  }

  IconData _getChapterIcon(int number) {
    final icons = [
      Icons.abc,
      Icons.chat_bubble,
      Icons.family_restroom,
      Icons.restaurant,
      Icons.directions_car,
      Icons.home,
      Icons.work,
      Icons.school,
    ];
    return icons[(number - 1) % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = chapter.progress == 1.0;
    final isLocked = chapter.isLocked;
    final progressColor = _getProgressColor(chapter.progress);

    return InkWell(
      onTap: isLocked
          ? null
          : () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ChapterDetailScreen(chapter: chapter, language: language),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isLocked ? Colors.grey.shade200 : AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted
                ? AppTheme.primaryGreen
                : progressColor.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isLocked
              ? []
              : [
                  BoxShadow(
                    color: progressColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Icon Circle
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: isLocked
                    ? Colors.grey.shade300
                    : progressColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLocked
                    ? Icons.lock
                    : isCompleted
                    ? Icons.check_circle
                    : _getChapterIcon(chapterNumber),
                size: 36,
                color: isLocked ? Colors.grey : progressColor,
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chapter $chapterNumber',
                    style: TextStyle(
                      fontSize: 12,
                      color: isLocked ? Colors.grey : AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chapter.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isLocked ? Colors.grey : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chapter.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isLocked
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.auto_stories,
                        size: 16,
                        color: isLocked ? Colors.grey : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${chapter.lessonCount} lessons',
                        style: TextStyle(
                          fontSize: 14,
                          color: isLocked ? Colors.grey : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.stars,
                        size: 16,
                        color: isLocked ? Colors.grey : Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${chapter.lessonCount * 10} XP',
                        style: TextStyle(
                          fontSize: 14,
                          color: isLocked ? Colors.grey : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  if (!isLocked) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: chapter.progress,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(progressColor),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(chapter.progress * 100).toInt()}% complete',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Path connector between chapters
class PathConnector extends StatelessWidget {
  const PathConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 3,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryGreen.withOpacity(0.3),
              AppTheme.primaryGreen.withOpacity(0.1),
            ],
          ),
        ),
      ),
    );
  }
}

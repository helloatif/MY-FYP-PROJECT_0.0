import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../providers/learning_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/adaptive_learning_provider.dart';
import 'chapter_detail_screen.dart';

class ModernLearnScreen extends StatelessWidget {
  const ModernLearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<LearningProvider, UserProvider, AdaptiveLearningProvider>(
      builder: (context, learning, user, adaptive, _) {
        final selectedLanguage = user.user?.selectedLanguage ?? 'urdu';
        final chapters = selectedLanguage == 'urdu'
            ? learning.urduChapters
            : learning.punjabiChapters;

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
                // Modern App Bar
                SliverAppBar(
                  expandedHeight: 140,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppTheme.primaryGreen,
                  elevation: 0,
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
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    selectedLanguage == 'urdu'
                                        ? Icons.translate
                                        : Icons.language,
                                    color: AppTheme.white,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    selectedLanguage == 'urdu'
                                        ? 'Urdu Learning Path'
                                        : 'Punjabi Learning Path',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.white,
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

                // Learning Path
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index >= chapters.length) return null;
                      final chapter = chapters[index];
                      final isLast = index == chapters.length - 1;
                      final needsRelearning = adaptive.needsRelearning(
                        chapter.id,
                      );
                      final lastScore = adaptive.chapterScores[chapter.id];

                      return Column(
                        children: [
                          ModernChapterCard(
                            chapter: chapter,
                            chapterNumber: index + 1,
                            language: selectedLanguage,
                            needsRelearning: needsRelearning,
                            lastScore: lastScore,
                          ),
                          if (!isLast) const PathConnector(),
                        ],
                      );
                    }, childCount: chapters.length),
                  ),
                ),

                // Bottom spacing
                const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Modern Chapter Card with Progress Indicators
class ModernChapterCard extends StatefulWidget {
  final Chapter chapter;
  final int chapterNumber;
  final String language;
  final bool needsRelearning;
  final int? lastScore;

  const ModernChapterCard({
    super.key,
    required this.chapter,
    required this.chapterNumber,
    required this.language,
    this.needsRelearning = false,
    this.lastScore,
  });

  @override
  State<ModernChapterCard> createState() => _ModernChapterCardState();
}

class _ModernChapterCardState extends State<ModernChapterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    if (widget.needsRelearning) return AppTheme.red;
    if (widget.chapter.progress == 1.0) return AppTheme.primaryGreen;
    if (widget.chapter.progress > 0) return AppTheme.blue;
    return Colors.grey.shade400;
  }

  IconData _getStatusIcon() {
    if (widget.needsRelearning) return Icons.refresh;
    if (widget.chapter.progress == 1.0) return Icons.check_circle;
    if (widget.chapter.progress > 0) return Icons.play_circle;
    return Icons.lock_open;
  }

  String _getStatusText() {
    if (widget.needsRelearning) return 'Review Required';
    if (widget.chapter.progress == 1.0) return 'Completed';
    if (widget.chapter.progress > 0) return 'In Progress';
    return 'Start Learning';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final completedLessons =
        (widget.chapter.progress * widget.chapter.lessonCount).round();

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChapterDetailScreen(
                chapter: widget.chapter,
                language: widget.language,
              ),
            ),
          );
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Progress Background
                Positioned.fill(
                  child: Row(
                    children: [
                      Container(
                        width:
                            MediaQuery.of(context).size.width *
                            widget.chapter.progress,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              statusColor.withOpacity(0.08),
                              statusColor.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Chapter Icon
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              _getChapterIcon(widget.chapterNumber),
                              size: 32,
                              color: statusColor,
                            ),
                            if (widget.chapter.progress == 1.0)
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
                                    size: 16,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Chapter Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Chapter Number Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'CHAPTER ${widget.chapterNumber}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Chapter Title
                            Text(
                              widget.chapter.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Progress Info
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_stories,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$completedLessons/${widget.chapter.lessonCount} lessons',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.stars_rounded,
                                  size: 16,
                                  color: AppTheme.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.chapter.lessonCount * 15} XP',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Status Badge
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getStatusIcon(),
                                        size: 14,
                                        color: statusColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _getStatusText(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.lastScore != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getScoreColor(
                                          widget.lastScore!,
                                        ).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '${widget.lastScore}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: _getScoreColor(
                                            widget.lastScore!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Arrow Icon
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                        color: statusColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score < 60) return AppTheme.red;
    if (score < 80) return AppTheme.orange;
    return AppTheme.primaryGreen;
  }

  IconData _getChapterIcon(int number) {
    final icons = [
      Icons.abc_rounded,
      Icons.chat_bubble_rounded,
      Icons.restaurant_menu_rounded,
      Icons.wb_sunny_rounded,
      Icons.home_rounded,
      Icons.emoji_emotions_rounded,
      Icons.pets_rounded,
      Icons.location_city_rounded,
    ];
    return icons[(number - 1) % icons.length];
  }
}

// Animated Path Connector
class PathConnector extends StatelessWidget {
  const PathConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 3,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 3,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

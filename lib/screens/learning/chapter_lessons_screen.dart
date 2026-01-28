import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../../services/chapter_service.dart';
import '../../data/vocabulary_data.dart';
import 'lesson_content_screen.dart';

/// Screen showing all lessons within a chapter
class ChapterLessonsScreen extends StatefulWidget {
  final ChapterModel chapter;

  const ChapterLessonsScreen({super.key, required this.chapter});

  @override
  State<ChapterLessonsScreen> createState() => _ChapterLessonsScreenState();
}

class _ChapterLessonsScreenState extends State<ChapterLessonsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<LessonVocabulary> _lessons;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    _lessons = widget.chapter.getLessons();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Chapter Header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: widget.chapter.color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.chapter.color,
                      widget.chapter.color.withOpacity(0.7),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Chapter Icon
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              widget.chapter.icon,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Title
                          Text(
                            widget.chapter.titleEnglish,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.chapter.title,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontFamily: 'NotoNastaliqUrdu',
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Progress
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: widget.chapter.progress,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.3,
                                    ),
                                    valueColor: const AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${(widget.chapter.progress * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
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
          ),

          // Chapter Description
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: widget.chapter.color),
                      const SizedBox(width: 8),
                      const Text(
                        'What you\'ll learn',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.chapter.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.chapter.topics.map((topic) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.chapter.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: widget.chapter.color.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          topic,
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.chapter.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Lessons Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.menu_book, color: widget.chapter.color),
                  const SizedBox(width: 8),
                  Text(
                    'Lessons (${_lessons.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lessons List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index >= _lessons.length) return null;

                final lesson = _lessons[index];
                final isLocked =
                    index > 0 && widget.chapter.completedLessons < index;
                final isCompleted = widget.chapter.completedLessons > index;

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(50 * (1 - value), 0),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: _LessonCard(
                    lesson: lesson,
                    lessonNumber: index + 1,
                    chapter: widget.chapter,
                    isLocked: isLocked,
                    isCompleted: isCompleted,
                    onTap: isLocked
                        ? null
                        : () => _navigateToLesson(context, index, lesson),
                  ),
                );
              }, childCount: _lessons.length),
            ),
          ),

          // Chapter Quiz Button
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: widget.chapter.progress >= 0.8
                    ? () => _startChapterQuiz(context)
                    : null,
                icon: const Icon(Icons.quiz),
                label: const Text('Chapter Review Quiz'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.chapter.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
              ),
            ),
          ),

          // Bottom Padding
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  void _navigateToLesson(
    BuildContext context,
    int index,
    LessonVocabulary lesson,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonContentScreen(
          chapter: widget.chapter,
          lessonIndex: index,
          lesson: lesson,
        ),
      ),
    );
  }

  void _startChapterQuiz(BuildContext context) {
    // TODO: Navigate to chapter review quiz
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Complete at least 80% of lessons first!'),
        backgroundColor: widget.chapter.color,
      ),
    );
  }
}

/// Lesson Card Widget
class _LessonCard extends StatelessWidget {
  final LessonVocabulary lesson;
  final int lessonNumber;
  final ChapterModel chapter;
  final bool isLocked;
  final bool isCompleted;
  final VoidCallback? onTap;

  const _LessonCard({
    required this.lesson,
    required this.lessonNumber,
    required this.chapter,
    required this.isLocked,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isLocked ? Colors.grey.shade100 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? AppTheme.primaryGreen
                    : isLocked
                    ? Colors.grey.shade300
                    : chapter.color.withOpacity(0.3),
                width: isCompleted ? 2 : 1,
              ),
              boxShadow: isLocked
                  ? []
                  : [
                      BoxShadow(
                        color: chapter.color.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              children: [
                // Lesson Number Circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? Colors.grey.shade200
                        : isCompleted
                        ? AppTheme.primaryGreen
                        : chapter.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isLocked
                        ? const Icon(Icons.lock, color: Colors.grey, size: 20)
                        : isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : Text(
                            '$lessonNumber',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: chapter.color,
                            ),
                          ),
                  ),
                ),

                const SizedBox(width: 16),

                // Lesson Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isLocked ? Colors.grey : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.text_fields,
                            size: 14,
                            color: isLocked ? Colors.grey : chapter.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${lesson.words.length} words',
                            style: TextStyle(
                              fontSize: 12,
                              color: isLocked ? Colors.grey : Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.timer,
                            size: 14,
                            color: isLocked ? Colors.grey : chapter.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '~5 min',
                            style: TextStyle(
                              fontSize: 12,
                              color: isLocked ? Colors.grey : Colors.black54,
                            ),
                          ),
                        ],
                      ),

                      // Preview words
                      if (!isLocked) ...[
                        const SizedBox(height: 8),
                        Text(
                          lesson.words.take(3).map((w) => w.urdu).join(' • '),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                            fontFamily: 'NotoNastaliqUrdu',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Status Icon
                Icon(
                  isLocked
                      ? Icons.lock_outline
                      : isCompleted
                      ? Icons.check_circle
                      : Icons.play_circle_outline,
                  color: isLocked
                      ? Colors.grey
                      : isCompleted
                      ? AppTheme.primaryGreen
                      : chapter.color,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

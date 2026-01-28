import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../../services/chapter_service.dart';
import '../../services/huggingface_api_service.dart';
import '../../data/vocabulary_data.dart';
import '../../providers/learning_provider.dart';
import 'quiz_screen.dart';

/// Screen showing lesson content with vocabulary and practice
class LessonContentScreen extends StatefulWidget {
  final ChapterModel chapter;
  final int lessonIndex;
  final LessonVocabulary lesson;

  const LessonContentScreen({
    super.key,
    required this.chapter,
    required this.lessonIndex,
    required this.lesson,
  });

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen>
    with TickerProviderStateMixin {
  int _currentWordIndex = 0;
  bool _showTranslation = false;

  // For practice mode
  bool _isPracticeMode = false;
  final TextEditingController _practiceController = TextEditingController();
  int? _practiceScore;
  bool _isCheckingAnswer = false;

  @override
  void dispose() {
    _practiceController.dispose();
    super.dispose();
  }

  VocabWord get _currentWord => widget.lesson.words[_currentWordIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: widget.chapter.color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lesson ${widget.lessonIndex + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.lesson.title,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            actions: [
              // Progress indicator
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentWordIndex + 1}/${widget.lesson.words.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Progress Bar
          SliverToBoxAdapter(
            child: Container(
              color: widget.chapter.color,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentWordIndex + 1) / widget.lesson.words.length,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  minHeight: 8,
                ),
              ),
            ),
          ),

          // Word Card
          SliverFillRemaining(
            child: _isPracticeMode
                ? _buildPracticeMode()
                : _buildLearningMode(),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Previous Button
              if (_currentWordIndex > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _previousWord,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.chapter.color,
                      side: BorderSide(color: widget.chapter.color),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                )
              else
                const Expanded(child: SizedBox()),

              const SizedBox(width: 12),

              // Practice/Learn Toggle
              IconButton(
                onPressed: () {
                  setState(() {
                    _isPracticeMode = !_isPracticeMode;
                    _practiceScore = null;
                    _practiceController.clear();
                  });
                },
                icon: Icon(
                  _isPracticeMode ? Icons.menu_book : Icons.edit_note,
                  color: widget.chapter.color,
                ),
                tooltip: _isPracticeMode
                    ? 'Back to Learning'
                    : 'Practice Writing',
              ),

              const SizedBox(width: 12),

              // Next/Complete Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _currentWordIndex < widget.lesson.words.length - 1
                      ? _nextWord
                      : _completeLessonDialog,
                  icon: Icon(
                    _currentWordIndex < widget.lesson.words.length - 1
                        ? Icons.arrow_forward
                        : Icons.check_circle,
                  ),
                  label: Text(
                    _currentWordIndex < widget.lesson.words.length - 1
                        ? 'Next'
                        : 'Complete',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.chapter.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearningMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Main Word Card
          _buildWordCard(),

          const SizedBox(height: 20),

          // Pronunciation Section
          _buildPronunciationSection(),

          const SizedBox(height: 20),

          // Translation Section (tap to reveal)
          _buildTranslationSection(),

          const SizedBox(height: 20),

          // Quick Actions
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildWordCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.chapter.color,
              widget.chapter.color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: widget.chapter.color.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Word in target language
            Text(
              _currentWord.urdu,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'NotoNastaliqUrdu',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Word type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'vocabulary',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPronunciationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.record_voice_over, color: widget.chapter.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pronunciation',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  _currentWord.pronunciation,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _playPronunciation,
            icon: Icon(Icons.volume_up, color: widget.chapter.color),
            tooltip: 'Listen',
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationSection() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showTranslation = !_showTranslation;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _showTranslation
              ? AppTheme.primaryGreen.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _showTranslation
                ? AppTheme.primaryGreen
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _showTranslation ? Icons.visibility : Icons.visibility_off,
              color: _showTranslation ? AppTheme.primaryGreen : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _showTranslation
                        ? 'English Meaning'
                        : 'Tap to reveal meaning',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _showTranslation ? _currentWord.english : '• • •',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: _showTranslation ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.bookmark_border,
            label: 'Save',
            color: Colors.amber,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Word saved to favorites!')),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.share,
            label: 'Share',
            color: Colors.blue,
            onTap: () {
              // TODO: Implement share
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.flag_outlined,
            label: 'Report',
            color: Colors.red,
            onTap: () {
              // TODO: Implement report
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Practice instruction
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Column(
              children: [
                const Icon(Icons.edit_note, color: Colors.amber, size: 32),
                const SizedBox(height: 8),
                const Text(
                  'Practice Writing',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Write the word "${_currentWord.english}" in ${widget.chapter.language == "urdu" ? "Urdu" : "Punjabi"}',
                  style: const TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Word to translate (English)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.chapter.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'English',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentWord.english,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Text input
          TextField(
            controller: _practiceController,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'NotoNastaliqUrdu',
            ),
            decoration: InputDecoration(
              hintText: 'Type here...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: widget.chapter.color),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: widget.chapter.color, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          // Check Answer Button
          ElevatedButton.icon(
            onPressed: _isCheckingAnswer ? null : _checkAnswer,
            icon: _isCheckingAnswer
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check),
            label: Text(_isCheckingAnswer ? 'Checking...' : 'Check Answer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.chapter.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Score Display
          if (_practiceScore != null) _buildScoreResult(),

          // Show correct answer button
          if (_practiceScore != null && _practiceScore! < 80)
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Correct Answer'),
                    content: Text(
                      _currentWord.urdu,
                      style: const TextStyle(
                        fontSize: 32,
                        fontFamily: 'NotoNastaliqUrdu',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.visibility),
              label: const Text('Show Correct Answer'),
            ),
        ],
      ),
    );
  }

  Widget _buildScoreResult() {
    Color scoreColor;
    String feedback;
    IconData icon;

    if (_practiceScore! >= 80) {
      scoreColor = AppTheme.primaryGreen;
      feedback = 'Excellent! 🎉';
      icon = Icons.celebration;
    } else if (_practiceScore! >= 60) {
      scoreColor = Colors.amber;
      feedback = 'Good job! Keep practicing.';
      icon = Icons.thumb_up;
    } else if (_practiceScore! >= 40) {
      scoreColor = Colors.orange;
      feedback = 'Getting there! Try again.';
      icon = Icons.trending_up;
    } else {
      scoreColor = Colors.red;
      feedback = 'Keep practicing!';
      icon = Icons.refresh;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: scoreColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scoreColor),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: scoreColor),
            const SizedBox(height: 12),
            Text(
              '$_practiceScore%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: scoreColor,
              ),
            ),
            Text(feedback, style: TextStyle(fontSize: 16, color: scoreColor)),
          ],
        ),
      ),
    );
  }

  void _nextWord() {
    if (_currentWordIndex < widget.lesson.words.length - 1) {
      setState(() {
        _currentWordIndex++;
        _showTranslation = false;
        _practiceScore = null;
        _practiceController.clear();
      });
    }
  }

  void _previousWord() {
    if (_currentWordIndex > 0) {
      setState(() {
        _currentWordIndex--;
        _showTranslation = false;
        _practiceScore = null;
        _practiceController.clear();
      });
    }
  }

  void _playPronunciation() async {
    // TODO: Implement TTS pronunciation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pronunciation: ${_currentWord.pronunciation}'),
        backgroundColor: widget.chapter.color,
      ),
    );
  }

  Future<void> _checkAnswer() async {
    if (_practiceController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please type your answer')));
      return;
    }

    setState(() {
      _isCheckingAnswer = true;
    });

    try {
      final result = await HuggingFaceApiService.scoreAnswer(
        userInput: _practiceController.text,
        correctAnswer: _currentWord.urdu,
      );

      setState(() {
        _practiceScore = result.score;
        _isCheckingAnswer = false;
      });
    } catch (e) {
      // Fallback: simple string comparison
      final userAnswer = _practiceController.text.trim();
      final correctAnswer = _currentWord.urdu.trim();

      int score;
      if (userAnswer == correctAnswer) {
        score = 100;
      } else if (correctAnswer.contains(userAnswer) ||
          userAnswer.contains(correctAnswer)) {
        score = 60;
      } else {
        score = 20;
      }

      setState(() {
        _practiceScore = score;
        _isCheckingAnswer = false;
      });
    }
  }

  void _completeLessonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Lesson Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You\'ve learned ${widget.lesson.words.length} new words!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'What would you like to do next?',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to lessons list
            },
            child: const Text('Back to Lessons'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                    chapter: Chapter(
                      id: widget.chapter.id,
                      title: widget.chapter.title,
                      description: widget.chapter.description,
                      language: widget.chapter.language,
                      lessonCount: widget.chapter.lessonCount,
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.quiz),
            label: const Text('Take Quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.chapter.color,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick Action Button Widget
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../providers/learning_provider.dart';
import '../../providers/gamification_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/huggingface_api_service.dart';
import '../../data/vocabulary_data.dart';

/// Quiz Types for different question styles
enum QuizType { vocabulary, grammar, comprehension, mixed }

/// Answer types for quiz questions
enum AnswerType { multipleChoice, fillInBlank, trueFalse, freeText }

/// Enhanced Quiz Question Model
class EnhancedQuizQuestion {
  final String id;
  final String question;
  final List<String>? options;
  final String correctAnswer;
  final String? wordToTranslate;
  final QuizType questionType;
  final AnswerType answerType;
  final String? explanation;
  String selectedAnswer;

  EnhancedQuizQuestion({
    required this.id,
    required this.question,
    this.options,
    required this.correctAnswer,
    this.wordToTranslate,
    this.questionType = QuizType.vocabulary,
    this.answerType = AnswerType.multipleChoice,
    this.explanation,
    this.selectedAnswer = '',
  });
}

class QuizScreen extends StatefulWidget {
  final Chapter chapter;

  const QuizScreen({super.key, required this.chapter});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late List<EnhancedQuizQuestion> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _totalPoints = 0;
  bool _showResult = false;
  bool _isCheckingAnswer = false;
  QuizScoreResult? _lastScoreResult;
  final TextEditingController _answerController = TextEditingController();

  late AnimationController _feedbackAnimationController;
  late Animation<double> _feedbackAnimation;

  // Urdu vocabulary questions - generated from chapter
  List<EnhancedQuizQuestion> _generateUrduQuestions() {
    final chapterId = widget.chapter.id;
    final lessonsList = VocabularyData.urduLessons[chapterId] ?? [];
    final chapterVocab = lessonsList.expand((lesson) => lesson.words).toList();

    if (chapterVocab.isEmpty) {
      // Fallback questions
      return [
        EnhancedQuizQuestion(
          id: '1',
          question: 'What does "سلام" mean in English?',
          options: ['Hello/Peace', 'Goodbye', 'Thank you', 'Sorry'],
          correctAnswer: 'Hello/Peace',
          wordToTranslate: 'سلام',
          questionType: QuizType.vocabulary,
          answerType: AnswerType.multipleChoice,
        ),
        EnhancedQuizQuestion(
          id: '2',
          question: 'Write the Urdu word for "Thank you"',
          correctAnswer: 'شکریہ',
          questionType: QuizType.vocabulary,
          answerType: AnswerType.freeText,
          explanation: 'شکریہ (shukriya) is used to express gratitude',
        ),
        EnhancedQuizQuestion(
          id: '3',
          question: 'Is this sentence correct? "میں اچھا ہوں" (I am fine)',
          options: ['True', 'False'],
          correctAnswer: 'True',
          questionType: QuizType.grammar,
          answerType: AnswerType.trueFalse,
        ),
      ];
    }

    // Generate questions from vocabulary
    List<EnhancedQuizQuestion> questions = [];
    final shuffledVocab = List.from(chapterVocab)..shuffle();

    for (int i = 0; i < shuffledVocab.length.clamp(0, 10); i++) {
      final word = shuffledVocab[i];
      final wrongOptions = chapterVocab
          .where((w) => w.english != word.english)
          .take(3)
          .map((w) => w.english)
          .toList();

      if (i % 3 == 0) {
        // Multiple choice
        questions.add(
          EnhancedQuizQuestion(
            id: 'q_$i',
            question: 'What does "${word.urdu}" mean?',
            options: [word.english, ...wrongOptions]..shuffle(),
            correctAnswer: word.english,
            wordToTranslate: word.urdu,
            questionType: QuizType.vocabulary,
            answerType: AnswerType.multipleChoice,
          ),
        );
      } else if (i % 3 == 1) {
        // Free text - write in Urdu
        questions.add(
          EnhancedQuizQuestion(
            id: 'q_$i',
            question: 'Write "${word.english}" in Urdu',
            correctAnswer: word.urdu,
            questionType: QuizType.vocabulary,
            answerType: AnswerType.freeText,
            explanation: 'Pronunciation: ${word.pronunciation}',
          ),
        );
      } else {
        // Fill in blank
        questions.add(
          EnhancedQuizQuestion(
            id: 'q_$i',
            question: 'Complete: "${word.pronunciation}" is written as ___',
            correctAnswer: word.urdu,
            questionType: QuizType.vocabulary,
            answerType: AnswerType.fillInBlank,
          ),
        );
      }
    }

    return questions.isEmpty ? _getFallbackQuestions('urdu') : questions;
  }

  // Punjabi vocabulary questions
  List<EnhancedQuizQuestion> _generatePunjabiQuestions() {
    final chapterId = widget.chapter.id;
    final lessonsList = VocabularyData.punjabiLessons[chapterId] ?? [];
    final chapterVocab = lessonsList.expand((lesson) => lesson.words).toList();

    if (chapterVocab.isEmpty) {
      return _getFallbackQuestions('punjabi');
    }

    List<EnhancedQuizQuestion> questions = [];
    final shuffledVocab = List.from(chapterVocab)..shuffle();

    for (int i = 0; i < shuffledVocab.length.clamp(0, 10); i++) {
      final word = shuffledVocab[i];
      final wrongOptions = chapterVocab
          .where((w) => w.english != word.english)
          .take(3)
          .map((w) => w.english)
          .toList();

      if (i % 3 == 0) {
        questions.add(
          EnhancedQuizQuestion(
            id: 'q_$i',
            question: 'What does "${word.urdu}" mean?',
            options: [word.english, ...wrongOptions]..shuffle(),
            correctAnswer: word.english,
            wordToTranslate: word.urdu,
            questionType: QuizType.vocabulary,
            answerType: AnswerType.multipleChoice,
          ),
        );
      } else if (i % 3 == 1) {
        questions.add(
          EnhancedQuizQuestion(
            id: 'q_$i',
            question: 'Write "${word.english}" in Punjabi',
            correctAnswer: word.urdu,
            questionType: QuizType.vocabulary,
            answerType: AnswerType.freeText,
            explanation: 'Pronunciation: ${word.pronunciation}',
          ),
        );
      } else {
        questions.add(
          EnhancedQuizQuestion(
            id: 'q_$i',
            question: 'Complete: "${word.pronunciation}" is written as ___',
            correctAnswer: word.urdu,
            questionType: QuizType.vocabulary,
            answerType: AnswerType.fillInBlank,
          ),
        );
      }
    }

    return questions.isEmpty ? _getFallbackQuestions('punjabi') : questions;
  }

  List<EnhancedQuizQuestion> _getFallbackQuestions(String language) {
    if (language == 'urdu') {
      return [
        EnhancedQuizQuestion(
          id: '1',
          question: 'What is the Urdu word for "Hello"?',
          options: ['سلام', 'شکریہ', 'خدا حافظ', 'جی'],
          correctAnswer: 'سلام',
          questionType: QuizType.vocabulary,
          answerType: AnswerType.multipleChoice,
        ),
        EnhancedQuizQuestion(
          id: '2',
          question: 'Write "Thank you" in Urdu',
          correctAnswer: 'شکریہ',
          questionType: QuizType.vocabulary,
          answerType: AnswerType.freeText,
        ),
        EnhancedQuizQuestion(
          id: '3',
          question: '"میں ٹھیک ہوں" means "I am fine"',
          options: ['True', 'False'],
          correctAnswer: 'True',
          questionType: QuizType.grammar,
          answerType: AnswerType.trueFalse,
        ),
      ];
    } else {
      return [
        EnhancedQuizQuestion(
          id: '1',
          question: 'What is the Punjabi greeting?',
          options: ['سلام', 'شکریہ', 'ٹھیک', 'جی'],
          correctAnswer: 'سلام',
          questionType: QuizType.vocabulary,
          answerType: AnswerType.multipleChoice,
        ),
        EnhancedQuizQuestion(
          id: '2',
          question: 'Write "How are you" in Punjabi',
          correctAnswer: 'کی حال اے',
          questionType: QuizType.vocabulary,
          answerType: AnswerType.freeText,
        ),
        EnhancedQuizQuestion(
          id: '3',
          question: '"میں ٹھیک آں" means "I am fine"',
          options: ['True', 'False'],
          correctAnswer: 'True',
          questionType: QuizType.grammar,
          answerType: AnswerType.trueFalse,
        ),
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    _feedbackAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _feedbackAnimation = CurvedAnimation(
      parent: _feedbackAnimationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    _feedbackAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final language = userProvider.currentUser?.selectedLanguage ?? 'urdu';

    _questions = language == 'urdu'
        ? _generateUrduQuestions()
        : _generatePunjabiQuestions();
  }

  Future<void> _answerQuestion(String selectedAnswer) async {
    final currentQuestion = _questions[_currentQuestionIndex];
    currentQuestion.selectedAnswer = selectedAnswer;

    setState(() {
      _isCheckingAnswer = true;
    });

    try {
      // Use ML scoring for free text and fill-in-blank
      if (currentQuestion.answerType == AnswerType.freeText ||
          currentQuestion.answerType == AnswerType.fillInBlank) {
        _lastScoreResult = await HuggingFaceApiService.scoreAnswer(
          userInput: selectedAnswer,
          correctAnswer: currentQuestion.correctAnswer,
        );

        if (_lastScoreResult!.isCorrect) {
          _score++;
        }
        _totalPoints += _lastScoreResult!.score;
      } else {
        // Simple comparison for MCQ and True/False
        if (selectedAnswer == currentQuestion.correctAnswer) {
          _score++;
          _totalPoints += 100;
          _lastScoreResult = QuizScoreResult(
            score: 100,
            feedback: 'Perfect!',
            feedbackUrdu: 'بالکل درست!',
            emoji: '✅',
            isCorrect: true,
            confidence: 100,
            userInput: selectedAnswer,
            correctAnswer: currentQuestion.correctAnswer,
          );
        } else {
          _lastScoreResult = QuizScoreResult(
            score: 0,
            feedback: 'Incorrect',
            feedbackUrdu: 'غلط',
            emoji: '❌',
            isCorrect: false,
            confidence: 100,
            userInput: selectedAnswer,
            correctAnswer: currentQuestion.correctAnswer,
          );
        }
      }

      // Add points to gamification
      Provider.of<GamificationProvider>(
        context,
        listen: false,
      ).addPoints(_lastScoreResult!.score ~/ 10);
    } catch (e) {
      // Fallback if API fails
      if (selectedAnswer == currentQuestion.correctAnswer) {
        _score++;
        _totalPoints += 100;
      }
    }

    setState(() {
      _showResult = true;
      _isCheckingAnswer = false;
    });

    _feedbackAnimationController.forward(from: 0);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (_currentQuestionIndex < _questions.length - 1) {
          setState(() {
            _currentQuestionIndex++;
            _showResult = false;
            _lastScoreResult = null;
            _answerController.clear();
          });
        } else {
          _showCompletionDialog();
        }
      }
    });
  }

  void _showCompletionDialog() {
    final percentage = ((_score / _questions.length) * 100).toInt();
    Provider.of<GamificationProvider>(
      context,
      listen: false,
    ).addPoints(percentage);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: AlertDialog(
          title: Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 6.28, // Full rotation
                    child: child,
                  );
                },
                child: Icon(
                  _totalPoints >= _questions.length * 80
                      ? Icons.emoji_events
                      : Icons.celebration,
                  color: _totalPoints >= _questions.length * 80
                      ? Colors.amber
                      : AppTheme.primaryGreen,
                  size: 32,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _totalPoints >= _questions.length * 80
                    ? 'Excellent!'
                    : 'Quiz Complete!',
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: percentage >= 80
                          ? AppTheme.primaryGreen
                          : percentage >= 60
                          ? Colors.amber
                          : Colors.orange,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$percentage%',
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getGradeLabel(percentage),
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'You answered $_score/${_questions.length} questions correctly',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Total Points: $_totalPoints',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _getFeedbackMessage(percentage),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentQuestionIndex = 0;
                  _score = 0;
                  _totalPoints = 0;
                  _showResult = false;
                  _lastScoreResult = null;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.check),
              label: const Text('Done'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGradeLabel(int percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    return 'D';
  }

  String _getFeedbackMessage(int percentage) {
    if (percentage >= 90) return '🌟 Outstanding! You\'ve mastered this!';
    if (percentage >= 80) return '👏 Great job! Keep it up!';
    if (percentage >= 70) return '👍 Good progress! Practice more.';
    if (percentage >= 60) return '💪 Not bad! Review and try again.';
    return '📚 Keep practicing!';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final language = userProvider.currentUser?.selectedLanguage ?? 'urdu';
    final languageLabel = language == 'urdu' ? 'Urdu' : 'Punjabi';
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('$languageLabel Quiz'),
        backgroundColor: AppTheme.primaryGreen,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => _showExitConfirmation(),
        ),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '$_totalPoints pts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            color: AppTheme.primaryGreen,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        currentQuestion.questionType.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _questions.length,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          // Question Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getQuestionIcon(currentQuestion.questionType),
                          color: AppTheme.primaryGreen,
                          size: 32,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentQuestion.question,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (currentQuestion.wordToTranslate != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              currentQuestion.wordToTranslate!,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                                fontFamily: 'NotoNastaliqUrdu',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Answer Section based on type
                  _buildAnswerSection(currentQuestion),

                  // Feedback Section
                  if (_showResult && _lastScoreResult != null) ...[
                    const SizedBox(height: 24),
                    _buildFeedbackCard(),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Button for text input
          if (currentQuestion.answerType == AnswerType.freeText ||
              currentQuestion.answerType == AnswerType.fillInBlank)
            SafeArea(
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
                child: ElevatedButton(
                  onPressed:
                      _showResult ||
                          _isCheckingAnswer ||
                          _answerController.text.isEmpty
                      ? null
                      : () => _answerQuestion(_answerController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: _isCheckingAnswer
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Check Answer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnswerSection(EnhancedQuizQuestion question) {
    switch (question.answerType) {
      case AnswerType.multipleChoice:
        return _buildMultipleChoice(question);
      case AnswerType.trueFalse:
        return _buildTrueFalse(question);
      case AnswerType.freeText:
      case AnswerType.fillInBlank:
        return _buildTextInput(question);
    }
  }

  Widget _buildMultipleChoice(EnhancedQuizQuestion question) {
    return Column(
      children:
          question.options?.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isCorrect = option == question.correctAnswer;
            final isSelected = question.selectedAnswer == option;

            Color backgroundColor = Colors.white;
            Color borderColor = AppTheme.lightGreen;

            if (_showResult) {
              if (isCorrect) {
                backgroundColor = Colors.green.withOpacity(0.15);
                borderColor = Colors.green;
              } else if (isSelected && !isCorrect) {
                backgroundColor = Colors.red.withOpacity(0.15);
                borderColor = Colors.red;
              }
            } else if (isSelected) {
              backgroundColor = AppTheme.primaryGreen.withOpacity(0.15);
              borderColor = AppTheme.primaryGreen;
            }

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 80)),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: GestureDetector(
                onTap: _showResult || _isCheckingAnswer
                    ? null
                    : () => _answerQuestion(option),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: borderColor,
                      width: isSelected || (_showResult && isCorrect) ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isSelected || (_showResult && isCorrect)
                              ? borderColor
                              : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: _showResult
                              ? Icon(
                                  isCorrect
                                      ? Icons.check
                                      : (isSelected ? Icons.close : null),
                                  color: Colors.white,
                                  size: 20,
                                )
                              : Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList() ??
          [],
    );
  }

  Widget _buildTrueFalse(EnhancedQuizQuestion question) {
    return Row(
      children: ['True', 'False'].map((option) {
        final isCorrect = option == question.correctAnswer;
        final isSelected = question.selectedAnswer == option;
        final isTrue = option == 'True';

        Color backgroundColor = Colors.white;
        Color borderColor = isTrue ? Colors.green : Colors.red;

        if (_showResult) {
          if (isCorrect) {
            backgroundColor = Colors.green.withOpacity(0.15);
          } else if (isSelected && !isCorrect) {
            backgroundColor = Colors.red.withOpacity(0.15);
          }
        }

        return Expanded(
          child: GestureDetector(
            onTap: _showResult || _isCheckingAnswer
                ? null
                : () => _answerQuestion(option),
            child: Container(
              margin: EdgeInsets.only(
                right: isTrue ? 8 : 0,
                left: isTrue ? 0 : 8,
              ),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? borderColor : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isTrue ? Icons.check_circle : Icons.cancel,
                    color: isSelected ? borderColor : Colors.grey,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    option,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? borderColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextInput(EnhancedQuizQuestion question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _answerController,
        enabled: !_showResult,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontSize: 24, fontFamily: 'NotoNastaliqUrdu'),
        decoration: InputDecoration(
          hintText: 'Type your answer in ${widget.chapter.language}...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          border: InputBorder.none,
          suffixIcon: _showResult && _lastScoreResult != null
              ? Icon(
                  _lastScoreResult!.isCorrect
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: _lastScoreResult!.isCorrect
                      ? Colors.green
                      : Colors.orange,
                  size: 28,
                )
              : null,
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildFeedbackCard() {
    final result = _lastScoreResult!;
    final isGood = result.score >= 60;

    return ScaleTransition(
      scale: _feedbackAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isGood
              ? Colors.green.withOpacity(0.1)
              : Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isGood ? Colors.green : Colors.orange),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(result.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.feedback,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isGood ? Colors.green : Colors.orange,
                        ),
                      ),
                      Text(
                        'Score: ${result.score}%',
                        style: TextStyle(
                          color: isGood
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isGood ? Colors.green : Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${result.score}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            if (!result.isCorrect) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Correct: ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: Text(
                        result.correctAnswer,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontFamily: 'NotoNastaliqUrdu',
                          fontSize: 18,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getQuestionIcon(QuizType type) {
    switch (type) {
      case QuizType.vocabulary:
        return Icons.text_fields;
      case QuizType.grammar:
        return Icons.spellcheck;
      case QuizType.comprehension:
        return Icons.menu_book;
      case QuizType.mixed:
        return Icons.shuffle;
    }
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text('Your progress will be lost. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

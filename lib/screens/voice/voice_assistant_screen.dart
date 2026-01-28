import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../providers/user_provider.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  bool _isListening = false;
  bool _isSpeaking = false;
  String _recognizedText = '';
  String _assistantResponse = '';

  // Urdu common phrases
  final List<Map<String, String>> _urduPhrases = [
    {'word': 'السلام علیکم', 'english': 'Peace be upon you', 'emoji': '👋'},
    {'word': 'شکریہ', 'english': 'Thank you', 'emoji': '🙏'},
    {'word': 'براہ کرم', 'english': 'Please', 'emoji': '📍'},
    {'word': 'معافی چاہتا ہوں', 'english': 'I am sorry', 'emoji': '😔'},
    {'word': 'کیسے ہو؟', 'english': 'How are you?', 'emoji': '🤔'},
    {'word': 'میرا نام...ہے', 'english': 'My name is...', 'emoji': '📝'},
  ];

  // Punjabi common phrases
  final List<Map<String, String>> _punjabiPhrases = [
    {'word': 'ست سری اکال', 'english': 'Hello (Sikh greeting)', 'emoji': '👋'},
    {'word': 'شکریہ', 'english': 'Thank you', 'emoji': '🙏'},
    {'word': 'مہربانی نال', 'english': 'Please', 'emoji': '📍'},
    {'word': 'معاف کرو', 'english': 'Sorry', 'emoji': '😔'},
    {'word': 'کی حال اے؟', 'english': 'How are you?', 'emoji': '🤔'},
    {'word': 'میرا ناں...اے', 'english': 'My name is...', 'emoji': '📝'},
  ];

  void _startListening(String language) async {
    setState(() {
      _isListening = true;
      _recognizedText = language == 'urdu' ? 'سن رہے ہیں...' : 'سن رہے آں...';
    });

    // Simulate speech recognition
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _recognizedText = language == 'urdu' ? 'السلام علیکم' : 'ست سری اکال';
        _isListening = false;
      });

      _generateResponse(language);
    }
  }

  void _generateResponse(String language) async {
    setState(() {
      _assistantResponse = language == 'urdu'
          ? 'جواب تیار ہو رہا ہے...'
          : 'جواب تیار ہو رہیا اے...';
      _isSpeaking = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _assistantResponse = language == 'urdu'
            ? 'وعلیکم السلام ورحمة الله وبركاته'
            : 'واہے گرو جی کا خالصہ، واہے گرو جی کی فتح';
        _isSpeaking = false;
      });

      // Simulate speaking
      _speakResponse();
    }
  }

  void _speakResponse() async {
    setState(() {
      _isSpeaking = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final language = userProvider.currentUser?.selectedLanguage ?? 'urdu';
    final phrases = language == 'urdu' ? _urduPhrases : _punjabiPhrases;

    return Scaffold(
      appBar: AppBar(
        title: Text(language == 'urdu' ? 'Learn by Voice' : 'Learn by Voice'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Voice Assistant Area
            Container(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Animated Microphone Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening
                          ? AppTheme.primaryGreen
                          : AppTheme.lightGreen,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: _isListening ? 10 : 0,
                        ),
                      ],
                    ),
                    child: Icon(Icons.mic, size: 60, color: AppTheme.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your Text',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.darkGray),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _recognizedText,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppTheme.primaryGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Assistant Response
                  if (_assistantResponse.isNotEmpty) ...[
                    Text(
                      'Assistant Response',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppTheme.darkGray),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryGreen,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          if (_isSpeaking)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildAnimatedDot(0),
                                const SizedBox(width: 8),
                                _buildAnimatedDot(1),
                                const SizedBox(width: 8),
                                _buildAnimatedDot(2),
                              ],
                            )
                          else
                            Text(
                              _assistantResponse,
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(color: AppTheme.primaryGreen),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isListening
                          ? null
                          : () => _startListening(language),
                      icon: Icon(_isListening ? Icons.stop : Icons.mic),
                      label: Text(_isListening ? 'Listening...' : 'Record'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_assistantResponse.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _speakResponse();
                        },
                        icon: const Icon(Icons.volume_up),
                        label: const Text('Listen Again'),
                      ),
                    ),
                ],
              ),
            ),

            // Common Phrases
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language == 'urdu'
                        ? 'Common Urdu Phrases'
                        : 'Common Punjabi Phrases',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: phrases.length,
                itemBuilder: (context, index) {
                  final phrase = phrases[index];
                  return Card(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _recognizedText = phrase['word']!;
                          _assistantResponse =
                              '${phrase['emoji']} ${phrase['english']}';
                        });
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (mounted) {
                            _speakResponse();
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              phrase['emoji']!,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              phrase['word']!,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDot(int index) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primaryGreen.withValues(alpha: 0.7),
      ),
    );
  }
}

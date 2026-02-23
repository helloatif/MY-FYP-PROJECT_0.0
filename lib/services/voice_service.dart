import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/foundation.dart';

/// Service for Text-to-Speech and Speech-to-Text
class VoiceService {
  static final FlutterTts _flutterTts = FlutterTts();
  static final stt.SpeechToText _speech = stt.SpeechToText();
  static bool _isInitialized = false;

  /// Initialize TTS and STT
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize TTS
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      // Initialize STT
      _isInitialized = await _speech.initialize(
        onError: (error) => debugPrint('STT Error: $error'),
        onStatus: (status) => debugPrint('STT Status: $status'),
      );

      debugPrint('Voice Service initialized: $_isInitialized');
    } catch (e) {
      debugPrint('Voice Service initialization error: $e');
    }
  }

  /// Speak text in specified language
  static Future<void> speak(String text, String language) async {
    try {
      await _flutterTts.setLanguage(_getLanguageCode(language));
      await _flutterTts.setSpeechRate(0.4); // Slower for learning
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('TTS Error: $e');
    }
  }

  /// Stop speaking
  static Future<void> stop() async {
    await _flutterTts.stop();
  }

  /// Listen to user speech
  static Future<String?> listen({
    required String language,
    required Function(String) onResult,
    required Function() onStart,
    required Function() onStop,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (!_speech.isAvailable) {
      debugPrint('Speech recognition not available');
      return null;
    }

    String? recognizedText;

    await _speech.listen(
      onResult: (result) {
        recognizedText = result.recognizedWords;
        onResult(result.recognizedWords);
      },
      localeId: _getLocaleId(language),
      listenMode: stt.ListenMode.confirmation,
    );

    onStart();

    // Wait for listening to complete
    await Future.delayed(const Duration(seconds: 5));

    await _speech.stop();
    onStop();

    return recognizedText;
  }

  /// Check if currently listening
  static bool get isListening => _speech.isListening;

  /// Get available languages for STT
  static Future<List<String>> getAvailableLanguages() async {
    final locales = await _speech.locales();
    return locales.map((locale) => locale.name).toList();
  }

  /// Set speech rate (0.0 to 1.0)
  static Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate.clamp(0.0, 1.0));
  }

  /// Set volume (0.0 to 1.0)
  static Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Get TTS language code
  static String _getLanguageCode(String language) {
    switch (language.toLowerCase()) {
      case 'urdu':
        return 'ur-PK';
      case 'punjabi':
        // Shahmukhi Punjabi uses same script as Urdu; pa-IN is Gurmukhi
        // which is unavailable on most devices, so use Urdu TTS instead
        return 'ur-PK';
      case 'english':
        return 'en-US';
      default:
        return 'en-US';
    }
  }

  /// Get STT locale ID
  static String _getLocaleId(String language) {
    switch (language.toLowerCase()) {
      case 'urdu':
        return 'ur_PK';
      case 'punjabi':
        // Use Urdu locale for Shahmukhi Punjabi speech recognition
        return 'ur_PK';
      case 'english':
        return 'en_US';
      default:
        return 'en_US';
    }
  }

  /// Dispose resources
  static void dispose() {
    _flutterTts.stop();
    _speech.stop();
  }
}

/// Pronunciation scoring service
class PronunciationService {
  /// Compare user pronunciation with expected text
  static Future<double> scorePronunciation({
    required String expected,
    required String spoken,
  }) async {
    // Simple Levenshtein distance-based scoring
    final distance = _levenshteinDistance(
      expected.toLowerCase().trim(),
      spoken.toLowerCase().trim(),
    );

    final maxLength = expected.length > spoken.length
        ? expected.length
        : spoken.length;

    if (maxLength == 0) return 0.0;

    final similarity = 1.0 - (distance / maxLength);
    return (similarity * 100).clamp(0.0, 100.0);
  }

  /// Calculate Levenshtein distance between two strings
  static int _levenshteinDistance(String s1, String s2) {
    final len1 = s1.length;
    final len2 = s2.length;
    final matrix = List.generate(len1 + 1, (i) => List.filled(len2 + 1, 0));

    for (var i = 0; i <= len1; i++) {
      matrix[i][0] = i;
    }

    for (var j = 0; j <= len2; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= len1; i++) {
      for (var j = 1; j <= len2; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[len1][len2];
  }

  /// Get pronunciation feedback
  static String getFeedback(double score) {
    if (score >= 90) return 'Excellent! Perfect pronunciation! 🎉';
    if (score >= 75) return 'Great job! Very good pronunciation! 👍';
    if (score >= 60) return 'Good effort! Keep practicing! 💪';
    if (score >= 40) return 'Not bad! Try again for better results! 🔄';
    return 'Keep practicing! Listen carefully and try again! 📚';
  }
}

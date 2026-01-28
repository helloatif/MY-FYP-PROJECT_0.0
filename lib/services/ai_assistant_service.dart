import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// AI Assistant for language learning help
class AIAssistantService {
  static const String _apiUrl =
      'https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill';
  static const String _apiToken = 'YOUR_HUGGING_FACE_API_TOKEN';

  static final List<Map<String, String>> _conversationHistory = [];

  /// Get AI response for user query
  static Future<String> getResponse(String userMessage) async {
    try {
      // Add user message to history
      _conversationHistory.add({'role': 'user', 'content': userMessage});

      // Build conversation context
      final context = _buildContext();

      final url = Uri.parse(_apiUrl);
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_apiToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': context,
          'parameters': {
            'max_length': 150,
            'temperature': 0.7,
            'do_sample': true,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String aiResponse = '';

        if (data is List && data.isNotEmpty) {
          aiResponse =
              data[0]['generated_text'] ?? 'I\'m here to help you learn!';
        }

        // Add AI response to history
        _conversationHistory.add({'role': 'assistant', 'content': aiResponse});

        // Keep only last 10 messages
        if (_conversationHistory.length > 10) {
          _conversationHistory.removeRange(0, _conversationHistory.length - 10);
        }

        return aiResponse;
      } else {
        return _getOfflineResponse(userMessage);
      }
    } catch (e) {
      debugPrint('AI Assistant Error: $e');
      return _getOfflineResponse(userMessage);
    }
  }

  /// Build conversation context
  static String _buildContext() {
    final buffer = StringBuffer();
    buffer.writeln(
      'You are a helpful language learning assistant specializing in Urdu and Punjabi languages.',
    );
    buffer.writeln(
      'Help users learn vocabulary, grammar, pronunciation, and cultural context.',
    );
    buffer.writeln('');

    for (final message in _conversationHistory) {
      if (message['role'] == 'user') {
        buffer.writeln('User: ${message['content']}');
      } else {
        buffer.writeln('Assistant: ${message['content']}');
      }
    }

    return buffer.toString();
  }

  /// Get offline response when API is unavailable
  static String _getOfflineResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    // Greeting responses
    if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('سلام')) {
      return 'Hello! I\'m your language learning assistant. How can I help you today with Urdu or Punjabi?';
    }

    // Help with pronunciation
    if (lowerMessage.contains('pronounce') ||
        lowerMessage.contains('pronunciation')) {
      return 'To practice pronunciation:\n1. Listen to the audio carefully\n2. Tap the microphone to record\n3. Compare your pronunciation\n4. Practice multiple times!';
    }

    // Translation help
    if (lowerMessage.contains('translate') ||
        lowerMessage.contains('meaning')) {
      return 'I can help you translate! Just ask me "What does [word] mean?" or "How do you say [word] in Urdu/Punjabi?"';
    }

    // Grammar help
    if (lowerMessage.contains('grammar') || lowerMessage.contains('sentence')) {
      return 'Urdu and Punjabi follow Subject-Object-Verb (SOV) word order. For example:\n"I eat food" becomes "میں کھانا کھاتا ہوں" (Main khana khata hoon)';
    }

    // Learning tips
    if (lowerMessage.contains('learn') ||
        lowerMessage.contains('study') ||
        lowerMessage.contains('practice')) {
      return 'Great tips for learning:\n• Practice 15 minutes daily\n• Use flashcards\n• Watch movies/shows\n• Speak with native speakers\n• Don\'t fear mistakes!';
    }

    // Cultural context
    if (lowerMessage.contains('culture') ||
        lowerMessage.contains('tradition')) {
      return 'Language and culture are deeply connected! Understanding Pakistani culture helps you use words in proper context. Would you like to learn about specific traditions?';
    }

    // Default response
    return 'I\'m here to help you learn Urdu and Punjabi! You can ask me about:\n• Word meanings\n• Pronunciation\n• Grammar rules\n• Cultural context\n• Learning tips';
  }

  /// Get learning suggestions based on user level
  static List<String> getSuggestions(int userLevel) {
    if (userLevel <= 3) {
      return [
        'Start with basic greetings',
        'Learn common phrases',
        'Practice pronunciation daily',
        'Use flashcards for vocabulary',
      ];
    } else if (userLevel <= 7) {
      return [
        'Build conversational sentences',
        'Learn verb conjugations',
        'Practice with native speakers',
        'Watch movies with subtitles',
      ];
    } else {
      return [
        'Read Urdu/Punjabi literature',
        'Write short essays',
        'Engage in debates',
        'Teach others what you\'ve learned',
      ];
    }
  }

  /// Get contextual hints for exercises
  static String getHint(String question, String language) {
    // Analyze question and provide contextual hint
    if (question.contains('translate')) {
      return 'Think about the word order: $language uses SOV structure';
    } else if (question.contains('pronounce')) {
      return 'Break the word into syllables and practice each part';
    } else {
      return 'Take your time and think about what you\'ve learned';
    }
  }

  /// Clear conversation history
  static void clearHistory() {
    _conversationHistory.clear();
  }

  /// Get conversation history
  static List<Map<String, String>> getHistory() {
    return List.from(_conversationHistory);
  }
}

/// Chatbot UI message model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

/// Smart learning recommendations
class LearningRecommendationService {
  /// Get personalized recommendations based on user progress
  static List<String> getRecommendations({
    required int completedLessons,
    required int totalPoints,
    required int streak,
    required String weakestArea,
  }) {
    final recommendations = <String>[];

    // Streak recommendations
    if (streak == 0) {
      recommendations.add('🔥 Start a daily learning streak today!');
    } else if (streak < 7) {
      recommendations.add(
        '🔥 Keep going! $streak day streak - aim for 7 days!',
      );
    } else {
      recommendations.add('🔥 Amazing! $streak day streak! You\'re on fire!');
    }

    // Points recommendations
    if (totalPoints < 100) {
      recommendations.add('⭐ Complete more lessons to earn XP points!');
    } else if (totalPoints < 500) {
      recommendations.add('⭐ Great progress! Keep earning points!');
    }

    // Weak area focus
    if (weakestArea.isNotEmpty) {
      recommendations.add('📚 Focus on $weakestArea to improve faster');
    }

    // Practice recommendations
    if (completedLessons % 5 == 0 && completedLessons > 0) {
      recommendations.add('🎯 Time to practice what you\'ve learned!');
    }

    return recommendations;
  }

  /// Get adaptive difficulty level
  static String getDifficultyLevel(double accuracy) {
    if (accuracy >= 0.9) return 'Expert';
    if (accuracy >= 0.75) return 'Advanced';
    if (accuracy >= 0.6) return 'Intermediate';
    if (accuracy >= 0.4) return 'Beginner';
    return 'Novice';
  }
}

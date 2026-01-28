import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Practice',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Keep your skills sharp with daily exercises',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _PracticeCard(
                title: 'Vocabulary Review',
                description: 'Review words you\'ve learned',
                icon: Icons.auto_stories,
                color: Colors.blue,
                xp: 10,
                onTap: () {
                  // Navigate to vocabulary practice
                },
              ),
              const SizedBox(height: 16),
              _PracticeCard(
                title: 'Translation Practice',
                description: 'Translate sentences',
                icon: Icons.translate,
                color: Colors.purple,
                xp: 15,
                onTap: () {
                  // Navigate to translation practice
                },
              ),
              const SizedBox(height: 16),
              _PracticeCard(
                title: 'Listening Exercise',
                description: 'Improve your listening skills',
                icon: Icons.headphones,
                color: Colors.orange,
                xp: 20,
                onTap: () {
                  // Navigate to listening practice
                },
              ),
              const SizedBox(height: 16),
              _PracticeCard(
                title: 'Speaking Challenge',
                description: 'Practice pronunciation',
                icon: Icons.mic,
                color: Colors.red,
                xp: 25,
                onTap: () {
                  // Navigate to speaking practice
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int xp;
  final VoidCallback onTap;

  const _PracticeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.xp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 20),
                  Text(
                    '+$xp XP',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

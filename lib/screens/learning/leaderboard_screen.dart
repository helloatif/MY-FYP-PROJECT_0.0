import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../themes/app_theme.dart';
import '../../providers/user_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _selectedLanguageFilter = 'all'; // 'all', 'urdu', 'punjabi'

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUserEmail = userProvider.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 60,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Top learners this week',
                      style: TextStyle(fontSize: 16, color: AppTheme.white),
                    ),
                    const SizedBox(height: 16),
                    // Language Filter Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildFilterTab('All', 'all'),
                          _buildFilterTab('Urdu', 'urdu'),
                          _buildFilterTab('Punjabi', 'punjabi'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getLeaderboardStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryGreen,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppTheme.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load leaderboard',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 64,
                          color: AppTheme.primaryGreen,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedLanguageFilter == 'all'
                              ? 'No users yet'
                              : 'No ${_selectedLanguageFilter == 'urdu' ? 'Urdu' : 'Punjabi'} learners yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to start learning!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Filter and sort users
                List<QueryDocumentSnapshot> users = snapshot.data!.docs;

                // Sort by totalXP (in case Firestore index is not available)
                users.sort((a, b) {
                  final aXP =
                      (a.data() as Map<String, dynamic>)['totalXP'] ?? 0;
                  final bXP =
                      (b.data() as Map<String, dynamic>)['totalXP'] ?? 0;
                  return bXP.compareTo(aXP);
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userData =
                        users[index].data() as Map<String, dynamic>;
                    final userEmail = userData['email'] ?? '';
                    final userName =
                        userData['displayName'] ??
                        userData['email']?.split('@')[0] ??
                        'User';
                    final xp = userData['totalXP'] ?? 0;
                    final level = _calculateLevel(xp);
                    final isCurrentUser = userEmail == currentUserEmail;
                    final userLang = userData['selectedLanguage'] ?? 'urdu';

                    return _LeaderboardCard(
                      rank: index + 1,
                      name: isCurrentUser ? 'You' : userName,
                      xp: xp,
                      level: level,
                      isCurrentUser: isCurrentUser,
                      language: userLang,
                      showLanguage: _selectedLanguageFilter == 'all',
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

  Widget _buildFilterTab(String label, String value) {
    final isSelected = _selectedLanguageFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguageFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getLeaderboardStream() {
    final collection = FirebaseFirestore.instance.collection('users');

    if (_selectedLanguageFilter == 'all') {
      return collection
          .orderBy('totalXP', descending: true)
          .limit(50)
          .snapshots();
    } else {
      // Filter by selected language
      // Note: This requires a composite index in Firestore
      // If not available, we fetch all and filter client-side
      return collection
          .where('selectedLanguage', isEqualTo: _selectedLanguageFilter)
          .limit(100)
          .snapshots();
    }
  }

  int _calculateLevel(int xp) {
    // Same formula as GamificationProvider
    return (xp / 100).floor() + 1;
  }
}

class _LeaderboardCard extends StatelessWidget {
  final int rank;
  final String name;
  final int xp;
  final int level;
  final bool isCurrentUser;
  final String language;
  final bool showLanguage;

  const _LeaderboardCard({
    required this.rank,
    required this.name,
    required this.xp,
    required this.level,
    required this.isCurrentUser,
    required this.language,
    required this.showLanguage,
  });

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.brown.shade300;
      default:
        return AppTheme.primaryGreen;
    }
  }

  IconData _getRankIcon(int rank) {
    if (rank <= 3) {
      return Icons.emoji_events;
    }
    return Icons.account_circle;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isCurrentUser ? 4 : 2,
      color: isCurrentUser ? AppTheme.primaryGreen.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrentUser
            ? const BorderSide(color: AppTheme.primaryGreen, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getRankColor(rank).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: rank <= 3
                    ? Icon(
                        _getRankIcon(rank),
                        color: _getRankColor(rank),
                        size: 28,
                      )
                    : Text(
                        '$rank',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _getRankColor(rank),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isCurrentUser
                                ? AppTheme.primaryGreen
                                : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'You',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      if (showLanguage) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: language == 'urdu'
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.purple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            language == 'urdu' ? 'Urdu' : 'Punjabi',
                            style: TextStyle(
                              fontSize: 10,
                              color: language == 'urdu'
                                  ? Colors.blue[700]
                                  : Colors.purple[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Level $level • $xp XP',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

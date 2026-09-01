import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../domain/entities/ending.dart';
import '../providers/story_provider.dart';

class EndingsListScreen extends StatefulWidget {
  const EndingsListScreen({super.key});

  @override
  State<EndingsListScreen> createState() => _EndingsListScreenState();
}

class _EndingsListScreenState extends State<EndingsListScreen> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<Map<String, dynamic>> _loadData() async {
    final provider = context.read<StoryProvider>();
    final definitions = await provider.loadEndingDefinitions();
    final unlockedIds = await provider.getUnlockedEndings();
    return {
      'definitions': definitions,
      'unlockedIds': unlockedIds,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whisperWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'ENDINGS',
          style: GoogleFonts.cinzel(
            fontSize: 20.0,
            letterSpacing: 4.0,
            color: AppColors.whisperWhite,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.bloodRed,
                strokeWidth: 2.0,
              ),
            );
          }

          final definitions = (snapshot.data?['definitions'] as List<Ending>?) ?? [];
          final unlockedIds = (snapshot.data?['unlockedIds'] as Set<String>?) ?? {};

          if (definitions.isEmpty) {
            return Center(
              child: Text(
                'No endings registered.',
                style: GoogleFonts.cinzel(color: AppColors.fadedText),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            physics: const BouncingScrollPhysics(),
            itemCount: definitions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16.0),
            itemBuilder: (context, index) {
              final ending = definitions[index];
              final isUnlocked = unlockedIds.contains(ending.nodeId);
              return _buildEndingCard(ending, isUnlocked);
            },
          );
        },
      ),
    );
  }

  Widget _buildEndingCard(Ending ending, bool isUnlocked) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: isUnlocked ? AppColors.bloodRed : AppColors.surface,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isUnlocked ? ending.title : '???',
            style: GoogleFonts.cinzel(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: isUnlocked
                  ? AppColors.whisperWhite
                  : AppColors.fadedText.withValues(alpha: 0.4),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            isUnlocked ? ending.description : 'Undiscovered outcome',
            style: TextStyle(
              fontSize: 13.0,
              height: 1.4,
              color: isUnlocked
                  ? AppColors.fadedText
                  : AppColors.fadedText.withValues(alpha: 0.3),
              fontStyle: isUnlocked ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

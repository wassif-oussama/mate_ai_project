import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'story_interaction_screen.dart';
import '../../app_colors.dart';

class ChildHomeScreen extends StatelessWidget {
  const ChildHomeScreen({super.key});

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  const Text('👦🏻', style: TextStyle(fontSize: 48)),
                  const SizedBox(width: 16),
                  Text('يوسف', style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textAccent)),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 32),
              title: Text('إنجازاتي (Mes succès)', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded, color: Colors.grey, size: 32),
              title: Text('الإعدادات (Paramètres)', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {},
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.exit_to_app_rounded, color: Colors.red, size: 32),
              title: Text('خروج (Quitter)', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _buildSidebar(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: const Text('👦🏻', style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً يا بطل!',
                  style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textAccent),
                ),
                Row(
                  children: const [
                    Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                    Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                    Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StoryInteractionScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.iconAccent, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(color: AppColors.iconAccent.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 80),
                    const SizedBox(height: 16),
                    Text(
                      'ابدأ مغامرة جديدة!',
                      style: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'أصدقاؤك بانتظارك',
              style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF78350F)),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCharacterCard('🦊', 'ثعلوب', const Color(0xFFFECACA)),
                  const SizedBox(width: 16),
                  _buildCharacterCard('🦁', 'ليث', const Color(0xFFFDE68A)),
                  const SizedBox(width: 16),
                  _buildCharacterCard('🐼', 'باندا', const Color(0xFFD1FAE5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard(String emoji, String name, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(name, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
        ],
      ),
    );
  }
}
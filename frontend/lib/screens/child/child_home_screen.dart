import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Tes imports
import 'story_interaction_screen.dart';

// NOS COMPOSANTS DRY
import '../../components/custom_app_bar.dart';
import '../../components/custom_sidebar.dart';

class ChildHomeScreen extends StatelessWidget {
  const ChildHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEB), // amber-50 (Couleur chaude و joyeuse)
      
      // 1. APPEL DE NOTRE MENU LATÉRAL GÉNÉRIQUE EN MODE ENFANT
      drawer: const CustomSidebar(userRole: 'Enfant'), 
      
      // 2. APPEL DE NOTRE APPBAR PERSONNALISÉE (Sans flèche de retour, pour afficher le menu ☰)
      appBar: const CustomAppBar(
        title: 'مرحباً يا بطل!', // "Bonjour le héros !"
        showBackButton: false,
      ),
      
      // 3. LE CORPS DE TA PAGE RESTE INTACT
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Grosse carte d'action principale
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)], // Dégradé Orange
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFF59E0B).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 80),
                    const SizedBox(height: 16),
                    Text(
                      'ابدأ مغامرة جديدة!', // "Commence une nouvelle aventure !"
                      style: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            Text(
              'أصدقاؤك بانتظارك', // "Tes amis t'attendent"
              style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF78350F)),
            ),
            const SizedBox(height: 16),
            
            // Liste horizontale de personnages
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

  // Méthode auxiliaire conservée pour dessiner les cartes d'animaux
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
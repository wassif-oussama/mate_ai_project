import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'story_interaction_screen.dart';

class ChildHomeScreen extends StatelessWidget {
  const ChildHomeScreen({super.key});

  // 1. La méthode _buildSidebar est maintenant correctement placée DANS la classe, 
  // mais À L'EXTÉRIEUR de la méthode build principale.
  // On lui passe le "BuildContext" pour que la navigation (bouton quitter) fonctionne.
  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFFFBEB),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  const Text('👦🏻', style: TextStyle(fontSize: 48)),
                  const SizedBox(width: 16),
                  Text('يوسف', style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFFB45309))),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 32),
              title: Text('إنجازاتي (Mes succès)', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {}, // Ajouter la navigation plus tard
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded, color: Colors.grey, size: 32),
              title: Text('الإعدادات (Paramètres)', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {},
            ),
            const Spacer(),
            // Bouton pour quitter l'espace enfant
            ListTile(
              leading: const Icon(Icons.exit_to_app_rounded, color: Colors.red, size: 32),
              title: Text('خروج (Quitter)', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () {
                // Retour au portail principal de sélection
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
      backgroundColor: const Color(0xFFFFFBEB), // amber-50 (Couleur chaude et joyeuse)
      
      // 2. On attache le menu latéral au Scaffold ici :
      drawer: _buildSidebar(context), 
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            // Avatar de l'enfant
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
                  'مرحباً يا بطل!', // "Bonjour le héros !"
                  style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFFB45309)),
                ),
                // Petites étoiles de récompense
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

  // 3. Cette méthode auxiliaire est également bien placée (dans la classe, hors du build).
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
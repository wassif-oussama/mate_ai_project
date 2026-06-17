import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Imports vers les écrans suivants
import 'parent_home_screen.dart'; // Écran de bienvenue/pré-connexion Parent
import '../child/child_profile_selection_screen.dart'; // Écran "Qui lit aujourd'hui ?" Enfant

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Palette : Fond crème très doux pour éviter la fatigue visuelle
      backgroundColor: const Color(0xFFFFFDF6), 
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 4. Mascotte IA : Un petit robot amical et joyeux
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded, 
                    size: 90, 
                    color: Color(0xFF6C5CE7)
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Titre avec typographie spéciale jeunesse (Baloo Bhaijaan 2)
              Text(
                'مرحباً بك في Mate.ai',
                textAlign: TextAlign.center,
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 42, // Taille augmentée
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6C5CE7), // Violet ludique
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'من سيستخدم التطبيق الآن؟',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 48),

              // Bouton Enfant : Énergie, jeu et effet 3D
              _build3DRoleCard(
                context,
                title: 'أنا بطل خارق!',
                subtitle: 'للعب والتعلم',
                iconOrEmoji: '🦸‍♂️', // ou '🚀'
                mainColor: const Color(0xFFFFB800), // Jaune/Orange vif
                shadowColor: const Color(0xFFE0A300), // Ombre plus foncée pour la 3D
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChildProfileSelectionScreen()),
                  );
                },
              ),
              
              const SizedBox(height: 32),

              // Bouton Parent : Zone sécurisée et rassurante
              _build3DRoleCard(
                context,
                title: 'بوابة الأولياء',
                subtitle: 'المتابعة والإعدادات',
                iconOrEmoji: '🔒', // Cadenas discret pour la sécurité
                mainColor: const Color(0xFF6C5CE7), // Violet doux
                shadowColor: const Color(0xFF5A4BCF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ParentHomeScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Composant Bento Grid : Boutons très arrondis avec effet "3D flat"
  Widget _build3DRoleCard(BuildContext context, {
    required String title,
    required String subtitle,
    required String iconOrEmoji,
    required Color mainColor,
    required Color shadowColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32), // Angles très arrondis
          border: Border.all(color: mainColor.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: shadowColor, 
              offset: const Offset(0, 8), // Décalage vers le bas
              blurRadius: 0, // 0 blur crée l'effet "3D Flat" tactile
            ),
          ],
        ),
        child: Row(
          children: [
            // Conteneur de l'Emoji/Icône
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                iconOrEmoji, 
                style: const TextStyle(fontSize: 38)
              ),
            ),
            const SizedBox(width: 20),
            
            // Textes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.balooBhaijaan2(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: mainColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Flèche indicative
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: mainColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
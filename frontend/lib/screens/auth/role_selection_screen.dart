import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'parent_home_screen.dart';
import '../child/child_home_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo ou Icône de bienvenue
              const Center(
                child: Icon(Icons.diversity_3_rounded, size: 80, color: Color(0xFF4F46E5)),
              ),
              const SizedBox(height: 24),
              
              Text(
                'مرحباً بك في Mate.ai', // Bienvenue dans Mate.ai
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E1B4B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'من سيستخدم التطبيق الآن؟', // Qui utilise l'application maintenant ?
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 56),

              // Carte Enfant (Design ludique)
              _buildRoleCard(
                context,
                title: 'أنا طفل', // Je suis un enfant
                subtitle: 'لألعب وأتعلم!',
                emoji: '🚀',
                color: const Color(0xFFF59E0B), // Orange
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChildHomeScreen()),
                  );
                },
              ),
              
              const SizedBox(height: 24),

              // Carte Parent (Design sérieux)
              _buildRoleCard(
                context,
                title: 'أنا ولي أمر', // Je suis un parent
                subtitle: 'لمتابعة التطور والإعدادات',
                emoji: '👨‍👩‍👧',
                color: const Color(0xFF4F46E5), // Indigo
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

  // Composant réutilisable pour les cartes de sélection
  Widget _buildRoleCard(BuildContext context, {
    required String title,
    required String subtitle,
    required String emoji,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: color.withOpacity(0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 40)),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 24),
          ],
        ),
      ),
    );
  }
}
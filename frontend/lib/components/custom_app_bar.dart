import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import de l'écran de repli (RoleSelectionScreen)
import '../screens/auth/role_selection_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true, // Par défaut, on affiche la flèche
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1E1B4B), // Couleur standard (bleu nuit)
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white), // Pour le bouton menu (hamburger)
      centerTitle: true,
      title: Text(
        title,
        style: GoogleFonts.cairo(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context); // Retour normal
                } else {
                  // Sécurité : retour au choix des rôles si l'historique est vide
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoleSelectionScreen(),
                    ),
                  );
                }
              },
            )
          : null, // Si showBackButton est false, Flutter mettra automatiquement le bouton Menu s'il y a un Drawer
    );
  }

  // Nécessaire pour implémenter PreferredSizeWidget (requis pour une AppBar personnalisée)
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
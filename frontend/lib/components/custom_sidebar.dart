import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../screens/auth/role_selection_screen.dart';

class CustomSidebar extends StatelessWidget {
  final String userRole; // Ex: 'Parent' ou 'Enfant'

  const CustomSidebar({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1E1B4B),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.account_circle, size: 60, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  userRole == 'Parent' ? 'حساب ولي الأمر' : 'حساب الطفل', // Compte Parent / Compte Enfant
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('الرئيسية', style: GoogleFonts.cairo()), // Accueil
            onTap: () {
              Navigator.pop(context); // Ferme le menu
              // Tu peux ajouter une navigation ici si besoin
            },
          ),
          // Ajoute d'autres éléments de menu ici...
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('تسجيل الخروج', style: GoogleFonts.cairo(color: Colors.red)), // Déconnexion
            onTap: () async {
              // 1. Déconnexion via AuthService (supprime le token)
              await AuthService().logout();
              
              // 2. Ferme le menu
              if (!context.mounted) return;
              Navigator.pop(context);
              
              // 3. Retour à l'écran de sélection des rôles
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
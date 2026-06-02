import 'package:flutter/material.dart';
import '../../components/primary_button.dart';
import 'package:google_fonts/google_fonts.dart'; 
// Ajout de l'import pour que l'écran de connexion soit reconnu
import 'parent_login_screen.dart'; 
import 'parent_register_screen.dart';
import '../parent/parent_main_screen.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // slate-50
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo (icône stylisée)
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF), // indigo-100
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, size: 64, color: Color(0xFF4F46E5)),
              ),
              const SizedBox(height: 32),
              
              // Titre Principal
              Text(
                'Mate.ai',
                style: GoogleFonts.cairo(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E1B4B), // indigo-950
                ),
              ),
              const SizedBox(height: 16),
              
              // Sous-titre
              Text(
                'رافق تطور طفلك بكل سهولة\nوبطريقة ذكية وممتعة.',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 64),

              // Boutons de navigation (Erreur corrigée ici)
              PrimaryButton(
                title: 'تسجيل الدخول',
                icon: Icons.login_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ParentLoginScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              PrimaryButton(
                title: 'إنشاء حساب جديد',
                color: const Color(0xFF10B981), 
                icon: Icons.person_add_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ParentRegisterScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
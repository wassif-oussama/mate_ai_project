import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/primary_button.dart';
import '../../components/input_text.dart';
import 'parent_main_screen.dart';

// 1. IMPORT DE NOTRE COMPOSANT APP BAR
import '../../components/custom_app_bar.dart';

class ChildProfileSetupScreen extends StatefulWidget {
  const ChildProfileSetupScreen({super.key});

  @override
  State<ChildProfileSetupScreen> createState() => _ChildProfileSetupScreenState();
}

class _ChildProfileSetupScreenState extends State<ChildProfileSetupScreen> {
  int selectedAvatarIndex = 0;
  
  // Liste d'emojis mignons pour servir d'avatars temporaires
  final List<String> avatars = ['👦🏻', '👧🏽', '🦊', '🦁', '🐻', '🐼'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      
      // 2. UTILISATION DE NOTRE CUSTOM APP BAR
      // On masque la flèche de retour car on ne veut pas que le parent retourne à la page d'inscription
      appBar: const CustomAppBar(
        title: 'ملف الطفل',
        showBackButton: false,
      ),
      
      // Pas de drawer ici car la configuration n'est pas encore terminée
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(
              'لنتعرف على بطلك الصغير!',
              style: GoogleFonts.cairo(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF4F46E5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'اختر شخصية واكتب اسم طفلك لتخصيص تجربته.',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Grille d'avatars
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(avatars.length, (index) {
                bool isSelected = selectedAvatarIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAvatarIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE0E7FF) : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade200,
                        width: isSelected ? 4 : 2,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: const Color(0xFF4F46E5).withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ] : [],
                    ),
                    child: Center(
                      child: Text(
                        avatars[index],
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),

            // Formulaire enfant
            const InputText(
              hintText: 'اسم الطفل (مثال: يوسف)',
              icon: Icons.face_retouching_natural_rounded,
            ),
            const InputText(
              hintText: 'العمر (بالسنوات)',
              icon: Icons.cake_rounded,
            ),

            const SizedBox(height: 48),

            PrimaryButton(
              title: 'بدء المغامرة!',
              icon: Icons.rocket_launch_rounded,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ParentMainScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
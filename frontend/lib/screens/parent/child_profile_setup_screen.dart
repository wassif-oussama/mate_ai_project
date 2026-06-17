import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/primary_button.dart';
import '../../components/input_text.dart';
import 'parent_dashboard_screen.dart';
import 'parent_main_screen.dart';
import '../../app_state.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ملف الطفل',
          style: GoogleFonts.cairo(
            color: const Color(0xFF1E1B4B),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Pas de retour en arrière possible ici
      ),
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
                if (selectedAvatarIndex == 0) {
  AppState.childGender = 'boy';
} else if (selectedAvatarIndex == 1) {
  AppState.childGender = 'girl';
} else {
  AppState.childGender = 'neutral';
}
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/primary_button.dart';
import '../../components/input_text.dart';
// On importe l'écran suivant pour la navigation
import '../parent/child_profile_setup_screen.dart';

class ParentRegisterScreen extends StatelessWidget {
  const ParentRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E1B4B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5), // emerald-100
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.person_add_rounded, size: 40, color: Color(0xFF10B981)), // emerald-500
              ),
              const SizedBox(height: 24),

              Text(
                'إنشاء حساب جديد',
                style: GoogleFonts.cairo(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E1B4B),
                ),
              ),
              Text(
                'انضم إلينا وابدأ رحلة تطور طفلك',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 40),

              // Formulaire complet
              const InputText(
                hintText: 'الاسم الكامل',
                icon: Icons.person_outline_rounded,
              ),
              const InputText(
                hintText: 'البريد الإلكتروني',
                icon: Icons.email_outlined,
              ),
              const InputText(
                hintText: 'كلمة المرور',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              const InputText(
                hintText: 'تأكيد كلمة المرور',
                icon: Icons.lock_reset_rounded,
                isPassword: true,
              ),
              
              const SizedBox(height: 32),

              PrimaryButton(
                title: 'إنشاء الحساب',
                color: const Color(0xFF10B981), // Bouton Vert
                onPressed: () {
                  // Après l'inscription, on l'envoie configurer le profil de l'enfant
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ChildProfileSetupScreen()),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              // Lien vers la connexion si déjà un compte
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      text: 'لديك حساب بالفعل؟ ',
                      style: GoogleFonts.cairo(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: 'تسجيل الدخول',
                          style: GoogleFonts.cairo(color: const Color(0xFF10B981), fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
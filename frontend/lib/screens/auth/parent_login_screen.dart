import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../parent/parent_main_screen.dart';
// IMPORTANT : N'oublie pas de vérifier que le chemin vers auth_service correspond bien à ton dossier
import '../../services/auth_service.dart'; 
// IMPORT DE NOTRE COMPOSANT CUSTOM
import '../../components/custom_app_bar.dart';

class ParentLoginScreen extends StatefulWidget {
  const ParentLoginScreen({super.key});

  @override
  State<ParentLoginScreen> createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  // Contrôleurs pour lire ce que l'utilisateur tape
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false; // Pour afficher le spinner de chargement

  // La fonction magique qui appelle Django
  Future<void> _handleLogin() async {
    // 1. On affiche le chargement
    setState(() {
      _isLoading = true;
    });

    // 2. On appelle notre AuthService
    final authService = AuthService();
    final success = await authService.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    // 3. On arrête le chargement
    setState(() {
      _isLoading = false;
    });

    // 4. Si c'est un succès, on va vers le Dashboard. Sinon, on affiche une erreur.
    if (success) {
      if (!mounted) return;
      // Note: pushReplacement est parfait ici pour écraser la page de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentMainScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('اسم المستخدم أو كلمة المرور غير صحيحة', style: GoogleFonts.cairo()), // "Nom d'utilisateur ou mot de passe incorrect"
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      
      // 1. UTILISATION DE NOTRE CUSTOM APP BAR
      // On laisse le titre vide pour garder le design épuré de ta page de connexion
      appBar: const CustomAppBar(
        title: '', 
        showBackButton: true,
      ),
      
      // ATTENTION: Pas de drawer ici !
      
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Icon(Icons.family_restroom_rounded, size: 80, color: const Color(0xFF4F46E5)),
              const SizedBox(height: 24),
              Text(
                'مرحباً بك مجدداً', // "Bienvenue à nouveau"
                style: GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF1E1B4B)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'سجل دخولك لمتابعة تطور طفلك', // "Connectez-vous pour suivre l'évolution de votre enfant"
                style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Champ Nom d'utilisateur
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'اسم المستخدم (Nom d\'utilisateur)',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Champ Mot de passe
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور (Mot de passe)',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // Bouton de Connexion
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'دخول', // "Entrer"
                          style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
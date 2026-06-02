import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart';

class StoryInteractionScreen extends StatefulWidget {
  const StoryInteractionScreen({super.key});

  @override
  State<StoryInteractionScreen> createState() => _StoryInteractionScreenState();
}

class _StoryInteractionScreenState extends State<StoryInteractionScreen> with SingleTickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;

  // Contrôleur d'animation pour l'onde audio qui s'agrandit
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // 1. Initialisation de l'animation d'expansion visuelle
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(); // L'animation boucle indéfiniment

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // 2. Lancement AUTOMATIQUE du micro dès l'affichage de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutomaticRecording();
    });
  }

  Future<void> _startAutomaticRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        // Nom unique basé sur le timestamp pour éviter d'écraser les fichiers
        final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        setState(() {
          _isRecording = true;
          _audioPath = path;
        });
      }
    } catch (e) {
      debugPrint("Erreur démarrage automatique micro : $e");
    }
  }

  // Arrêt et envoi automatique (déclenché lors du retour ou de la fin de l'histoire)
  Future<void> _stopAndSaveRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _animationController.stop();
      setState(() => _isRecording = false);
      
      if (path != null) {
        debugPrint("✅ Flux audio finalisé : $path");
        await _uploadAudioToServer(path);
      }
    } catch (e) {
      debugPrint("Erreur arrêt micro : $e");
    }
  }

  // La nouvelle fonction qui expédie l'audio à Django
  Future<void> _uploadAudioToServer(String filePath) async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();

      // Préparation de la requête "Multipart" (Pour les fichiers)
      var uri = Uri.parse('${AuthService.baseUrl}/conversation/turn/');
      var request = http.MultipartRequest('POST', uri);

      // Ajout du Token de sécurité
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Ajout de l'ID de la session (Ici codé en dur à '1' pour le test)
      request.fields['session_id'] = '1';

      // Ajout du fichier physique .m4a
      var audioFile = await http.MultipartFile.fromPath('audio_file', filePath);
      request.files.add(audioFile);

      debugPrint("⏳ Envoi de l'audio à l'Agent IA...");
      
      // Envoi de la requête
      var response = await request.send();

      if (response.statusCode == 201) {
        // Lecture de la réponse de l'IA (Texte + Futur Audio)
        var responseData = await response.stream.bytesToString();
        debugPrint("🤖 Réponse de l'Agent Nour : $responseData");
        
        // TODO: Jouer le fichier audio TTS renvoyé par l'IA ici !
      } else {
        debugPrint("❌ Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Erreur d'envoi réseau : $e");
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFFB45309)),
          onPressed: () async {
            await _stopAndSaveRecording();
            if (mounted) Navigator.pop(context);
          },
        ),
        title: Text(
          'مغَامرتِي المَباشِرة',
          style: GoogleFonts.cairo(color: const Color(0xFFB45309), fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Contenu de l'histoire lue par l'agent
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
              ),
              child: SingleChildScrollView(
                child: Text(
                  "كَان يَا مَكان، فِي غَابَةٍ سِحْرِيَّةٍ بَعِيدَةٍ، كَان هُنَاكَ ثَعْلَبٌ صَغِيرٌ يَعِيشُ بَيْنَ الأَشْجَارِ...",
                  style: GoogleFonts.cairo(fontSize: 26, height: 1.8, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ),

          // Zone d'écoute avec l'onde visuelle dynamique qui s'agrandit
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isRecording ? "🎙️ أَنَا أَسْتَمِعُ إِلَيْك الآن..." : "🎙️ تَمَّ حِفْظُ الصَّوْت",
                  style: GoogleFonts.cairo(
                    fontSize: 20, 
                    color: _isRecording ? Colors.red : Colors.green, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 40),
                
                // Animation de l'onde audio grandissante
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Onde externe en expansion (Sécurisée avec .clamp)
                        if (_isRecording)
                          Container(
                            width: 100 * _pulseAnimation.value,
                            height: 100 * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withOpacity(
                                (1.0 - (_pulseAnimation.value - 1.0) / 0.8).clamp(0.0, 1.0),
                              ),
                            ),
                          ),
                        // Bouton Central Fixe
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: _isRecording ? Colors.red : Colors.grey,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              )
                            ],
                          ),
                          child: const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 40),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'الميكروفون مشتعل تلقائياً، تحدث بحرية', // "Le micro est activé automatiquement, parle librement"
                  style: GoogleFonts.cairo(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
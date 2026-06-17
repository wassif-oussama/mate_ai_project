import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

// Tes imports personnalisés
import '../../services/auth_service.dart';
import '../../components/custom_app_bar.dart';

// Définition des états visuels de l'IA
enum NourState { listening, processing, reading }

class StoryInteractionScreen extends StatefulWidget {
  const StoryInteractionScreen({super.key});

  @override
  State<StoryInteractionScreen> createState() => _StoryInteractionScreenState();
}

class _StoryInteractionScreenState extends State<StoryInteractionScreen> with TickerProviderStateMixin {
  // --- LOGIQUE MÉTIER & AUDIO ---
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;
  NourState _currentState = NourState.listening; // Commence par écouter

  // --- ANIMATIONS ---
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _loaderController;

  // --- TEXTE KARAOKÉ ---
  final String _storyText = "كَان يَا مَكان، فِي غَابَةٍ سِحْرِيَّةٍ بَعِيدَةٍ، كَان هُنَاكَ ثَعْلَبٌ صَغِيرٌ يَعِيشُ بَيْنَ الأَشْجَارِ...";

  @override
  void initState() {
    super.initState();
    
    // Animation de l'onde audio (Micro)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    // Animation du loader magique de Nour (Attente API Django)
    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Lancement AUTOMATIQUE du micro
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutomaticRecording();
    });
  }

  // --------------------------------------------------------
  // MÉTHODES DE GESTION AUDIO ET API (Basées sur ton code)
  // --------------------------------------------------------

  Future<void> _startAutomaticRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        if (mounted) {
          setState(() {
            _isRecording = true;
            _audioPath = path;
            _currentState = NourState.listening;
          });
        }
      }
    } catch (e) {
      debugPrint("Erreur démarrage automatique micro : $e");
    }
  }

  Future<void> _stopAndSaveRecording() async {
    try {
      final path = await _audioRecorder.stop();
      if (mounted) {
        setState(() {
          _isRecording = false;
          _currentState = NourState.processing; // Nour réfléchit pendant l'envoi
        });
      }
      
      _loaderController.repeat(); // Lancement visuel du chargement

      if (path != null) {
        debugPrint("✅ Flux audio finalisé : $path");
        await _uploadAudioToServer(path);
      }
    } catch (e) {
      debugPrint("Erreur arrêt micro : $e");
    }
  }

  Future<void> _uploadAudioToServer(String filePath) async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();

      var uri = Uri.parse('${AuthService.baseUrl}/conversation/turn/');
      var request = http.MultipartRequest('POST', uri);

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.fields['session_id'] = '1';

      var audioFile = await http.MultipartFile.fromPath('audio_file', filePath);
      request.files.add(audioFile);

      debugPrint("⏳ Envoi de l'audio à l'Agent IA Django...");
      var response = await request.send();

      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        debugPrint("🤖 Réponse de l'Agent Nour : $responseData");
        
        if (mounted) {
          setState(() {
            _currentState = NourState.reading; // Nour reprend la lecture
            _loaderController.stop();
          });
        }
        // TODO: Jouer le fichier audio TTS renvoyé par l'IA ici
      } else {
        debugPrint("❌ Erreur serveur : ${response.statusCode}");
        if (mounted) setState(() => _currentState = NourState.listening);
      }
    } catch (e) {
      debugPrint("❌ Erreur d'envoi réseau : $e");
      if (mounted) setState(() => _currentState = NourState.listening);
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _pulseController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------
  // INTERFACE UTILISATEUR (Fusion du Design Enfant + Ton Layout)
  // --------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        await _stopAndSaveRecording();
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFF0F172A), // Fond Nuit magique
          appBar: const CustomAppBar(
            title: 'مغَامرتِي المَباشِرة', // Mon aventure en direct
            showBackButton: true,
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildAvatarSection(),
                
                // Zone de l'histoire (Karaoké)
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
                      boxShadow: _currentState == NourState.listening 
                        ? [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)] 
                        : [],
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _storyText,
                        style: GoogleFonts.cairo(
                          fontSize: 26, 
                          height: 1.8, 
                          fontWeight: FontWeight.w700,
                          color: _currentState == NourState.listening ? Colors.white70 : const Color(0xFFFBBF24),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                // Zone du micro réactif (Ton code d'animation adapté au thème)
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isRecording ? "🎙️ أَنَا أَسْتَمِعُ إِلَيْك الآن..." : "⏳ جاري معالجة الصوت...",
                          style: GoogleFonts.cairo(
                            fontSize: 20, 
                            color: _isRecording ? const Color(0xFFEF4444) : const Color(0xFF10B981), 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Clic manuel pour stopper et envoyer (Optionnel mais pratique)
                        GestureDetector(
                          onTap: _isRecording ? _stopAndSaveRecording : null,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (_isRecording)
                                    Container(
                                      width: 100 * _pulseAnimation.value,
                                      height: 100 * _pulseAnimation.value,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFEF4444).withOpacity(
                                          (1.0 - (_pulseAnimation.value - 1.0) / 0.8).clamp(0.0, 1.0),
                                        ),
                                      ),
                                    ),
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: _isRecording ? const Color(0xFFEF4444) : Colors.grey[800],
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: _isRecording ? const Color(0xFFEF4444).withOpacity(0.3) : Colors.transparent,
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        )
                                      ],
                                    ),
                                    child: Icon(
                                      _isRecording ? Icons.graphic_eq_rounded : Icons.mic_off_rounded, 
                                      color: Colors.white, 
                                      size: 40
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Avatar extrait pour garder le build propre
  Widget _buildAvatarSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (_currentState == NourState.processing)
              RotationTransition(
                turns: _loaderController,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFBBF24), width: 3, strokeAlign: BorderSide.strokeAlignOutside),
                  ),
                ),
              ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF97316).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _currentState == NourState.listening ? "😲" : "🦊",
                  style: const TextStyle(fontSize: 45),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _currentState == NourState.reading 
            ? "نور تقرأ..." 
            : _currentState == NourState.listening 
              ? "نور تستمع..." 
              : "نور تفكر...",
          style: GoogleFonts.cairo(color: const Color(0xFFFBBF24), fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
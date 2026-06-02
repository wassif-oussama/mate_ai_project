import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart';
import '../child/story_interaction_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final AuthService _authService = AuthService();

  // Fonction qui récupère les histoires depuis Django
  Future<List<dynamic>> _fetchStories() async {
    final token = await _authService.getToken();
    final url = Uri.parse('${AuthService.baseUrl}/stories/');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Les caractères arabes nécessitent un décodage UTF-8 propre
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Impossible de charger la bibliothèque depuis le serveur');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        title: Text(
          'خزانة القصص', // "Bibliothèque des histoires"
          style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchStories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5)));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'خطأ في الاتصال بالخادم', // Erreur de connexion au serveur
                style: GoogleFonts.cairo(fontSize: 18, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'لا توجد قصص متوفرة حالياً', // Aucune histoire disponible
                style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final stories = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              final double price = double.parse(story['price'].toString());
              final bool isFree = story['is_free'] ?? (price == 0.0);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Badge Domaine (ex: Science, Morale)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E7FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          story['domain'] ?? 'عام',
                          style: GoogleFonts.cairo(color: const Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Titre
                      Text(
                        story['title'] ?? '',
                        style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1E1B4B)),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Prix ou Label Gratuit
                          Text(
                            isFree ? 'مجاني (Gratuit)' : '$price MAD',
                            style: GoogleFonts.cairo(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold, 
                              color: isFree ? Colors.green : const Color(0xFFB45309)
                            ),
                          ),
                          // Bouton d'action principale
                          ElevatedButton(
                            onPressed: () {
                              // Redirection immédiate vers l'interface interactive (avec micro auto)
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const StoryInteractionScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4F46E5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'إقرأ الآن', // "Lire maintenant"
                              style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
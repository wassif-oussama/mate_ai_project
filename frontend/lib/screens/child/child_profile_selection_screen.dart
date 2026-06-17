import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../services/auth_service.dart';
import '../auth/parent_login_screen.dart';
import 'child_home_screen.dart';

// NOTRE NOUVEAU COMPOSANT
import '../../components/custom_app_bar.dart'; 

class ChildProfileSelectionScreen extends StatefulWidget {
  const ChildProfileSelectionScreen({super.key});

  @override
  State<ChildProfileSelectionScreen> createState() => _ChildProfileSelectionScreenState();
}

class _ChildProfileSelectionScreenState extends State<ChildProfileSelectionScreen> {
  final AuthService _authService = AuthService();
  List<dynamic> _children = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChildrenProfiles();
  }

  Future<void> _fetchChildrenProfiles() async {
    try {
      final token = await _authService.getToken();
      
      if (token == null) {
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ParentLoginScreen()));
        return;
      }

      final url = Uri.parse('${AuthService.baseUrl}/children/');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        setState(() {
          _children = jsonDecode(utf8.decode(response.bodyBytes));
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ParentLoginScreen()));
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Erreur récupération profils : $e");
      setState(() => _isLoading = false);
    }
  }

  void _handleProfileTap(dynamic childData) {
    final pinCode = childData['pin_code'];
    
    if (pinCode != null && pinCode.toString().isNotEmpty) {
      _showPinDialog(childData);
    } else {
      _navigateToChildSpace(childData);
    }
  }

  void _showPinDialog(dynamic childData) {
    String enteredPin = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('أدخل الرمز السري', style: GoogleFonts.cairo(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          content: TextField(
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 8),
            onChanged: (val) => enteredPin = val,
            decoration: InputDecoration(
              hintText: '****',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)
                ),
                onPressed: () {
                  if (enteredPin == childData['pin_code'].toString()) {
                    Navigator.pop(context);
                    _navigateToChildSpace(childData);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('الرمز غير صحيح', style: GoogleFonts.cairo()), backgroundColor: Colors.red),
                    );
                  }
                },
                child: Text('دخول', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        );
      }
    );
  }

  void _navigateToChildSpace(dynamic childData) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ChildHomeScreen()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEB),
      
      // 1. UTILISATION DE NOTRE CUSTOM APP BAR
      // On la laisse sans titre pour garder l'aspect épuré
      appBar: const CustomAppBar(
        title: '',
        showBackButton: true,
      ),
      
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFF59E0B)))
        : SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'من يقرأ اليوم؟',
                  style: GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFFB45309)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                if (_children.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        Icon(Icons.sentiment_dissatisfied_rounded, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'لا يوجد أطفال مسجلين.\nاطلب من والديك إضافتك من خلال لوحة التحكم!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 18, 
                            color: Colors.grey[600], 
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Wrap(
                    spacing: 32,
                    runSpacing: 32,
                    alignment: WrapAlignment.center,
                    children: _children.map((child) {
                      return GestureDetector(
                        onTap: () => _handleProfileTap(child),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                              ),
                              child: Center(
                                child: Text(child['avatar_emoji'] ?? '👦🏻', style: const TextStyle(fontSize: 50)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  child['first_name'] ?? '',
                                  style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xFF1E1B4B)),
                                ),
                                if (child['pin_code'] != null && child['pin_code'].toString().isNotEmpty) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.lock_rounded, size: 16, color: Colors.grey),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
    );
  }
}
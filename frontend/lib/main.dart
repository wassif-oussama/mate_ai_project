import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth/role_selection_screen.dart'; 


void main() {
  runApp(const MateAiApp());
}

class MateAiApp extends StatelessWidget {
  const MateAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mate.ai',
      debugShowCheckedModeBanner: false, 
      
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      
      home: const RoleSelectionScreen(), 
    );
  }
}
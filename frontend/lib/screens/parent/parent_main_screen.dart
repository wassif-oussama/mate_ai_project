import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'parent_dashboard_screen.dart';
// Correction du chemin : la bibliothèque est dans le dossier 'shared'
import '../shared/library_screen.dart'; 

class ParentMainScreen extends StatefulWidget {
  const ParentMainScreen({super.key});

  @override
  State<ParentMainScreen> createState() => _ParentMainScreenState();
}

class _ParentMainScreenState extends State<ParentMainScreen> {
  int _currentIndex = 0;

  // Liste des deux écrans complets du parent
  final List<Widget> _pages = [
    const ParentDashboardScreen(),
    const LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // L'IndexedStack affiche la page sans la recharger à chaque clic
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF4F46E5),
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: GoogleFonts.cairo(fontSize: 14),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded, size: 28),
              label: 'لوحة التحكم', // "Tableau de bord"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded, size: 28),
              label: 'المكتبة', // "Bibliothèque"
            ),
          ],
        ),
      ),
    );
  }
}
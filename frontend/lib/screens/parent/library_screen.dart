import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. IMPORT DE NOTRE COMPOSANT APP BAR
import '../../components/custom_app_bar.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String selectedCategory = 'الكل'; // 'Tout' par défaut
  final List<String> categories = ['الكل', 'رياضيات', 'أخلاق', 'علوم', 'مغامرات'];

  final List<Map<String, String>> stories = [
    {'title': 'يوسف والضرب', 'category': 'رياضيات', 'image': '🔢'},
    {'title': 'الصدق منجاة', 'category': 'أخلاق', 'image': '⚖️'},
    {'title': 'كوكب المريخ', 'category': 'علوم', 'image': '🚀'},
  ];

  @override
  Widget build(BuildContext context) {
    // Filtrage propre de la liste avant de l'afficher pour éviter les "trous" dans la grille
    final filteredStories = selectedCategory == 'الكل' 
        ? stories 
        : stories.where((story) => story['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      
      // 2. UTILISATION DE NOTRE CUSTOM APP BAR
      appBar: const CustomAppBar(
        title: 'مكتبة القصص', // "Bibliothèque d'histoires"
        showBackButton: true, // L'enfant/parent peut revenir en arrière
      ),
      
      // Pas de Sidebar ici, c'est un écran de navigation secondaire
      
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Les puces de filtres (Catégories)
          _buildCategoryFilters(),
          
          // La grille des histoires
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredStories.length,
              itemBuilder: (context, index) {
                return _buildStoryCard(filteredStories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategory == categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: isSelected,
              onSelected: (val) => setState(() => selectedCategory = categories[index]),
              selectedColor: const Color(0xFF4F46E5),
              labelStyle: GoogleFonts.cairo(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoryCard(Map<String, String> story) {
    return GestureDetector(
      onTap: () {
        // Tu pourras ajouter ici la navigation vers l'écran de lecture/interaction de cette histoire spécifique
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(story['image']!, style: const TextStyle(fontSize: 50)),
            const SizedBox(height: 12),
            Text(
              story['title']!, 
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              story['category']!, 
              style: GoogleFonts.cairo(color: const Color(0xFF4F46E5), fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
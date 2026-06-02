import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildCategoryFilters()),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final story = stories[index];
                  if (selectedCategory != 'الكل' && story['category'] != selectedCategory) return const SizedBox.shrink();
                  return _buildStoryCard(story);
                },
                childCount: stories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      expandedHeight: 120,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('مكتبة القصص', style: GoogleFonts.cairo(color: const Color(0xFF1E1B4B), fontWeight: FontWeight.bold)),
        centerTitle: false,
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
              labelStyle: GoogleFonts.cairo(color: isSelected ? Colors.white : Colors.black),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoryCard(Map<String, String> story) {
    return Container(
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
          Text(story['title']!, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(story['category']!, style: GoogleFonts.cairo(color: Colors.indigo, fontSize: 14)),
        ],
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  final AuthService _authService = AuthService();
  List<dynamic> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final token = await _authService.getToken();
      final url = Uri.parse('${AuthService.baseUrl}/activities/');
      
      final response = await http.get(url, headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        setState(() {
          _activities = jsonDecode(utf8.decode(response.bodyBytes));
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Erreur chargement indicateurs dashboard : $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        title: Text(
          'لوحة تحكم أداء الطفل',
          style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Graphiques (Utilisation des données réelles ou fallbacks proportionnels)
            Row(
              children: [
                Expanded(child: _buildPieChartSection()),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: _buildLineChartSection()),
              ],
            ),
            const SizedBox(height: 48),
            // Tableau dynamique alimenté par MySQL
            _buildDynamicTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartSection() {
    return Column(
      children: [
        Text('توزيع النشاط التلقائي', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(color: const Color(0xFF1E1B4B), value: 60, title: 'قصص', radius: 80, titleStyle: const TextStyle(color: Colors.white)),
                PieChartSectionData(color: const Color(0xFF818CF8), value: 40, title: 'حوار', radius: 80, titleStyle: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLineChartSection() {
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _activities.isEmpty
                  ? [const FlSpot(0, 0)]
                  : List.generate(_activities.length, (i) => FlSpot(i.toDouble(), double.parse(_activities[i]['duration_minutes'].toString()))),
              color: const Color(0xFF10B981),
              barWidth: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          // En-têtes du tableau mis à jour
          Container(
            color: const Color(0xFF1E1B4B),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Row(
              children: [
                Expanded(flex: 2, child: Center(child: Text('اليوم', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)))), // Jour exact
                Expanded(flex: 3, child: Center(child: Text('القصص المقروءة', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)))), // Noms des histoires
                Expanded(flex: 1, child: Center(child: Text('العدد', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)))), // Nombre
                Expanded(flex: 2, child: Center(child: Text('المدة', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)))), // Minutes
                Expanded(flex: 1, child: Center(child: Text('التركيز', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)))), // Focus Score
              ],
            ),
          ),
          if (_activities.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text('لا توجد بيانات مسجلة بعد', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 16)),
            ),
          // Lignes dynamiques alimentées par MySQL
          ..._activities.map((act) => Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFEDF2F7))),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Center(child: Text(act['session_date'] ?? '', style: GoogleFonts.cairo(fontSize: 13)))),
                    Expanded(
                      flex: 3, 
                      child: Center(
                        child: Text(
                          act['stories_names'] != "" ? act['stories_names'] : 'بدون عنوان', 
                          style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Center(child: Text('${act['stories_completed']}', style: GoogleFonts.cairo()))),
                    Expanded(flex: 2, child: Center(child: Text('${act['duration_minutes']} دقيقة', style: GoogleFonts.cairo()))),
                    Expanded(
                      flex: 1, 
                      child: Center(
                        child: Text(
                          '${act['focus_score']}%', 
                          style: GoogleFonts.cairo(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
  
  
}
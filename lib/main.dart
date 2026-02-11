import 'package:flutter/material.dart';

// 1. The Entry Point: This tells the phone to start the app
void main() {
  runApp(const AdaptiLearnApp());
}

// 2. The App Wrapper: This sets the theme (Colors) for the whole tool
class AdaptiLearnApp extends StatelessWidget {
  const AdaptiLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdaptiLearn Africa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // Uganda's color & educational standard
        useMaterial3: true,
      ),
      // This tells the app to open the ProfileScreen first
      home: const ProfileScreen(), 
    );
  }
}

// 3. The Data Model (Keeps your code clean)
class StudentStats {
  final int totalTests;
  final double overallAccuracy;
  final String bestLevel;
  final int correctAnswers;
  final int totalQuestions;

  StudentStats({
    this.totalTests = 0,
    this.overallAccuracy = 0.0,
    this.bestLevel = 'P1',
    this.correctAnswers = 0,
    this.totalQuestions = 0,
  });

  factory StudentStats.fromMap(Map<String, dynamic> map) {
    return StudentStats(
      totalTests: map['totalTests'] ?? 0,
      overallAccuracy: (map['overallAccuracy'] as num?)?.toDouble() ?? 0.0,
      bestLevel: map['bestLevel'] ?? 'P1',
      correctAnswers: map['correctAnswers'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
    );
  }
}

// 4. The Profile Screen Logic
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StudentStats _stats = StudentStats();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    // Simulating a data fetch (In the future, call your StorageService here)
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (!mounted) return;
    setState(() {
      _stats = StudentStats(
        totalTests: 12,
        overallAccuracy: 0.85,
        bestLevel: 'P4',
        correctAnswers: 120,
        totalQuestions: 140,
      );
      _loading = false;
    });
  }

  // Adaptive Color Helper
  Color _getAdaptiveColor(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.6) return Colors.blue;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Learning Progress'),
        backgroundColor: Colors.green.shade50,
      ),
      body: _loading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeroCard(),
                const SizedBox(height: 16),
                _buildTipsCard(),
              ],
            ),
          ),
    );
  }

  Widget _buildHeroCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Overall Accuracy", style: TextStyle(color: Colors.grey.shade600)),
            Text(
              "${(_stats.overallAccuracy * 100).toInt()}%",
              style: TextStyle(
                fontSize: 48, 
                fontWeight: FontWeight.bold, 
                color: _getAdaptiveColor(_stats.overallAccuracy)
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: _stats.overallAccuracy,
              color: _getAdaptiveColor(_stats.overallAccuracy),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
    return const Card(
      child: ListTile(
        leading: Icon(Icons.lightbulb, color: Colors.amber),
        title: Text("Adaptive Tip"),
        subtitle: Text("Great job on Level P3! Try P4 for a bigger challenge."),
      ),
    );
  }
}

// ============ MAIN APP ============
void main() {
  runApp(UgandaEnglishAssessmentApp());
}

class UgandaEnglishAssessmentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uganda Primary English Assessment',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey.shade50,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ============ ENUMS ============
enum PrimaryLevel { p3, p4, p5, p6, p7 }
enum QuestionCategory { grammar, vocabulary, reading, writing }

// ============ MODELS ============
extension PrimaryLevelExtension on PrimaryLevel {

  String get displayName {
    switch (this) {
      case PrimaryLevel.p3: return 'Primary 3';
      case PrimaryLevel.p4: return 'Primary 4';
      case PrimaryLevel.p5: return 'Primary 5';
      case PrimaryLevel.p6: return 'Primary 6';
      case PrimaryLevel.p7: return 'Primary 7';
    }
  }

  String get shortName {
    return 'P${index + 3}';
  }

  int get numericLevel {
    return index + 3;
  }

  Color get color {
    switch (this) {
      case PrimaryLevel.p3: return Colors.green;
      case PrimaryLevel.p4: return Colors.blue;
      case PrimaryLevel.p5: return Colors.orange;
      case PrimaryLevel.p6: return Colors.purple;
      case PrimaryLevel.p7: return Colors.red;
    }
  }

  Color get lightColor => color.withOpacity(0.1);
}
extension QuestionCategoryExtension on QuestionCategory {

  String get displayName {
    switch (this) {
      case QuestionCategory.grammar: return 'Grammar';
      case QuestionCategory.vocabulary: return 'Vocabulary';
      case QuestionCategory.reading: return 'Reading';
      case QuestionCategory.writing: return 'Writing';
    }
  }

  IconData get icon {
    switch (this) {
      case QuestionCategory.grammar: return Icons.g_translate;
      case QuestionCategory.vocabulary: return Icons.book;
      case QuestionCategory.reading: return Icons.menu_book;
      case QuestionCategory.writing: return Icons.edit;
    }
  }
}


// ============ SESSION MANAGEMENT ============
class SessionManager {
  // ---- Constants ----
  static const int maxSessions = 3;
  static const int questionsPerSession = 10;
  static const int totalSampleQuestions = 30;

  // ---- Storage Keys ----
  static const String _keyCurrentSession = 'current_session';
  static const String _keySampleComplete = 'sample_complete';
  static const String _keyUserLevel = 'user_level';
  static const String _keyTotalTests = 'total_tests';
  static const String _keyTotalQuestions = 'total_questions';
  static const String _keyCorrectAnswers = 'correct_answers';
  static const String _keyBestLevel = 'best_level';

  // ---- Cached SharedPreferences ----
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ---- Session Tracking ----
  static Future<int> getCurrentSession() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_keyCurrentSession) ?? 1;
  }

  static Future<void> setCurrentSession(int session) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_keyCurrentSession, session);
  }

  // ---- Sample Completion ----
  static Future<bool> isSampleComplete() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_keySampleComplete) ?? false;
  }

  static Future<void> markSampleComplete() async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keySampleComplete, true);
  }

  // ---- Reset All Sample Data ----
  static Future<void> resetSample() async {
    final prefs = await _getPrefs();

    await prefs.remove(_keyCurrentSession);
    await prefs.remove(_keySampleComplete);
    await prefs.remove(_keyUserLevel);
    await prefs.remove(_keyTotalTests);
    await prefs.remove(_keyTotalQuestions);
    await prefs.remove(_keyCorrectAnswers);
    await prefs.remove(_keyBestLevel);
  }

  // ---- User Level ----
  static Future<PrimaryLevel?> getUserLevel() async {
    final prefs = await _getPrefs();
    final levelIndex = prefs.getInt(_keyUserLevel);

    if (levelIndex != null &&
        levelIndex >= 0 &&
        levelIndex < PrimaryLevel.values.length) {
      return PrimaryLevel.values[levelIndex];
    }

    return null;
  }

  static Future<void> setUserLevel(PrimaryLevel level) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_keyUserLevel, level.index);
  }

  // ---- Session Progress Summary ----
  static Future<Map<String, dynamic>> getSessionProgress() async {
    final session = await getCurrentSession();
    final completed = await isSampleComplete();

    return {
      'current_session': session,
      'completed_sessions': session > 1 ? session - 1 : 0,
      'total_sessions': maxSessions,
      'is_complete': completed,
      'questions_per_session': questionsPerSession,
      'total_questions': totalSampleQuestions,
    };
  }
}


// ===============================
// P5 ENGLISH ADAPTIVE ENGINE
// Single File Architecture
// ===============================



// -------------------------------
// ENUMS
// -------------------------------

enum QuestionCategory {
  grammar,
  vocabulary,
  reading,
  comprehension,
  writing,
  sentenceStructure,
}

enum Difficulty {
  easy,
  medium,
  hard,
}



// -------------------------------
// QUESTION MODEL
// -------------------------------

class P5Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final QuestionCategory category;
  final Difficulty difficulty;
  final List<String> tags;
  final String curriculumReference;

  P5Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.category,
    required this.difficulty,
    this.tags = const [],
    this.curriculumReference = '',
  });
}



// -------------------------------
// QUESTION SERVICE
// -------------------------------

class P5QuestionService {
  static final List<P5Question> allQuestions = [

    P5Question(
      id: 'g1',
      text: 'She ____ to school every day.',
      options: ['go', 'goes', 'gone', 'going'],
      correctAnswerIndex: 1,
      explanation: 'Singular subject (She) takes "goes".',
      category: QuestionCategory.grammar,
      difficulty: Difficulty.easy,
      tags: ['present tense'],
      curriculumReference: 'P5 English - Tenses',
    ),

    P5Question(
      id: 'v1',
      text: 'Choose the synonym of "rapid".',
      options: ['slow', 'fast', 'weak', 'late'],
      correctAnswerIndex: 1,
      explanation: '"Rapid" means fast.',
      category: QuestionCategory.vocabulary,
      difficulty: Difficulty.medium,
      tags: ['synonyms'],
      curriculumReference: 'P5 English - Vocabulary',
    ),

    P5Question(
      id: 'g2',
      text: 'They have ____ their homework.',
      options: ['finish', 'finishing', 'finished', 'finishes'],
      correctAnswerIndex: 2,
      explanation: 'Present perfect uses past participle: finished.',
      category: QuestionCategory.grammar,
      difficulty: Difficulty.hard,
      tags: ['present perfect'],
      curriculumReference: 'P5 English - Tenses',
    ),
  ];

  static List<P5Question> getQuestionsByDifficulty(Difficulty difficulty) {
    return allQuestions
        .where((q) => q.difficulty == difficulty)
        .toList();
  }
}



// -------------------------------
// ADAPTIVE ENGINE
// -------------------------------

class AdaptiveEngine {
  Difficulty currentDifficulty = Difficulty.medium;

  int correctStreak = 0;
  int wrongStreak = 0;

  void registerAnswer(bool isCorrect) {
    if (isCorrect) {
      correctStreak++;
      wrongStreak = 0;
    } else {
      wrongStreak++;
      correctStreak = 0;
    }

    _adjustDifficulty();
  }

  void _adjustDifficulty() {
    if (correctStreak >= 2) {
      _increaseDifficulty();
      correctStreak = 0;
    }

    if (wrongStreak >= 2) {
      _decreaseDifficulty();
      wrongStreak = 0;
    }
  }

  void _increaseDifficulty() {
    if (currentDifficulty == Difficulty.easy) {
      currentDifficulty = Difficulty.medium;
    } else if (currentDifficulty == Difficulty.medium) {
      currentDifficulty = Difficulty.hard;
    }
  }

  void _decreaseDifficulty() {
    if (currentDifficulty == Difficulty.hard) {
      currentDifficulty = Difficulty.medium;
    } else if (currentDifficulty == Difficulty.medium) {
      currentDifficulty = Difficulty.easy;
    }
  }
}



// -------------------------------
// SESSION MANAGER
// -------------------------------

class P5SessionManager {
  final AdaptiveEngine adaptiveEngine = AdaptiveEngine();

  int totalQuestions = 0;
  int correctAnswers = 0;

  P5Question? currentQuestion;

  void startSession() {
    totalQuestions = 0;
    correctAnswers = 0;
  }

  P5Question getNextQuestion() {
    final questions =
        P5QuestionService.getQuestionsByDifficulty(
            adaptiveEngine.currentDifficulty);

    questions.shuffle();

    currentQuestion = questions.first;
    return currentQuestion!;
  }

  void submitAnswer(int selectedIndex) {
    if (currentQuestion == null) return;

    bool isCorrect =
        selectedIndex == currentQuestion!.correctAnswerIndex;

    if (isCorrect) correctAnswers++;

    totalQuestions++;

    adaptiveEngine.registerAnswer(isCorrect);
  }

  double get accuracy {
    if (totalQuestions == 0) return 0;
    return correctAnswers / totalQuestions;
  }
}

// ============ WIDGETS ============
class LevelBadge extends StatelessWidget {
  final PrimaryLevel level;
  final bool compact;
  
  const LevelBadge({
    Key? key,
    required this.level,
    this.compact = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppExtensions.getLevelColor(level).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppExtensions.getLevelColor(level), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppExtensions.getLevelColor(level),
              shape: BoxShape.circle,
            ),
          ),
          if (!compact) const SizedBox(width: 6),
          if (!compact)
            Text(
              AppExtensions.getLevelShortName(level),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppExtensions.getLevelColor(level),
              ),
            ),
        ],
      ),
    );
  }
}

class UgandanQuestionCard extends StatelessWidget {
  final UgandanQuestion question;
  final bool showDetails;
  
  const UgandanQuestionCard({
    Key? key,
    required this.question,
    this.showDetails = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                LevelBadge(level: question.level),
                const SizedBox(width: 8),
                Chip(
                  label: Text(AppExtensions.getCategoryName(question.category)),
                  backgroundColor: Colors.grey.shade100,
                  avatar: Icon(AppExtensions.getCategoryIcon(question.category), size: 16),
                ),
                const Spacer(),
                if (question.timesUsed > 0)
                  Text(
                    'Used ${question.timesUsed}×',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              question.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            
            if (showDetails) ...[
              const SizedBox(height: 16),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Options:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...question.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isCorrect = index == question.correctAnswerIndex;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCorrect ? Colors.green.shade50 : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isCorrect ? Colors.green : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isCorrect ? Colors.green : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  color: isCorrect ? Colors.white : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(option)),
                          if (isCorrect)
                            const Icon(Icons.check, size: 16, color: Colors.green),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Explanation:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(question.explanation),
                  ],
                ),
              ),
              
              if (question.curriculumReference.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.school, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          question.curriculumReference,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// ============ SCREENS ============
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questionStats = UgandanQuestionService.allQuestions.length;
    final levelStats = UgandanQuestionService.getQuestionsByLevel();
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
const SizedBox(height: 20),

// ======== ENLARGED LOGO ========
Center(
  child: Image.asset(
    'assets/branding/ala_logo.png',
    height: 140,  // ← CHANGED FROM 80 TO 100
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) {
      return Column(
        children: [
          Icon(Icons.error, color: Colors.red),
          Text('Logo not found', style: TextStyle(color: Colors.red)),
        ],
      );
    },
  ),
),

const SizedBox(height: 16),

Text(
  'AdaptiLearn Africa',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.green.shade800,
  ),
),

const SizedBox(height: 4),

const Text(
  'Uganda Primary English Assessment',
  textAlign: TextAlign.center,
  style: TextStyle(color: Colors.grey, fontSize: 14),
),
              
              const SizedBox(height: 30),
              
              // Sample Version Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SAMPLE VERSION',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                            ),
                          ),
                          Text(
                            '30 questions • 3 sessions • Free trial',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const Text(
                        'Uganda Curriculum Coverage',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat('Questions', questionStats.toString()),
                          _buildStat('Primary Levels', '5'),
                          _buildStat('Categories', '4'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: PrimaryLevel.values.map((level) {
                          final count = levelStats[level]?.length ?? 0;
                          return Chip(
                            label: Text('${AppExtensions.getLevelShortName(level)}: $count'),
                            backgroundColor: AppExtensions.getLevelLightColor(level),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              FutureBuilder<Map<String, dynamic>>(
                future: SessionManager.getSessionProgress(),
                builder: (context, snapshot) {
                  final progress = snapshot.data ?? {
                    'current_session': 1,
                    'completed_sessions': 0,
                    'is_complete': false,
                  };
                  
                  final currentSession = progress['current_session'] as int;
                  final isComplete = progress['is_complete'] as bool;
                  final completedSessions = progress['completed_sessions'] as int;
                  
                  return Column(
                    children: [
                      // Session Progress
                      if (!isComplete)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Text(
                                  'Your Progress',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                LinearProgressIndicator(
                                  value: completedSessions / 3,
                                  backgroundColor: Colors.grey.shade200,
                                  color: Colors.green,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Session $currentSession/3 • ${completedSessions * 10}/30 questions',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      const SizedBox(height: 20),
                      
                      // Start/Continue Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (isComplete) {
                              // Show upgrade prompt
                              _showUpgradeDialog(context);
                            } else {
                              // Continue to test
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UgandanAdaptiveTestScreen(),
                                ),
                              );
                            }
                          },
                          icon: Icon(isComplete ? Icons.upgrade : Icons.play_arrow, size: 22),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              isComplete ? 'Upgrade to Full Version' : 
                              currentSession == 1 ? 'Start First Session' : 'Continue Session $currentSession',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isComplete ? Colors.purple : Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Other buttons
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UgandanQuestionBankScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.library_books),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text('View Question Bank', style: TextStyle(fontSize: 16)),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person, size: 22),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text('View My Progress', style: TextStyle(fontSize: 16)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 30),
              
              // Contact for full version
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Need the full version?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Full version includes:\n• 500+ questions\n• Progress tracking\n• Teacher dashboard\n• Detailed analytics',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _showContactDialog(context),
                      child: const Text('Contact for Full Version'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
  
  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sample Complete!'),
        content: const Text(
          'You have completed all 3 sample sessions (30 questions).\n\n'
          'For the full version with 500+ questions, progress tracking, and teacher dashboard, '
          'please contact us for pricing and licensing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showContactDialog(context);
            },
            child: const Text('Contact Now'),
          ),
        ],
      ),
    );
  }
  
  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact for Full Version'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('For the full Uganda Primary English Assessment Tool:'),
            const SizedBox(height: 12),
            _buildContactInfo(Icons.email, 'Email:', 'contact@yourapp.com'),
            _buildContactInfo(Icons.phone, 'Phone:', '+256 XXX XXX XXX'),
            _buildContactInfo(Icons.web, 'Website:', 'www.yourapp.com'),
            _buildContactInfo(Icons.location_on, 'Location:', 'Kampala, Uganda'),
            const SizedBox(height: 12),
            const Text(
              'Features included in full version:\n'
              '• 500+ curriculum-aligned questions\n'
              '• Student progress tracking\n'
              '• Teacher/admin dashboard\n'
              '• Detailed performance analytics\n'
              '• Printable reports\n'
              '• Unlimited tests',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class UgandanAdaptiveTestScreen extends StatefulWidget {
  const UgandanAdaptiveTestScreen({Key? key}) : super(key: key);

  @override
  State<UgandanAdaptiveTestScreen> createState() => _UgandanAdaptiveTestScreenState();
}

class _UgandanAdaptiveTestScreenState extends State<UgandanAdaptiveTestScreen> {
  late PrimaryAdaptiveTestEngine testEngine;
  int? selectedAnswer;
  bool showFeedback = false;
  bool testComplete = false;
  TestResult? testResult;
  bool? isAnswerCorrect;
  int sessionNumber = 1;
  PrimaryLevel? userLevel;
  
  @override
  void initState() {
    super.initState();
    _initializeTest();
  }
  
  Future<void> _initializeTest() async {
    sessionNumber = await SessionManager.getCurrentSession();
    userLevel = await SessionManager.getUserLevel();
    
    final testQuestions = UgandanQuestionService.getQuestionsForSession(sessionNumber, userLevel);
    
    setState(() {
      testEngine = PrimaryAdaptiveTestEngine(testQuestions, sessionNumber: sessionNumber);
    });
  }
  
  void submitAnswer(int index) {
    final question = testEngine.getCurrentQuestion();
    final isCorrect = index == question.correctAnswerIndex;
    
    setState(() {
      selectedAnswer = index;
      isAnswerCorrect = isCorrect;
      showFeedback = true;
    });
    
    testEngine.submitAnswer(index);
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (testEngine.testCompleted) {
          setState(() {
            testComplete = true;
            testResult = testEngine.getResults();
          });
          // Save test result
          StorageService.saveTestResult(testResult!);
        } else {
          setState(() {
            selectedAnswer = null;
            isAnswerCorrect = null;
            showFeedback = false;
          });
        }
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (testComplete && testResult != null) {
      return ResultsScreen(result: testResult!);
    }
    
    if (testEngine.testQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Test Error')),
        body: const Center(
          child: Text('No questions available for this session.'),
        ),
      );
    }
    
    final question = testEngine.getCurrentQuestion();
    final progress = (testEngine.currentQuestionIndex + 1) / testEngine.testQuestions.length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uganda English Assessment'),
        actions: [
          Chip(
            label: Text('Session $sessionNumber'),
            backgroundColor: Colors.green.shade100,
          ),
          const SizedBox(width: 8),
          Chip(
            label: Text('Level: ${AppExtensions.getLevelShortName(testEngine.getEstimatedLevel())}'),
            backgroundColor: AppExtensions.getLevelLightColor(testEngine.getEstimatedLevel()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${testEngine.currentQuestionIndex + 1}/${testEngine.testQuestions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(label: Text('Score: ${testEngine.score}')),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Text(
                              'Session $sessionNumber - Question ${testEngine.currentQuestionIndex + 1}',
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              question.text,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LevelBadge(level: question.level),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text(AppExtensions.getCategoryName(question.category)),
                                  backgroundColor: Colors.grey.shade100,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    ...question.options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      final isSelected = selectedAnswer == index;
                      
                      Color backgroundColor = Colors.white;
                      Color borderColor = Colors.grey.shade300;
                      Color textColor = Colors.black;
                      Color buttonColor = Colors.grey.shade200;
                      IconData? icon;
                      Color iconColor = Colors.transparent;
                      
                      if (isSelected) {
                        if (isAnswerCorrect == true) {
                          backgroundColor = Colors.green.shade50;
                          borderColor = Colors.green;
                          textColor = Colors.green.shade900;
                          buttonColor = Colors.green;
                          icon = Icons.check;
                          iconColor = Colors.green;
                        } else if (isAnswerCorrect == false) {
                          backgroundColor = Colors.red.shade50;
                          borderColor = Colors.red;
                          textColor = Colors.red.shade900;
                          buttonColor = Colors.red;
                          icon = Icons.close;
                          iconColor = Colors.red;
                        }
                      }
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          onPressed: selectedAnswer == null ? () => submitAnswer(index) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor,
                            foregroundColor: textColor,
                            padding: const EdgeInsets.all(14),
                            alignment: Alignment.centerLeft,
                            side: BorderSide(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(option)),
                              if (icon != null)
                                Icon(icon, color: iconColor),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    
                    if (showFeedback && selectedAnswer != null && isAnswerCorrect != null)
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isAnswerCorrect!
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isAnswerCorrect!
                                    ? Colors.green
                                    : Colors.red,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isAnswerCorrect!
                                          ? Icons.check_circle
                                          : Icons.error,
                                      color: isAnswerCorrect!
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isAnswerCorrect!
                                          ? 'Correct!'
                                          : 'Incorrect',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isAnswerCorrect!
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Explanation:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(question.explanation),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UgandanQuestionBankScreen extends StatelessWidget {
  const UgandanQuestionBankScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questionsByLevel = UgandanQuestionService.getQuestionsByLevel();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Question Bank')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Question Bank Statistics',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Total', UgandanQuestionService.allQuestions.length.toString()),
                        _buildStat('Grammar', UgandanQuestionService.allQuestions.where((q) => q.category == QuestionCategory.grammar).length.toString()),
                        _buildStat('Vocabulary', UgandanQuestionService.allQuestions.where((q) => q.category == QuestionCategory.vocabulary).length.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Questions by Level:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...PrimaryLevel.values.map((level) {
              final questions = questionsByLevel[level]!;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          LevelBadge(level: level),
                          const SizedBox(width: 12),
                          Text(
                            '${AppExtensions.getLevelName(level)} (${questions.length} questions)',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...questions.take(2).map((question) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text('• ${question.text}'),
                        );
                      }).toList(),
                      if (questions.length > 2)
                        Text('... and ${questions.length - 2} more', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            }).toList(),
            
            const SizedBox(height: 20),
            
            const Text(
              'All Questions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...UgandanQuestionService.allQuestions.map((question) {
              return UgandanQuestionCard(question: question);
            }).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class ResultsScreen extends StatelessWidget {
  final TestResult result;
  
  const ResultsScreen({Key? key, required this.result}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Results')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppExtensions.getLevelColor(result.estimatedLevel).withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppExtensions.getLevelColor(result.estimatedLevel), width: 3),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppExtensions.getLevelShortName(result.estimatedLevel),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppExtensions.getLevelColor(result.estimatedLevel),
                              ),
                            ),
                            Text(
                              AppExtensions.getLevelName(result.estimatedLevel),
                              style: TextStyle(color: AppExtensions.getLevelColor(result.estimatedLevel)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Text(
                      'Session ${result.sessionNumber} Complete!',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMetric('Score', '${result.correctAnswers}/${result.questionsAnswered}'),
                        _buildMetric('Accuracy', '${(result.accuracy * 100).toInt()}%'),
                        _buildMetric('Time', '${result.totalTime.inMinutes}m ${result.totalTime.inSeconds % 60}s'),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getPerformanceColor(result.accuracy),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.emoji_events, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            _getPerformanceText(result.accuracy),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Question Review',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...result.responses.asMap().entries.map((entry) {
                      final index = entry.key;
                      final response = entry.value;
                      
                      return Column(
                        children: [
                          UgandanQuestionCard(question: response.question, showDetails: true),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: response.isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  response.isCorrect ? Icons.check : Icons.close,
                                  color: response.isCorrect ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    response.isCorrect
                                        ? 'Correct! You answered correctly. (Time: ${response.timeTaken.inSeconds}s)'
                                        : 'Incorrect. Your answer: ${response.selectedAnswerIndex != null ? response.question.options[response.selectedAnswerIndex!] : "No answer selected"}. '
                                          'Correct answer: ${response.question.options[response.question.correctAnswerIndex]} (Time: ${response.timeTaken.inSeconds}s)',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (index < result.responses.length - 1) const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                      ),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Back to Home'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final nextSession = await SessionManager.getCurrentSession();
                        if (nextSession <= 3) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const UgandanAdaptiveTestScreen()),
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Continue Learning'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
  
  Color _getPerformanceColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.6) return Colors.blue;
    if (accuracy >= 0.4) return Colors.orange;
    return Colors.red;
  }
  
  String _getPerformanceText(double accuracy) {
    if (accuracy >= 0.8) return 'Excellent Performance!';
    if (accuracy >= 0.6) return 'Good Job!';
    if (accuracy >= 0.4) return 'Fair Performance';
    return 'Needs More Practice';
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _stats = {
    'totalTests': 0,
    'averageAccuracy': 0.0,
    'bestLevel': 'P3',
    'totalQuestions': 0,
    'correctAnswers': 0,
    'overallAccuracy': 0.0,
  };
  bool _loading = true;
  List<TestResult> _testHistory = [];
  Map<String, dynamic> _sessionProgress = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await StorageService.getStatistics();
    final history = await StorageService.getTestResults();
    final progress = await SessionManager.getSessionProgress();
    
    setState(() {
      _stats = stats;
      _testHistory = history;
      _sessionProgress = progress;
      _loading = false;
    });
  }

  Future<void> _clearData() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('Are you sure you want to delete all test history and progress? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await SessionManager.resetSample();
              await StorageService.clearAllData();
              Navigator.pop(context);
              await _loadData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared successfully')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearData,
            tooltip: 'Clear Data',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stats Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(Icons.analytics, size: 60, color: Colors.green),
                          const SizedBox(height: 16),
                          const Text(
                            'Learning Statistics',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatCard('Tests Taken', _stats['totalTests'].toString()),
                              _buildStatCard('Avg. Accuracy', '${(_stats['overallAccuracy'] * 100).toStringAsFixed(1)}%'),
                              _buildStatCard('Best Level', _stats['bestLevel'].toString()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Overall Performance',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: _stats['overallAccuracy'],
                                  backgroundColor: Colors.grey.shade300,
                                  color: _getAccuracyColor(_stats['overallAccuracy']),
                                  minHeight: 12,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${_stats['correctAnswers']}/${_stats['totalQuestions']} correct '
                                  '(${(_stats['overallAccuracy'] * 100).toStringAsFixed(1)}%)',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Session Progress
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sample Progress',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: (_sessionProgress['completed_sessions'] ?? 0) / 3,
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.green,
                            minHeight: 10,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Session ${_sessionProgress['current_session'] ?? 1}/3 • '
                            '${(_sessionProgress['completed_sessions'] ?? 0) * 10}/30 questions completed',
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (_sessionProgress['is_complete'] == true)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.amber),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.info, color: Colors.amber),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Sample complete! Contact for full version.',
                                        style: TextStyle(fontSize: 12),
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

                  const SizedBox(height: 24),

                  // Tips Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Learning Tips',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          _buildTip(
                            Icons.trending_up,
                            'Consistent Practice',
                            'Take one session daily to see improvement',
                          ),
                          _buildTip(
                            Icons.auto_stories,
                            'Review Mistakes',
                            'Always check explanations for wrong answers',
                          ),
                          _buildTip(
                            Icons.timer,
                            'Time Management',
                            'Try to answer questions within 30 seconds each',
                          ),
                          _buildTip(
                            Icons.repeat,
                            'Complete All Sessions',
                            'Finish all 3 sample sessions for best assessment',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Contact Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Need More Practice?',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Get the full version with 500+ questions, detailed analytics, and teacher dashboard.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Contact Us'),
                                  content: const Text('For the full version pricing and licensing, please contact:\n\nEmail: contact@yourapp.com\nPhone: +256 XXX XXX XXX'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('Contact for Full Version'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTip(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.6) return Colors.blue;
    if (accuracy >= 0.4) return Colors.orange;
    return Colors.red;
  }
}


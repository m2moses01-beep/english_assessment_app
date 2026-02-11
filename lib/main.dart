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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ======== BRANDING ========
              Center(
                child: Image.asset(
                  'assets/branding/ala_logo.png',
                  height: 120, 
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, size: 80, color: Colors.green),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'AdaptiLearn Africa',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
              ),
              const Text(
                'Uganda Primary English Assessment',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 0.5),
              ),
              
              const SizedBox(height: 24),
              
              // ======== SAMPLE BANNER ========
              _buildSampleBanner(),
              
              const SizedBox(height: 24),
              
              // ======== CURRICULUM STATS ========
              Card(
                elevation: 0,
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.green.shade100)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Curriculum Coverage',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildStat('Questions', questionStats.toString()),
                          _buildStat('Levels', 'P3-P7'),
                          _buildStat('Categories', '4'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: PrimaryLevel.values.map((level) {
                          final count = levelStats[level]?.length ?? 0;
                          return Chip(
                            label: Text('${AppExtensions.getLevelShortName(level)}: $count', style: const TextStyle(fontSize: 12)),
                            backgroundColor: AppExtensions.getLevelLightColor(level).withOpacity(0.7),
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // ======== DYNAMIC ACTION SECTION ========
              FutureBuilder<Map<String, dynamic>>(
                future: SessionManager.getSessionProgress(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: LinearProgressIndicator());
                  
                  final progress = snapshot.data!;
                  final currentSession = progress['current_session'] as int;
                  final isComplete = progress['is_complete'] as bool;
                  final completedSessions = progress['completed_sessions'] as int;
                  
                  return Column(
                    children: [
                      if (!isComplete) _buildProgressBar(completedSessions, currentSession),
                      const SizedBox(height: 16),
                      
                      // Primary Action
                      _buildMenuButton(
                        label: isComplete ? 'Upgrade to Full Version' : (currentSession == 1 ? 'Start Assessment' : 'Continue Session $currentSession'),
                        icon: isComplete ? Icons.auto_awesome : Icons.play_circle_fill,
                        color: isComplete ? Colors.purple.shade700 : Colors.green.shade700,
                        isPrimary: true,
                        onPressed: () {
                          if (isComplete) {
                            _showUpgradeDialog(context);
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UgandanAdaptiveTestScreen()));
                          }
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Secondary Actions
                      Row(
                        children: [
                          Expanded(
                            child: _buildMenuButton(
                              label: 'Question Bank',
                              icon: Icons.menu_book,
                              color: Colors.blueGrey,
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UgandanQuestionBankScreen())),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMenuButton(
                              label: 'My Progress',
                              icon: Icons.insights,
                              color: Colors.blue.shade600,
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 32),
              _buildFooterContact(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper UI Components for HomeScreen ---

  Widget _buildSampleBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.stars, color: Colors.amber.shade800),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FREE SAMPLE VERSION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('30 adaptive questions across 3 sessions', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int completed, int current) {
    double progressValue = completed / 3;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Your Assessment Progress', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('${(progressValue * 100).toInt()}%', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton({required String label, required IconData icon, required Color color, required VoidCallback onPressed, bool isPrimary = false}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: isPrimary ? 24 : 20),
      label: Text(label, style: TextStyle(fontSize: isPrimary ? 18 : 14, fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: isPrimary ? 18 : 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: isPrimary ? 2 : 0,
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFooterContact(BuildContext context) {
    return Column(
      children: [
        Text('Unlock 500+ Questions', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () => _showContactDialog(context),
          child: const Text('Contact Support for Licensing'),
        ),
      ],
    );
  }

  // --- Dialogs (kept from your original logic but styled) ---
  void _showUpgradeDialog(BuildContext context) { /* Same as your original */ }
  void _showContactDialog(BuildContext context) { /* Same as your original */ }
}

// ============ ASSESSMENT SCREEN ============

class UgandanAdaptiveTestScreen extends StatefulWidget {
  const UgandanAdaptiveTestScreen({Key? key}) : super(key: key);

  @override
  State<UgandanAdaptiveTestScreen> createState() => _UgandanAdaptiveTestScreenState();
}

class _UgandanAdaptiveTestScreenState extends State<UgandanAdaptiveTestScreen> {
  late PrimaryAdaptiveTestEngine testEngine;
  bool _isLoading = true; // CRITICAL: Prevent LateInitializationError
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
    
    if (mounted) {
      setState(() {
        testEngine = PrimaryAdaptiveTestEngine(testQuestions, sessionNumber: sessionNumber);
        _isLoading = false;
      });
    }
  }

  void submitAnswer(int index) {
    if (selectedAnswer != null) return; // Prevent double taps

    final question = testEngine.getCurrentQuestion();
    final isCorrect = index == question.correctAnswerIndex;
    
    setState(() {
      selectedAnswer = index;
      isAnswerCorrect = isCorrect;
      showFeedback = true;
    });
    
    testEngine.submitAnswer(index);
    
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        if (testEngine.testCompleted) {
          final result = testEngine.getResults();
          StorageService.saveTestResult(result);
          setState(() {
            testResult = result;
            testComplete = true;
          });
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
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (testComplete && testResult != null) return ResultsScreen(result: testResult!);
    
    final question = testEngine.getCurrentQuestion();
    final progress = (testEngine.currentQuestionIndex + 1) / testEngine.testQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('English Assessment'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(value: progress, backgroundColor: Colors.white, color: Colors.orange),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${testEngine.currentQuestionIndex + 1} of ${testEngine.testQuestions.length}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                LevelBadge(level: question.level),
              ],
            ),
            const SizedBox(height: 20),
            
            // Question Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  question.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Options
            ...question.options.asMap().entries.map((entry) {
              return _buildOptionButton(entry.key, entry.value);
            }).toList(),
            
            const SizedBox(height: 20),
            
            // Feedback
            if (showFeedback) _buildFeedbackArea(question.explanation),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index, String text) {
    bool isSelected = selectedAnswer == index;
    Color color = Colors.white;
    if (isSelected) color = isAnswerCorrect! ? Colors.green.shade100 : Colors.red.shade100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton(
        onPressed: selectedAnswer == null ? () => submitAnswer(index) : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(16),
          side: BorderSide(color: isSelected ? (isAnswerCorrect! ? Colors.green : Colors.red) : Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: isSelected ? (isAnswerCorrect! ? Colors.green : Colors.red) : Colors.grey.shade200,
              child: Text(String.fromCharCode(65 + index), style: const TextStyle(fontSize: 12, color: Colors.black87)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black87))),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackArea(String explanation) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAnswerCorrect! ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isAnswerCorrect! ? "Well done!" : "Not quite right", 
              style: TextStyle(fontWeight: FontWeight.bold, color: isAnswerCorrect! ? Colors.green : Colors.red)),
          const SizedBox(height: 4),
          Text(explanation),
        ],
      ),
    );
  }
}
class ResultsScreen extends StatelessWidget {
  final TestResult result;
  
  const ResultsScreen({Key? key, required this.result}) : super(key: key);

  // Helper logic for performance feedback
  Color _getPerformanceColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.5) return Colors.orange;
    return Colors.red;
  }

  String _getPerformanceText(double accuracy) {
    if (accuracy >= 0.8) return 'Excellent Work!';
    if (accuracy >= 0.5) return 'Good Effort!';
    return 'Keep Practicing!';
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = AppExtensions.getLevelColor(result.estimatedLevel);

    return Scaffold(
      appBar: AppBar(title: const Text('Test Results'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score Header
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: themeColor, width: 3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppExtensions.getLevelShortName(result.estimatedLevel),
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: themeColor)),
                          Text(AppExtensions.getLevelName(result.estimatedLevel),
                              style: TextStyle(fontSize: 10, color: themeColor)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Session ${result.sessionNumber} Complete!', 
                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: _getPerformanceColor(result.accuracy),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.emoji_events, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(_getPerformanceText(result.accuracy), 
                               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Question Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),

            // Question Review List
            ...result.responses.map((response) {
              final bool isCorrect = response.isCorrect;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: isCorrect ? Colors.green.shade200 : Colors.red.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    UgandanQuestionCard(question: response.question, showDetails: true),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(isCorrect ? Icons.check_circle : Icons.cancel, 
                               color: isCorrect ? Colors.green : Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isCorrect 
                                ? 'Correctly answered in ${response.timeTaken.inSeconds}s'
                                : 'Incorrect. You chose: ${response.selectedAnswerIndex != null ? response.question.options[response.selectedAnswerIndex!] : "Skipped"}.\nCorrect: ${response.question.options[response.question.correctAnswerIndex]}',
                              style: TextStyle(fontSize: 13, color: isCorrect ? Colors.green.shade800 : Colors.red.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: const Text('Home'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final nextSession = await SessionManager.getCurrentSession();
                      if (nextSession <= 3) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UgandanAdaptiveTestScreen()));
                      } else {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    },
                    child: const Text('Next Session'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Use a Model class instead of a Map for better type safety in a real app,
  // but keeping Map for now to match your logic.
  Map<String, dynamic> _stats = {
    'totalTests': 0,
    'overallAccuracy': 0.0,
    'bestLevel': 'P3',
    'totalQuestions': 0,
    'correctAnswers': 0,
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
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        StorageService.getStatistics(),
        StorageService.getTestResults(),
        SessionManager.getSessionProgress(),
      ]);

      if (!mounted) return;

      setState(() {
        _stats = results[0] as Map<String, dynamic>;
        _testHistory = results[1] as List<TestResult>;
        _sessionProgress = results[2] as Map<String, dynamic>;
        _loading = false;
      });
    } catch (e) {
      // Handle error
      if (mounted) setState(() => _loading = false);
    }
  }

  // Consolidated Helper for Colors
  Color _getStatusColor(double value) {
    if (value >= 0.8) return Colors.green;
    if (value >= 0.6) return Colors.blue;
    if (value >= 0.4) return Colors.orange;
    return Colors.red;
  }

  // Refactored Stat Widget
  Widget _buildStatItem(String label, String value, {Color color = Colors.green}) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double accuracy = _stats['overallAccuracy'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: _clearData),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator( // Added for better UX
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStatsCard(accuracy),
                    const SizedBox(height: 24),
                    _buildProgressCard(),
                    const SizedBox(height: 24),
                    _buildTipsCard(),
                    const SizedBox(height: 24),
                    _buildUpsellCard(),
                  ],
                ),
              ),
            ),
    );
  }

  // Note: I broke the large Column into smaller methods for readability
  Widget _buildStatsCard(double accuracy) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.analytics, size: 60, color: Colors.green),
            const Text('Learning Statistics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Tests Taken', _stats['totalTests'].toString()),
                _buildStatItem('Avg. Accuracy', '${(accuracy * 100).toStringAsFixed(1)}%'),
                _buildStatItem('Best Level', _stats['bestLevel'].toString()),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: accuracy,
              backgroundColor: Colors.grey.shade300,
              color: _getStatusColor(accuracy),
              minHeight: 12,
            ),
          ],
        ),
      ),
    );
  }
  
  // ... other helper methods (_buildProgressCard, _buildTipsCard, etc.)
}

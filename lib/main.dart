// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, library_private_types_in_public_api
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

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
class UgandanQuestion {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final PrimaryLevel level;
  final QuestionCategory category;
  final List<String> tags;
  final int timesUsed;
  final double successRate;
  final String curriculumReference;
  
  UgandanQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.level,
    required this.category,
    this.tags = const [],
    this.timesUsed = 0,
    this.successRate = 0.5,
    this.curriculumReference = '',
  });
}

class QuestionResponse {
  final UgandanQuestion question;
  final int? selectedAnswerIndex;
  final bool isCorrect;
  final Duration timeTaken;
  
  QuestionResponse({
    required this.question,
    required this.selectedAnswerIndex,
    required this.isCorrect,
    required this.timeTaken,
  });
}

class TestResult {
  final String testId;
  final DateTime completedAt;
  final PrimaryLevel estimatedLevel;
  final int questionsAnswered;
  final int correctAnswers;
  final Duration totalTime;
  final List<QuestionResponse> responses;
  final int sessionNumber;
  
  TestResult({
    required this.testId,
    required this.completedAt,
    required this.estimatedLevel,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.totalTime,
    required this.responses,
    required this.sessionNumber,
  });
  
  double get accuracy => questionsAnswered > 0 
      ? correctAnswers / questionsAnswered 
      : 0.0;
}

// ============ UTILITIES ============
class AppExtensions {
  // PrimaryLevel Extensions
  static String getLevelName(PrimaryLevel level) {
    switch (level) {
      case PrimaryLevel.p3: return 'Primary 3';
      case PrimaryLevel.p4: return 'Primary 4';
      case PrimaryLevel.p5: return 'Primary 5';
      case PrimaryLevel.p6: return 'Primary 6';
      case PrimaryLevel.p7: return 'Primary 7';
    }
  }
  
  static String getLevelShortName(PrimaryLevel level) {
    switch (level) {
      case PrimaryLevel.p3: return 'P3';
      case PrimaryLevel.p4: return 'P4';
      case PrimaryLevel.p5: return 'P5';
      case PrimaryLevel.p6: return 'P6';
      case PrimaryLevel.p7: return 'P7';
    }
  }
  
  static Color getLevelColor(PrimaryLevel level) {
    switch (level) {
      case PrimaryLevel.p3: return Colors.green;
      case PrimaryLevel.p4: return Colors.blue;
      case PrimaryLevel.p5: return Colors.orange;
      case PrimaryLevel.p6: return Colors.purple;
      case PrimaryLevel.p7: return Colors.red;
    }
  }
  
  static Color getLevelLightColor(PrimaryLevel level) {
    switch (level) {
      case PrimaryLevel.p3: return Colors.green.shade50;
      case PrimaryLevel.p4: return Colors.blue.shade50;
      case PrimaryLevel.p5: return Colors.orange.shade50;
      case PrimaryLevel.p6: return Colors.purple.shade50;
      case PrimaryLevel.p7: return Colors.red.shade50;
    }
  }
  
  static int getLevelNumeric(PrimaryLevel level) {
    return level.index + 3;
  }
  
  // QuestionCategory Extensions
  static String getCategoryName(QuestionCategory category) {
    switch (category) {
      case QuestionCategory.grammar: return 'Grammar';
      case QuestionCategory.vocabulary: return 'Vocabulary';
      case QuestionCategory.reading: return 'Reading';
      case QuestionCategory.writing: return 'Writing';
    }
  }
  
  static IconData getCategoryIcon(QuestionCategory category) {
    switch (category) {
      case QuestionCategory.grammar: return Icons.g_translate;
      case QuestionCategory.vocabulary: return Icons.wordpress;
      case QuestionCategory.reading: return Icons.menu_book;
      case QuestionCategory.writing: return Icons.edit;
    }
  }
  
  // Format date
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// ============ SESSION MANAGEMENT ============
class SessionManager {
  static const int MAX_SESSIONS = 3;
  static const int QUESTIONS_PER_SESSION = 10;
  static const int TOTAL_SAMPLE_QUESTIONS = 30;
  
  static Future<int> getCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('current_session') ?? 1;
  }
  
  static Future<void> setCurrentSession(int session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_session', session);
  }
  
  static Future<bool> isSampleComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('sample_complete') ?? false;
  }
  
  static Future<void> markSampleComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sample_complete', true);
  }
  
  static Future<void> resetSample() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_session');
    await prefs.remove('sample_complete');
    await prefs.remove('user_level');
    await prefs.remove('total_tests');
    await prefs.remove('total_questions');
    await prefs.remove('correct_answers');
    await prefs.remove('best_level');
  }
  
  static Future<PrimaryLevel?> getUserLevel() async {
    final prefs = await SharedPreferences.getInstance();
    final levelIndex = prefs.getInt('user_level');
    return levelIndex != null ? PrimaryLevel.values[levelIndex] : null;
  }
  
  static Future<void> setUserLevel(PrimaryLevel level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_level', level.index);
  }
  
  static Future<Map<String, dynamic>> getSessionProgress() async {
    final session = await getCurrentSession();
    final completed = await isSampleComplete();
    
    return {
      'current_session': session,
      'completed_sessions': session - 1,
      'total_sessions': MAX_SESSIONS,
      'is_complete': completed,
      'questions_per_session': QUESTIONS_PER_SESSION,
      'total_questions': TOTAL_SAMPLE_QUESTIONS,
    };
  }
}

// ============ SERVICES ============
class UgandanQuestionService {
  static final List<UgandanQuestion> allQuestions = [
    // PRIMARY 3 Questions
    UgandanQuestion(
      id: 'P3_001',
      text: 'What is the plural of "book"?',
      options: ['book', 'books', 'bookes', 'bookies'],
      correctAnswerIndex: 1,
      explanation: 'Most nouns form plurals by adding "s" at the end.',
      level: PrimaryLevel.p3,
      category: QuestionCategory.grammar,
      tags: ['plurals', 'nouns'],
      curriculumReference: 'P3 English: Nouns and Plurals',
    ),
    UgandanQuestion(
      id: 'P3_002',
      text: 'Choose the correct word: I have ___ apple.',
      options: ['a', 'an', 'the', 'some'],
      correctAnswerIndex: 1,
      explanation: 'Use "an" before words starting with vowel sounds.',
      level: PrimaryLevel.p3,
      category: QuestionCategory.grammar,
      tags: ['articles', 'a_an'],
      curriculumReference: 'P3 English: Articles',
    ),
    UgandanQuestion(
      id: 'P3_003',
      text: 'Which word means "a young dog"?',
      options: ['kitten', 'puppy', 'calf', 'foal'],
      correctAnswerIndex: 1,
      explanation: 'A young dog is called a puppy.',
      level: PrimaryLevel.p3,
      category: QuestionCategory.vocabulary,
      tags: ['animals', 'young_animals'],
      curriculumReference: 'P3 English: Animal Names',
    ),
    UgandanQuestion(
      id: 'P3_004',
      text: 'Complete: She ___ to school every day.',
      options: ['go', 'goes', 'going', 'went'],
      correctAnswerIndex: 1,
      explanation: 'Present simple: he/she/it + verb + s',
      level: PrimaryLevel.p3,
      category: QuestionCategory.grammar,
      tags: ['present_simple', 'verbs'],
      curriculumReference: 'P3 English: Simple Present Tense',
    ),
    UgandanQuestion(
      id: 'P3_005',
      text: 'What is the opposite of "big"?',
      options: ['large', 'huge', 'small', 'tall'],
      correctAnswerIndex: 2,
      explanation: 'Big means large in size, small means little in size.',
      level: PrimaryLevel.p3,
      category: QuestionCategory.vocabulary,
      tags: ['antonyms', 'adjectives'],
      curriculumReference: 'P3 English: Opposites',
    ),
    UgandanQuestion(
      id: 'P3_006',
      text: 'Read: "Tom has a red ball." What color is the ball?',
      options: ['blue', 'red', 'green', 'yellow'],
      correctAnswerIndex: 1,
      explanation: 'The sentence says "red ball", so the ball is red.',
      level: PrimaryLevel.p3,
      category: QuestionCategory.reading,
      tags: ['comprehension', 'colors'],
      curriculumReference: 'P3 English: Reading Comprehension',
    ),
    
    // PRIMARY 4 Questions
    UgandanQuestion(
      id: 'P4_001',
      text: 'Yesterday, I ___ to the market.',
      options: ['go', 'goes', 'went', 'going'],
      correctAnswerIndex: 2,
      explanation: '"Yesterday" indicates past tense. "Went" is past of "go".',
      level: PrimaryLevel.p4,
      category: QuestionCategory.grammar,
      tags: ['past_tense', 'irregular_verbs'],
      curriculumReference: 'P4 English: Past Tense',
    ),
    UgandanQuestion(
      id: 'P4_002',
      text: 'Choose the correct pronoun: Mary and ___ are friends.',
      options: ['I', 'me', 'my', 'mine'],
      correctAnswerIndex: 0,
      explanation: 'Use subject pronoun "I" when it is the subject of the sentence.',
      level: PrimaryLevel.p4,
      category: QuestionCategory.grammar,
      tags: ['pronouns', 'subject_pronouns'],
      curriculumReference: 'P4 English: Pronouns',
    ),
    UgandanQuestion(
      id: 'P4_003',
      text: 'What is a "library"?',
      options: [
        'A place to buy food',
        'A place to borrow books',
        'A place to see animals',
        'A place to play sports'
      ],
      correctAnswerIndex: 1,
      explanation: 'A library is a place where people can read or borrow books.',
      level: PrimaryLevel.p4,
      category: QuestionCategory.vocabulary,
      tags: ['places', 'definitions'],
      curriculumReference: 'P4 English: Vocabulary Building',
    ),
    UgandanQuestion(
      id: 'P4_004',
      text: 'Which sentence is correct?',
      options: [
        'She don\'t like milk.',
        'She doesn\'t likes milk.',
        'She doesn\'t like milk.',
        'She not like milk.'
      ],
      correctAnswerIndex: 2,
      explanation: 'Present simple negative: doesn\'t + base verb (without s).',
      level: PrimaryLevel.p4,
      category: QuestionCategory.grammar,
      tags: ['negatives', 'present_simple'],
      curriculumReference: 'P4 English: Negative Sentences',
    ),
    UgandanQuestion(
      id: 'P4_005',
      text: 'Read: "The cat is under the table." Where is the cat?',
      options: ['on the table', 'beside the table', 'under the table', 'above the table'],
      correctAnswerIndex: 2,
      explanation: '"Under" means below or beneath something.',
      level: PrimaryLevel.p4,
      category: QuestionCategory.reading,
      tags: ['prepositions', 'comprehension'],
      curriculumReference: 'P4 English: Prepositions',
    ),
    UgandanQuestion(
      id: 'P4_006',
      text: 'Which word is spelled correctly?',
      options: ['skool', 'schol', 'school', 'skhool'],
      correctAnswerIndex: 2,
      explanation: 'The correct spelling is "school".',
      level: PrimaryLevel.p4,
      category: QuestionCategory.writing,
      tags: ['spelling', 'common_words'],
      curriculumReference: 'P4 English: Spelling',
    ),
    
    // PRIMARY 5 Questions
    UgandanQuestion(
      id: 'P5_001',
      text: 'I have ___ my homework.',
      options: ['do', 'did', 'done', 'doing'],
      correctAnswerIndex: 2,
      explanation: 'Present perfect tense: have/has + past participle. "Done" is past participle of "do".',
      level: PrimaryLevel.p5,
      category: QuestionCategory.grammar,
      tags: ['present_perfect', 'irregular_verbs'],
      curriculumReference: 'P5 English: Present Perfect Tense',
    ),
    UgandanQuestion(
      id: 'P5_002',
      text: 'Choose the synonym for "happy":',
      options: ['sad', 'joyful', 'angry', 'tired'],
      correctAnswerIndex: 1,
      explanation: 'Synonyms are words with similar meanings. "Joyful" means very happy.',
      level: PrimaryLevel.p5,
      category: QuestionCategory.vocabulary,
      tags: ['synonyms', 'adjectives'],
      curriculumReference: 'P5 English: Synonyms and Antonyms',
    ),
    UgandanQuestion(
      id: 'P5_003',
      text: 'What is the past tense of "write"?',
      options: ['writed', 'wrote', 'written', 'writing'],
      correctAnswerIndex: 1,
      explanation: 'Write → wrote → written (present → past → past participle).',
      level: PrimaryLevel.p5,
      category: QuestionCategory.grammar,
      tags: ['past_tense', 'irregular_verbs'],
      curriculumReference: 'P5 English: Irregular Verbs',
    ),
    UgandanQuestion(
      id: 'P5_004',
      text: 'Which sentence is in future tense?',
      options: [
        'I eat breakfast.',
        'I ate breakfast.',
        'I will eat breakfast.',
        'I am eating breakfast.'
      ],
      correctAnswerIndex: 2,
      explanation: '"Will eat" shows future action.',
      level: PrimaryLevel.p5,
      category: QuestionCategory.grammar,
      tags: ['future_tense', 'will'],
      curriculumReference: 'P5 English: Future Tense',
    ),
    UgandanQuestion(
      id: 'P5_005',
      text: 'Read: "The sun rises in the east." This sentence is:',
      options: ['an opinion', 'a question', 'a fact', 'a command'],
      correctAnswerIndex: 2,
      explanation: 'It is a true statement that can be proven, so it is a fact.',
      level: PrimaryLevel.p5,
      category: QuestionCategory.reading,
      tags: ['fact_opinion', 'comprehension'],
      curriculumReference: 'P5 English: Fact vs Opinion',
    ),
    UgandanQuestion(
      id: 'P5_006',
      text: 'Which is a complete sentence?',
      options: [
        'Running fast.',
        'The boy runs fast.',
        'After school.',
        'Because she was tired.'
      ],
      correctAnswerIndex: 1,
      explanation: 'A complete sentence must have a subject (the boy) and a verb (runs).',
      level: PrimaryLevel.p5,
      category: QuestionCategory.writing,
      tags: ['sentence_structure', 'complete_sentences'],
      curriculumReference: 'P5 English: Sentence Structure',
    ),
    
    // PRIMARY 6 Questions
    UgandanQuestion(
      id: 'P6_001',
      text: 'If it rains, we ___ cancel the picnic.',
      options: ['will', 'would', 'should', 'could'],
      correctAnswerIndex: 0,
      explanation: 'First conditional: if + present simple, will + base verb.',
      level: PrimaryLevel.p6,
      category: QuestionCategory.grammar,
      tags: ['conditionals', 'first_conditional'],
      curriculumReference: 'P6 English: Conditionals',
    ),
    UgandanQuestion(
      id: 'P6_002',
      text: 'What does "benevolent" mean?',
      options: ['kind', 'angry', 'smart', 'funny'],
      correctAnswerIndex: 0,
      explanation: 'Benevolent means kind and helpful.',
      level: PrimaryLevel.p6,
      category: QuestionCategory.vocabulary,
      tags: ['advanced_vocabulary', 'adjectives'],
      curriculumReference: 'P6 English: Advanced Vocabulary',
    ),
    UgandanQuestion(
      id: 'P6_003',
      text: 'She is the girl ___ won the competition.',
      options: ['which', 'who', 'whom', 'whose'],
      correctAnswerIndex: 1,
      explanation: 'Use "who" for people as the subject of the relative clause.',
      level: PrimaryLevel.p6,
      category: QuestionCategory.grammar,
      tags: ['relative_clauses', 'relative_pronouns'],
      curriculumReference: 'P6 English: Relative Clauses',
    ),
    UgandanQuestion(
      id: 'P6_004',
      text: 'Which is the correct passive voice?',
      options: [
        'The teacher praised the student.',
        'The student praised by the teacher.',
        'The student was praised by the teacher.',
        'The student is praising by the teacher.'
      ],
      correctAnswerIndex: 2,
      explanation: 'Passive voice: object + was/were + past participle + by + subject.',
      level: PrimaryLevel.p6,
      category: QuestionCategory.grammar,
      tags: ['passive_voice', 'voice'],
      curriculumReference: 'P6 English: Active and Passive Voice',
    ),
    UgandanQuestion(
      id: 'P6_005',
      text: 'Read: "Despite the heavy rain, the football match continued." This means:',
      options: [
        'The match stopped because of rain.',
        'The match went on even though it rained.',
        'The rain made the match more exciting.',
        'The match was postponed due to rain.'
      ],
      correctAnswerIndex: 1,
      explanation: '"Despite" means "in spite of". So the match continued even with rain.',
      level: PrimaryLevel.p6,
      category: QuestionCategory.reading,
      tags: ['context_clues', 'comprehension'],
      curriculumReference: 'P6 English: Reading Comprehension',
    ),
    UgandanQuestion(
      id: 'P6_006',
      text: 'Which punctuation is correct?',
      options: [
        'What time is it.',
        'What time is it?',
        'What time is it!',
        'What time is it,'
      ],
      correctAnswerIndex: 1,
      explanation: 'Questions end with a question mark (?).',
      level: PrimaryLevel.p6,
      category: QuestionCategory.writing,
      tags: ['punctuation', 'question_mark'],
      curriculumReference: 'P6 English: Punctuation',
    ),
    
    // PRIMARY 7 Questions
    UgandanQuestion(
      id: 'P7_001',
      text: '___ had I arrived than the phone rang.',
      options: ['No sooner', 'Hardly', 'Scarcely', 'Only'],
      correctAnswerIndex: 0,
      explanation: '"No sooner...than" is a fixed structure for showing two quick events.',
      level: PrimaryLevel.p7,
      category: QuestionCategory.grammar,
      tags: ['inversion', 'advanced_structures'],
      curriculumReference: 'P7 English: Advanced Structures',
    ),
    UgandanQuestion(
      id: 'P7_002',
      text: 'What is the meaning of "ambiguous"?',
      options: ['clear', 'confusing', 'simple', 'obvious'],
      correctAnswerIndex: 1,
      explanation: 'Ambiguous means having more than one possible meaning; unclear.',
      level: PrimaryLevel.p7,
      category: QuestionCategory.vocabulary,
      tags: ['advanced_vocabulary', 'multiple_meanings'],
      curriculumReference: 'P7 English: Vocabulary',
    ),
    UgandanQuestion(
      id: 'P7_003',
      text: 'If I ___ you, I would study harder.',
      options: ['am', 'was', 'were', 'be'],
      correctAnswerIndex: 2,
      explanation: 'Second conditional uses "were" for all subjects in the if-clause.',
      level: PrimaryLevel.p7,
      category: QuestionCategory.grammar,
      tags: ['conditionals', 'second_conditional'],
      curriculumReference: 'P7 English: Conditionals',
    ),
    UgandanQuestion(
      id: 'P7_004',
      text: 'The report ___ by the team right now.',
      options: ['is being prepared', 'is prepared', 'prepares', 'preparing'],
      correctAnswerIndex: 0,
      explanation: 'Present continuous passive for actions happening now.',
      level: PrimaryLevel.p7,
      category: QuestionCategory.grammar,
      tags: ['passive_voice', 'present_continuous'],
      curriculumReference: 'P7 English: Passive Voice',
    ),
    UgandanQuestion(
      id: 'P7_005',
      text: 'Read: "The protagonist in the story faced numerous challenges but persevered." The main character was:',
      options: ['weak', 'determined', 'lucky', 'foolish'],
      correctAnswerIndex: 1,
      explanation: '"Persevered" means continued despite difficulties, showing determination.',
      level: PrimaryLevel.p7,
      category: QuestionCategory.reading,
      tags: ['character_traits', 'inference'],
      curriculumReference: 'P7 English: Literary Analysis',
    ),
    UgandanQuestion(
      id: 'P7_006',
      text: 'Which sentence has correct parallel structure?',
      options: [
        'She likes swimming, to run, and reading.',
        'She likes swimming, running, and to read.',
        'She likes to swim, run, and read.',
        'She likes swimming, runs, and reading.'
      ],
      correctAnswerIndex: 2,
      explanation: 'Parallel structure uses the same grammatical form: to swim, (to) run, (to) read.',
      level: PrimaryLevel.p7,
      category: QuestionCategory.writing,
      tags: ['parallel_structure', 'writing_style'],
      curriculumReference: 'P7 English: Writing Skills',
    ),
  ];
  
  static Map<PrimaryLevel, List<UgandanQuestion>> getQuestionsByLevel() {
    final map = <PrimaryLevel, List<UgandanQuestion>>{};
    for (final level in PrimaryLevel.values) {
      map[level] = allQuestions.where((q) => q.level == level).toList();
    }
    return map;
  }
  
  static List<UgandanQuestion> getQuestionsForSession(int sessionNumber, PrimaryLevel? currentLevel) {
    final allQuestionsByLevel = getQuestionsByLevel();
    final selectedQuestions = <UgandanQuestion>[];
    
    if (sessionNumber == 1) {
      // Placement test: 2 questions from each level
      for (final level in PrimaryLevel.values) {
        final levelQuestions = allQuestionsByLevel[level] ?? [];
        if (levelQuestions.isNotEmpty) {
          final shuffled = List.of(levelQuestions)..shuffle();
          selectedQuestions.addAll(shuffled.take(2));
        }
      }
    } else if (currentLevel != null) {
      // Adaptive test based on current level
      final centerIndex = currentLevel.index;
      final levels = [
        currentLevel,
        if (centerIndex > 0) PrimaryLevel.values[centerIndex - 1],
        if (centerIndex < PrimaryLevel.values.length - 1) PrimaryLevel.values[centerIndex + 1],
      ].whereType<PrimaryLevel>().toList();
      
      final questionsPerLevel = (10 / levels.length).ceil();
      
      for (final level in levels) {
        final levelQuestions = allQuestionsByLevel[level] ?? [];
        if (levelQuestions.isNotEmpty) {
          final shuffled = List.of(levelQuestions)..shuffle();
          selectedQuestions.addAll(shuffled.take(questionsPerLevel));
        }
      }
    }
    
    // Ensure we have exactly 10 questions
    selectedQuestions.shuffle();
    return selectedQuestions.length > 10 ? selectedQuestions.sublist(0, 10) : selectedQuestions;
  }
}

class PrimaryAdaptiveTestEngine {
  final List<UgandanQuestion> testQuestions;
  int currentQuestionIndex = 0;
  int score = 0;
  bool testCompleted = false;
  final List<QuestionResponse> responses = [];
  DateTime? testStartTime;
  DateTime? questionStartTime;
  
  int currentLevelIndex = 2; // Start at P5
  int correctInRow = 0;
  int wrongInRow = 0;
  final int sessionNumber;
  
  PrimaryAdaptiveTestEngine(this.testQuestions, {required this.sessionNumber}) {
    testStartTime = DateTime.now();
    questionStartTime = DateTime.now();
  }
  
  UgandanQuestion getCurrentQuestion() {
    return testQuestions[currentQuestionIndex];
  }
  
  void submitAnswer(int selectedIndex) {
    final question = getCurrentQuestion();
    final isCorrect = selectedIndex == question.correctAnswerIndex;
    final timeTaken = DateTime.now().difference(questionStartTime!);
    
    responses.add(QuestionResponse(
      question: question,
      selectedAnswerIndex: selectedIndex,
      isCorrect: isCorrect,
      timeTaken: timeTaken,
    ));
    
    if (isCorrect) {
      score++;
      correctInRow++;
      wrongInRow = 0;
      
      if (correctInRow >= 2 && currentLevelIndex < PrimaryLevel.values.length - 1) {
        currentLevelIndex++;
        correctInRow = 0;
      }
    } else {
      wrongInRow++;
      correctInRow = 0;
      
      if (wrongInRow >= 2 && currentLevelIndex > 0) {
        currentLevelIndex--;
        wrongInRow = 0;
      }
    }
    
    if (currentQuestionIndex < testQuestions.length - 1) {
      currentQuestionIndex++;
      questionStartTime = DateTime.now();
    } else {
      testCompleted = true;
    }
  }
  
  PrimaryLevel getEstimatedLevel() {
    return PrimaryLevel.values[currentLevelIndex];
  }
  
  Map<PrimaryLevel, double> getLevelPerformance() {
    final Map<PrimaryLevel, List<bool>> levelResults = {};
    
    for (final response in responses) {
      final question = response.question;
      final level = question.level;
      levelResults.putIfAbsent(level, () => []).add(response.isCorrect);
    }
    
    final Map<PrimaryLevel, double> performance = {};
    for (final entry in levelResults.entries) {
      final correctCount = entry.value.where((correct) => correct).length;
      performance[entry.key] = entry.value.isEmpty ? 0.0 : correctCount / entry.value.length;
    }
    
    return performance;
  }
  
  TestResult getResults() {
    final totalTime = DateTime.now().difference(testStartTime!);
    
    return TestResult(
      testId: 'session_${sessionNumber}_${DateTime.now().millisecondsSinceEpoch}',
      completedAt: DateTime.now(),
      estimatedLevel: getEstimatedLevel(),
      questionsAnswered: responses.length,
      correctAnswers: score,
      totalTime: totalTime,
      responses: responses,
      sessionNumber: sessionNumber,
    );
  }
}

class StorageService {
  static Future<Map<String, dynamic>> getStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    final totalQuestions = prefs.getInt('total_questions') ?? 0;
    final correctAnswers = prefs.getInt('correct_answers') ?? 0;
    final overallAccuracy = totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
    
    return {
      'totalTests': prefs.getInt('total_tests') ?? 0,
      'averageAccuracy': prefs.getDouble('average_accuracy') ?? 0.0,
      'bestLevel': prefs.getString('best_level') ?? 'P3',
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'overallAccuracy': overallAccuracy,
    };
  }
  
  static Future<List<TestResult>> getTestResults() async {
    // Simplified implementation - in real app, store serialized results
    return [];
  }
  
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  static Future<void> saveTestResult(TestResult result) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Update statistics
    final oldTotalTests = prefs.getInt('total_tests') ?? 0;
    final oldTotalQuestions = prefs.getInt('total_questions') ?? 0;
    final oldCorrectAnswers = prefs.getInt('correct_answers') ?? 0;
    
    await prefs.setInt('total_tests', oldTotalTests + 1);
    await prefs.setInt('total_questions', oldTotalQuestions + result.questionsAnswered);
    await prefs.setInt('correct_answers', oldCorrectAnswers + result.correctAnswers);
    
    final newOverallAccuracy = (oldCorrectAnswers + result.correctAnswers) / 
        (oldTotalQuestions + result.questionsAnswered);
    await prefs.setDouble('overall_accuracy', newOverallAccuracy);
    
    // Save current level
    await SessionManager.setUserLevel(result.estimatedLevel);
    
    // Update best level if current is higher
    final bestLevelStr = prefs.getString('best_level') ?? 'P3';
    final bestLevelIndex = _getLevelIndexFromString(bestLevelStr);
    if (result.estimatedLevel.index > bestLevelIndex) {
      await prefs.setString('best_level', AppExtensions.getLevelShortName(result.estimatedLevel));
    }
    
    // Update session
    if (result.sessionNumber < 3) {
      await SessionManager.setCurrentSession(result.sessionNumber + 1);
    } else {
      await SessionManager.markSampleComplete();
    }
  }
  
  static int _getLevelIndexFromString(String levelStr) {
    switch (levelStr) {
      case 'P3': return 0;
      case 'P4': return 1;
      case 'P5': return 2;
      case 'P6': return 3;
      case 'P7': return 4;
      default: return 0;
    }
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
    height: 120,  // ← CHANGED FROM 80 TO 100
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






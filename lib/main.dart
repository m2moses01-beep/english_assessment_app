// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'quiz_screen.dart';
import '../data/p5_trial_questions.dart';
import 'results_screen.dart';
import '../models/question_model.dart';


void main() {
  runApp(AdaptiLearnApp());
}

class AdaptiLearnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdaptiLearn Africa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// lib/models/question_model.dart
class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String topic;
  final String difficulty;
  
  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.topic,
    required this.difficulty,
  });
}
// lib/data/p5_trial_questions.dart
final List<Question> p5TrialQuestions = [
  // 1. GRAMMAR - TENSES (Common in UNEB)
  Question(
    id: 'p5_eng_001',
    text: 'Choose the correct verb: Kato ___ football every Saturday.',
    options: ['play', 'plays', 'playing', 'played'],
    correctIndex: 1, // "plays"
    explanation: 'With singular subject "Kato", use "plays" (present simple for routines). "He/She/It" verbs add "s".',
    topic: 'Grammar - Present Tense',
    difficulty: 'Easy',
  ),

  // 2. GRAMMAR - PREPOSITIONS
  Question(
    id: 'p5_eng_002',
    text: 'Complete: She is good ___ mathematics.',
    options: ['at', 'in', 'with', 'for'],
    correctIndex: 0, // "at"
    explanation: 'We use "good at" for skills/subjects. "Good in" is for places, "good with" for people/tools.',
    topic: 'Grammar - Prepositions',
    difficulty: 'Easy',
  ),

  // 3. VOCABULARY - ANTONYMS
  Question(
    id: 'p5_eng_003',
    text: 'What is the opposite of "generous"?',
    options: ['kind', 'selfish', 'rich', 'happy'],
    correctIndex: 1, // "selfish"
    explanation: 'Generous means willing to give/share. Selfish means keeping everything for yourself.',
    topic: 'Vocabulary - Antonyms',
    difficulty: 'Medium',
  ),

  // 4. GRAMMAR - PLURALS (IRREGULAR)
  Question(
    id: 'p5_eng_004',
    text: 'What is the plural of "knife"?',
    options: ['knifes', 'knives', 'knife', 'knive'],
    correctIndex: 1, // "knives"
    explanation: 'For words ending with -fe, change to -ves: knife→knives, wife→wives, life→lives.',
    topic: 'Grammar - Irregular Plurals',
    difficulty: 'Medium',
  ),

  // 5. COMPREHENSION - ANALOGIES
  Question(
    id: 'p5_eng_005',
    text: 'Doctor is to hospital as teacher is to ___.',
    options: ['school', 'book', 'student', 'class'],
    correctIndex: 0, // "school"
    explanation: 'A doctor works in a hospital. A teacher works in a school. This is a workplace analogy.',
    topic: 'Comprehension - Analogies',
    difficulty: 'Easy',
  ),

  // 6. GRAMMAR - ARTICLES
  Question(
    id: 'p5_eng_006',
    text: 'Fill the blank: She wants ___ apple from the basket.',
    options: ['a', 'an', 'the', 'no article'],
    correctIndex: 1, // "an"
    explanation: 'Use "an" before vowel sounds (a, e, i, o, u). Apple starts with vowel sound "a".',
    topic: 'Grammar - Articles',
    difficulty: 'Easy',
  ),

  // 7. VOCABULARY - HOMOPHONES
  Question(
    id: 'p5_eng_007',
    text: 'Which word means "a number": They ate ___ oranges.',
    options: ['to', 'too', 'two', 'tow'],
    correctIndex: 2, // "two"
    explanation: '"Two" is the number 2. "To" shows direction, "too" means also or excessive.',
    topic: 'Vocabulary - Homophones',
    difficulty: 'Medium',
  ),

  // 8. GRAMMAR - CONJUNCTIONS
  Question(
    id: 'p5_eng_008',
    text: 'Join: He was tired. He finished his homework.',
    options: [
      'He was tired, he finished his homework.',
      'He was tired but finished his homework.',
      'He was tired and finished his homework.',
      'He was tired so finished his homework.'
    ],
    correctIndex: 1, // "He was tired but finished his homework."
    explanation: '"But" shows contrast between being tired and still completing work. It\'s the correct conjunction.',
    topic: 'Grammar - Conjunctions',
    difficulty: 'Medium',
  ),

  // 9. PROVERBS (UGANDAN CONTEXT)
  Question(
    id: 'p5_eng_009',
    text: 'Complete: Too many cooks ___',
    options: ['make good soup', 'spoil the broth', 'eat all the food', 'work fast'],
    correctIndex: 1, // "spoil the broth"
    explanation: 'The proverb means: When too many people work on something, they often ruin it.',
    topic: 'Proverbs & Idioms',
    difficulty: 'Medium',
  ),

  // 10. GRAMMAR - PRONOUNS
  Question(
    id: 'p5_eng_010',
    text: 'Choose correct pronoun: Mary and ___ went to the market.',
    options: ['I', 'me', 'myself', 'mine'],
    correctIndex: 0, // "I"
    explanation: 'Use "I" as subject (doing the action). "Me" is object (receiving action).',
    topic: 'Grammar - Pronouns',
    difficulty: 'Easy',
  ),

  // 11. VOCABULARY - SYNONYMS
  Question(
    id: 'p5_eng_011',
    text: 'Which means the same as "begin"?',
    options: ['end', 'start', 'pause', 'continue'],
    correctIndex: 1, // "start"
    explanation: 'Begin and start are synonyms. End is opposite. Pause is temporary stop.',
    topic: 'Vocabulary - Synonyms',
    difficulty: 'Easy',
  ),

  // 12. COMPREHENSION - INFERENCE
  Question(
    id: 'p5_eng_012',
    text: 'If someone is "punctual", they always:',
    options: [
      'arrive late',
      'arrive on time',
      'forget things',
      'work slowly'
    ],
    correctIndex: 1, // "arrive on time"
    explanation: 'Punctual means arriving or happening at the exact time, not late.',
    topic: 'Vocabulary - Word Meaning',
    difficulty: 'Medium',
  ),

  // 13. GRAMMAR - ADJECTIVES
  Question(
    id: 'p5_eng_013',
    text: 'Choose the correct order: She has a ___ bag.',
    options: [
      'red beautiful big',
      'beautiful big red',
      'big beautiful red',
      'big red beautiful'
    ],
    correctIndex: 2, // "big beautiful red"
    explanation: 'Adjective order: Size (big) → Opinion (beautiful) → Color (red).',
    topic: 'Grammar - Adjective Order',
    difficulty: 'Hard',
  ),

  // 14. UGANDAN CONTEXT
  Question(
    id: 'p5_eng_014',
    text: 'What is the capital city of Uganda?',
    options: ['Nairobi', 'Kampala', 'Dar es Salaam', 'Kigali'],
    correctIndex: 1, // "Kampala"
    explanation: 'Kampala is the capital and largest city of Uganda.',
    topic: 'General Knowledge - Uganda',
    difficulty: 'Easy',
  ),

  // 15. COMPREHENSION - LOGIC
  Question(
    id: 'p5_eng_015',
    text: 'All dogs are animals. Rex is a dog. Therefore:',
    options: [
      'Rex is not an animal',
      'Rex might be an animal',
      'Rex is an animal',
      'Some animals are not dogs'
    ],
    correctIndex: 2, // "Rex is an animal"
    explanation: 'If all dogs are animals, and Rex is a dog, then Rex must be an animal.',
    topic: 'Comprehension - Logical Reasoning',
    difficulty: 'Medium',
  ),
];

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Title
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(Icons.school, size: 60, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'AdaptiLearn Africa',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'P5 English Trial',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.yellow.shade200,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40),
              
              // Features List
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('15 UNEB-style Questions'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('Detailed Explanations'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('Instant Scoring'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('Offline Access'),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              
              // Start Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'START FREE TRIAL',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Trial Info
              Text(
                'FREE: 15 Questions • 1 Session',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  // Will link to upgrade screen later
                  _showUpgradeInfo(context);
                },
                child: Text(
                  'Upgrade to Full Version →',
                  style: TextStyle(color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showUpgradeInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Get Full Version'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full P5 English Version includes:'),
            SizedBox(height: 10),
            Text('✓ 40+ questions with explanations'),
            Text('✓ All grammar & vocabulary topics'),
            Text('✓ Progress tracking'),
            Text('✓ Unlimited attempts'),
            SizedBox(height: 15),
            Text('Price: UGX 6,000',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700),
            ),
            SizedBox(height: 10),
            Text('Contact: 078... via WhatsApp'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Open WhatsApp
            },
            child: Text('Contact Now'),
          ),
        ],
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  List<int?> userAnswers = List.filled(p5TrialQuestions.length, null);
  bool quizCompleted = false;

  @override
  Widget build(BuildContext context) {
    if (quizCompleted) {
      return ResultsScreen(
        userAnswers: userAnswers,
        questions: p5TrialQuestions,
      );
    }

    final question = p5TrialQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentQuestionIndex + 1}/15'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              '${((currentQuestionIndex + 1) / 15 * 100).toInt()}%',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / p5TrialQuestions.length,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue.shade600,
              minHeight: 6,
            ),
            SizedBox(height: 20),
            
            // Question text
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  question.text,
                  style: TextStyle(fontSize: 18, height: 1.4),
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  final isSelected = userAnswers[currentQuestionIndex] == index;
                  
                  return Card(
                    color: isSelected ? Colors.blue.shade50 : null,
                    elevation: isSelected ? 4 : 1,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
                        child: Text(
                          String.fromCharCode(65 + index), // A, B, C, D
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(option),
                      onTap: () {
                        setState(() {
                          userAnswers[currentQuestionIndex] = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  if (currentQuestionIndex > 0)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          currentQuestionIndex--;
                        });
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text('Previous'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade600,
                      ),
                    )
                  else
                    SizedBox(width: 100),
                  
                  // Next/Submit button
                  ElevatedButton.icon(
                    onPressed: userAnswers[currentQuestionIndex] == null
                        ? null
                        : () {
                            if (currentQuestionIndex < p5TrialQuestions.length - 1) {
                              setState(() {
                                currentQuestionIndex++;
                              });
                            } else {
                              setState(() {
                                quizCompleted = true;
                              });
                            }
                          },
                    icon: Icon(currentQuestionIndex < p5TrialQuestions.length - 1
                        ? Icons.arrow_forward
                        : Icons.check),
                    label: Text(currentQuestionIndex < p5TrialQuestions.length - 1
                        ? 'Next Question'
                        : 'Submit Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
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
}

class ResultsScreen extends StatelessWidget {
  final List<int?> userAnswers;
  final List<Question> questions;

  ResultsScreen({required this.userAnswers, required this.questions});

  int get score {
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].correctIndex) {
        correct++;
      }
    }
    return correct;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (score / questions.length * 100).toInt();

    return Scaffold(
      appBar: AppBar(title: Text('Quiz Results')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Score Card
            Card(
              color: _getScoreColor(percentage),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Your Score',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$score/${questions.length}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _getScoreMessage(percentage),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Detailed Review Button
            OutlinedButton(
              onPressed: () {
                _showReview(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.reviews),
                    SizedBox(width: 10),
                    Text('Review Answers & Explanations'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // UPGRADE SECTION - MOST IMPORTANT!
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.lock_open, size: 40, color: Colors.blue.shade700),
                  SizedBox(height: 10),
                  Text(
                    '🚀 Unlock Full Potential!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'You completed the free trial! Get full P5 English with 40+ questions, detailed explanations, and progress tracking.',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 1.5),
                  ),
                  SizedBox(height: 15),
                  
                  // WhatsApp Contact Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Open WhatsApp with pre-filled message
                      _openWhatsApp(context);
                    },
                    icon: Icon(Icons.whatsapp, color: Colors.white),
                    label: Text('CONTACT ON WHATSAPP'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  // Price
                  Text(
                    'Only UGX 6,000',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Pay via Mobile Money • Get instant access',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Restart Quiz Button
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
              },
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int percentage) {
    if (percentage >= 80) return Colors.green.shade600;
    if (percentage >= 60) return Colors.blue.shade600;
    if (percentage >= 40) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  String _getScoreMessage(int percentage) {
    if (percentage >= 80) return 'Excellent! You\'re ready for P5 exams!';
    if (percentage >= 60) return 'Good work! Keep practicing!';
    if (percentage >= 40) return 'Keep learning! Try the full version for more practice.';
    return 'Practice makes perfect! Try again or get the full version.';
  }

  void _showReview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Review Answers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final userAnswer = userAnswers[index];
                  final isCorrect = userAnswer == question.correctIndex;
                  
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: isCorrect ? Colors.green : Colors.red,
                                child: Icon(
                                  isCorrect ? Icons.check : Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Q${index + 1}: ${question.text}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Your answer: ${userAnswer != null ? question.options[userAnswer] : "Not answered"}',
                            style: TextStyle(
                              color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                            ),
                          ),
                          Text(
                            'Correct answer: ${question.options[question.correctIndex]}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Explanation: ${question.explanation}',
                            style: TextStyle(color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Topic: ${question.topic} • Difficulty: ${question.difficulty}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openWhatsApp(BuildContext context) {
    final message = Uri.encodeFull(
        'Hello! I want to buy the full P5 English version of AdaptiLearn for UGX 6,000. Please send payment details.');
    final url = 'https://wa.me/2567XXXXXXXXX?text=$message'; // REPLACE WITH YOUR NUMBER
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Our WhatsApp number: 078...'),
            SizedBox(height: 10),
            Text('Send us this message:'),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey.shade100,
              child: Text('"I want to buy AdaptiLearn P5 English"'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Launch URL
            },
            child: Text('Open WhatsApp'),
          ),
        ],
      ),
    );
  }
}

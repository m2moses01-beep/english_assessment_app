import 'package:flutter/material.dart';

void main() {
  runApp(const AdaptiLearnApp());
}

/* =======================
   APP ROOT
======================= */
class AdaptiLearnApp extends StatelessWidget {
  const AdaptiLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdaptiLearn Africa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

/* =======================
   MODEL
======================= */
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

/* =======================
   DATA
======================= */
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

/* =======================
   HOME SCREEN
======================= */
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'AdaptiLearn Africa',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: Text('START FREE TRIAL'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =======================
   QUIZ SCREEN
======================= */
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  final List<int?> userAnswers =
      List<int?>.filled(p5TrialQuestions.length, null);

  @override
  Widget build(BuildContext context) {
    final question = p5TrialQuestions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Question ${currentIndex + 1}/${p5TrialQuestions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              question.text,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            ...List.generate(question.options.length, (index) {
              return Card(
                child: ListTile(
                  title: Text(question.options[index]),
                  leading: Radio<int>(
                    value: index,
                    groupValue: userAnswers[currentIndex],
                    onChanged: (value) {
                      setState(() {
                        userAnswers[currentIndex] = value;
                      });
                    },
                  ),
                ),
              );
            }),

            const Spacer(),

            ElevatedButton(
              onPressed: userAnswers[currentIndex] == null
                  ? null
                  : () {
                      if (currentIndex <
                          p5TrialQuestions.length - 1) {
                        setState(() => currentIndex++);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResultsScreen(
                              userAnswers: userAnswers,
                              questions: p5TrialQuestions,
                            ),
                          ),
                        );
                      }
                    },
              child: Text(
                currentIndex < p5TrialQuestions.length - 1
                    ? 'Next'
                    : 'Submit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =======================
   RESULTS SCREEN
======================= */
class ResultsScreen extends StatelessWidget {
  final List<int?> userAnswers;
  final List<Question> questions;

  const ResultsScreen({
    super.key,
    required this.userAnswers,
    required this.questions,
  });

  int get score {
    int s = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].correctIndex) s++;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 10),
            Text(
              '$score / ${questions.length}',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const QuizScreen()),
                );
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}


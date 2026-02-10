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
final List<Question> p5TrialQuestions = [
  Question(
    id: 'p5_001',
    text: 'Choose the correct verb: Kato ___ football every Saturday.',
    options: ['play', 'plays', 'playing', 'played'],
    correctIndex: 1,
    explanation: 'Singular subject → verb takes -s.',
    topic: 'Grammar',
    difficulty: 'Easy',
  ),
  Question(
    id: 'p5_002',
    text: 'What is the plural of "knife"?',
    options: ['knifes', 'knives', 'knife', 'knive'],
    correctIndex: 1,
    explanation: 'Knife → knives (f → ves).',
    topic: 'Grammar',
    difficulty: 'Medium',
  ),
  Question(
    id: 'p5_003',
    text: 'What is the capital city of Uganda?',
    options: ['Nairobi', 'Kampala', 'Kigali', 'Juba'],
    correctIndex: 1,
    explanation: 'Kampala is the capital of Uganda.',
    topic: 'General Knowledge',
    difficulty: 'Easy',
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

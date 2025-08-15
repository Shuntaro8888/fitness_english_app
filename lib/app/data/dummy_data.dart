
import 'models/workout.dart';
import 'models/quote.dart';

final List<Workout> dummyWorkouts = [
  Workout(
    id: 'w1',
    name: 'Push Up',
    bodyPart: 'Upper Body',
    animationPath: 'assets/animations/push_up.gif',
    phrases: [
      AudioPhrase(
        audioPathEn: 'audio/workouts/push_up/001_e.mp3',
        audioPathJp: 'audio/workouts/push_up/001_j.mp3',
        englishText: 'Keep your back straight.',
        japaneseText: '背中をまっすぐに保ちましょう。',
      ),
    ],
  ),
  Workout(
    id: 'w2',
    name: 'Squat',
    bodyPart: 'Lower Body',
    animationPath: 'assets/animations/squat.gif',
    phrases: [
      AudioPhrase(
        audioPathEn: 'audio/workouts/squat/001_e.mp3',
        audioPathJp: 'audio/workouts/squat/001_j.mp3',
        englishText: 'Keep your chest up.',
        japaneseText: '胸を張りましょう。',
      ),
    ],
  ),
];

final List<Quote> dummyQuotes = [
  Quote(
    id: 'q1',
    englishText: "The only bad workout is the one that didn't happen.",
    japaneseText: '唯一の悪いワークアウトは、行われなかったワークアウトだ。',
    audioPath: 'audio/quotes/q001_e.mp3',
  ),
  Quote(
    id: 'q2',
    englishText: 'Strive for progress, not perfection.',
    japaneseText: '完璧ではなく、進歩を目指せ。',
    audioPath: 'audio/quotes/q002_e.mp3',
  ),
];

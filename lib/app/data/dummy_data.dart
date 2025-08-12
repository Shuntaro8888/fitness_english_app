
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
        audioPath: 'assets/audio/workouts/push_up_1.mp3',
        englishText: 'Keep your back straight.',
        japaneseText: '背中をまっすぐに保ちましょう。',
      ),
      AudioPhrase(
        audioPath: 'assets/audio/workouts/push_up_2.mp3',
        englishText: 'Go down slowly.',
        japaneseText: 'ゆっくりと下ろしていきましょう。',
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
        audioPath: 'assets/audio/workouts/squat_1.mp3',
        englishText: 'Keep your chest up.',
        japaneseText: '胸を張りましょう。',
      ),
      AudioPhrase(
        audioPath: 'assets/audio/workouts/squat_2.mp3',
        englishText: 'Go as low as you can.',
        japaneseText: 'できるだけ深くしゃがみましょう。',
      ),
    ],
  ),
];

final List<Quote> dummyQuotes = [
  Quote(
    id: 'q1',
    englishText: "The only bad workout is the one that didn't happen.",
    japaneseText: '唯一の悪いワークアウトは、行われなかったワークアウトだ。',
    audioPath: 'assets/audio/quotes/quote_1.mp3',
  ),
  Quote(
    id: 'q2',
    englishText: 'Strive for progress, not perfection.',
    japaneseText: '完璧ではなく、進歩を目指せ。',
    audioPath: 'assets/audio/quotes/quote_2.mp3',
  ),
];

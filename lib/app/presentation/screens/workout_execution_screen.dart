
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fitness_english_app/app/data/models/workout.dart';
import 'package:fitness_english_app/app/data/dummy_data.dart';
import 'package:fitness_english_app/app/data/models/quote.dart';

class WorkoutExecutionScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutExecutionScreen({super.key, required this.workout});

  @override
  State<WorkoutExecutionScreen> createState() => _WorkoutExecutionScreenState();
}

class _WorkoutExecutionScreenState extends State<WorkoutExecutionScreen> {
  late AudioPlayer _workoutAudioPlayer;
  late AudioPlayer _quoteAudioPlayer;
  int _currentPhraseIndex = 0;

  @override
  void initState() {
    super.initState();
    _workoutAudioPlayer = AudioPlayer();
    _quoteAudioPlayer = AudioPlayer();

    _playRandomQuote();

    _workoutAudioPlayer.onPlayerComplete.listen((event) {
      _playNextPhrase();
    });

    // Start workout phrases after quote finishes
    _quoteAudioPlayer.onPlayerComplete.listen((event) {
      _playNextPhrase();
    });
  }

  void _playRandomQuote() async {
    final random = Random();
    final Quote randomQuote = dummyQuotes[random.nextInt(dummyQuotes.length)];
    // For now, we don't have audio for quotes, so just print it.
    // In a real app, you would play the audio here.
    // print('Playing quote: ${randomQuote.englishText}');
    // await _quoteAudioPlayer.play(AssetSource(randomQuote.audioPath)); // Uncomment when audio is available
    _playNextPhrase(); // Start workout phrases immediately if no quote audio
  }

  void _playNextPhrase() async {
    if (_currentPhraseIndex < widget.workout.phrases.length) {
      final phrase = widget.workout.phrases[_currentPhraseIndex];
      await _workoutAudioPlayer.play(AssetSource(phrase.audioPath));
      setState(() {
        _currentPhraseIndex++;
      });
    } else {
      // All phrases played, optionally loop or stop
      _currentPhraseIndex = 0; // Loop for now
      _playNextPhrase();
    }
  }

  @override
  void dispose() {
    _workoutAudioPlayer.dispose();
    _quoteAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPhrase = widget.workout.phrases.isNotEmpty
        ? widget.workout.phrases[_currentPhraseIndex > 0 ? _currentPhraseIndex - 1 : 0]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
      ),
      body: Column(
        children: [
          // Animation display area
          Container(
            height: 200,
            color: Colors.grey[300],
            child: Center(
              child: Image.asset(widget.workout.animationPath),
            ),
          ),
          const SizedBox(height: 20),
          // English text display area
          Text(
            currentPhrase?.englishText ?? '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Japanese text display area
          Text(
            currentPhrase?.japaneseText ?? '',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

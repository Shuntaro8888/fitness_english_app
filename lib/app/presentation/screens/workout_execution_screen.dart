
import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:fitness_english_app/app/data/dummy_data.dart';
import 'package:fitness_english_app/app/data/models/quote.dart';
import 'package:fitness_english_app/app/data/models/workout.dart';
import 'package:flutter/material.dart';

class WorkoutExecutionScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutExecutionScreen({super.key, required this.workout});

  @override
  State<WorkoutExecutionScreen> createState() => _WorkoutExecutionScreenState();
}

class _WorkoutExecutionScreenState extends State<WorkoutExecutionScreen> {
  final AudioPlayer _workoutAudioPlayer = AudioPlayer();
  final AudioPlayer _quoteAudioPlayer = AudioPlayer();
  
  int _currentPhraseIndex = 0;
  bool _isLooping = false;
  bool _isPlayingEnglish = true; // To track which part of the phrase is playing
  
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  late StreamSubscription _durationSubscription;
  late StreamSubscription _positionSubscription;
  late StreamSubscription _playerStateSubscription;
  late StreamSubscription _quotePlayerCompleteSubscription;
  late StreamSubscription _workoutPlayerCompleteSubscription;

  String get _currentPhraseEnglishText => widget.workout.phrases.isNotEmpty
      ? widget.workout.phrases[_currentPhraseIndex].englishText
      : '';
      
  String get _currentPhraseJapaneseText => widget.workout.phrases.isNotEmpty
      ? widget.workout.phrases[_currentPhraseIndex].japaneseText
      : '';

  @override
  void initState() {
    super.initState();

    // --- Player State Listeners ---
    _playerStateSubscription = _workoutAudioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });

    _durationSubscription = _workoutAudioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    _positionSubscription = _workoutAudioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    // --- Playback Flow Logic ---
    _quotePlayerCompleteSubscription = _quoteAudioPlayer.onPlayerComplete.listen((event) {
      // When the intro quote finishes, start the first workout phrase (English)
      _startCurrentPhrase();
    });
    
    _workoutPlayerCompleteSubscription = _workoutAudioPlayer.onPlayerComplete.listen((event) {
      // When a workout audio finishes, decide what to play next
      if (_isPlayingEnglish) {
        // If English just finished, play the Japanese part
        final currentPhrase = widget.workout.phrases[_currentPhraseIndex];
        _playAudio(currentPhrase.audioPathJp, isEnglish: false);
      } else {
        // If Japanese just finished...
        if (_isLooping) {
          // ...and we are looping, play the same phrase again from the start (English)
          _startCurrentPhrase();
        } else {
          // ...and not looping, move to the next phrase
          _playNextPhrase();
        }
      }
    });

    // Start the sequence by playing the random quote
    _playRandomQuote();
  }

  @override
  void dispose() {
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _playerStateSubscription.cancel();
    _quotePlayerCompleteSubscription.cancel();
    _workoutPlayerCompleteSubscription.cancel();
    _workoutAudioPlayer.dispose();
    _quoteAudioPlayer.dispose();
    super.dispose();
  }

  // --- Audio Control Methods ---

  Future<void> _playAudio(String path, {required bool isEnglish}) async {
    // Reset position for the new track
    setState(() {
      _position = Duration.zero;
      _isPlayingEnglish = isEnglish;
    });
    // await _workoutAudioPlayer.play(AssetSource(path)); // Temporarily disabled audio playback
  }
  
  void _startCurrentPhrase() {
    if (widget.workout.phrases.isEmpty) return;
    final currentPhrase = widget.workout.phrases[_currentPhraseIndex];
    _playAudio(currentPhrase.audioPathEn, isEnglish: true);
  }

  void _playNextPhrase() {
    if (widget.workout.phrases.isEmpty) return;
    // Advance index, looping back to 0 if at the end
    setState(() {
      _currentPhraseIndex = (_currentPhraseIndex + 1) % widget.workout.phrases.length;
    });
    _startCurrentPhrase();
  }

  void _playRandomQuote() async {
    final random = Random();
    final Quote randomQuote = dummyQuotes[random.nextInt(dummyQuotes.length)];
    // await _quoteAudioPlayer.play(AssetSource(randomQuote.audioPath)); // Temporarily disabled audio playback
  }

  Future<void> _pause() async {
    await _workoutAudioPlayer.pause();
  }

  Future<void> _resume() async {
    await _workoutAudioPlayer.resume();
  }

  // --- Build Method ---

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Image.asset(
                widget.workout.animationPath,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _currentPhraseEnglishText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _currentPhraseJapaneseText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            Slider(
              min: 0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble()),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await _workoutAudioPlayer.seek(position);
                await _workoutAudioPlayer.resume();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatTime(_position)),
                  Text(_formatTime(_duration - _position)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _isLooping ? Icons.repeat_one_on : Icons.repeat,
                    color: _isLooping ? colorScheme.primary : null,
                  ),
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      _isLooping = !_isLooping;
                    });
                  },
                ),
                const SizedBox(width: 24),
                IconButton(
                  icon: Icon(
                    _playerState == PlayerState.playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  ),
                  iconSize: 64,
                  color: colorScheme.primary,
                  onPressed: () {
                    if (_playerState == PlayerState.playing) {
                      _pause();
                    } else {
                      _resume();
                    }
                  },
                ),
                const SizedBox(width: 24),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 32,
                  onPressed: _playNextPhrase,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}

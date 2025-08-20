import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:fitness_english_app/app/data/dummy_data.dart';
import 'package:fitness_english_app/app/data/models/quote.dart';
import 'package:fitness_english_app/app/data/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool _isEnglishOnly = false; // New state for playback mode
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
      if (_isPlayingEnglish) {
        // If English just finished...
        if (_isEnglishOnly) {
          // ...and in English-only mode, play the next phrase directly.
          if (_isLooping) {
            _startCurrentPhrase(); // Replay the same English phrase
          } else {
            _playNextPhrase(); // Play the next English phrase
          }
        } else {
          // ...and not in English-only mode, play the Japanese part.
          final currentPhrase = widget.workout.phrases[_currentPhraseIndex];
          _playAudio(currentPhrase.audioPathJp, isEnglish: false);
        }
      } else {
        // If Japanese just finished (this part only runs if not in English-only mode)
        if (_isLooping) {
          _startCurrentPhrase();
        } else {
          _playNextPhrase();
        }
      }
    });

    // Start the sequence by playing the random quote after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _playRandomQuote();
      }
    });
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
    final byteData = await rootBundle.load(path);
    await _workoutAudioPlayer.play(BytesSource(byteData.buffer.asUint8List()));
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
    final byteData = await rootBundle.load(randomQuote.audioPath);
    await _quoteAudioPlayer.play(BytesSource(byteData.buffer.asUint8List()));
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
          children: [
            Expanded(
              flex: 3,
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
                  // Hide Japanese text in English-only mode
                  if (!_isEnglishOnly)
                    Text(
                      _currentPhraseJapaneseText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Slider(
                    min: 0,
                    max: _duration.inMilliseconds.toDouble(),
                    value: _position.inMilliseconds.toDouble().clamp(0, _duration.inMilliseconds.toDouble()),
                    onChanged: (value) async {
                      final position = Duration(milliseconds: value.toInt());
                      await _workoutAudioPlayer.seek(position);
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
                  const SizedBox(height: 16),
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
                        iconSize: 72, // Increased size
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("English Only", style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(width: 8),
                      Switch(
                        value: _isEnglishOnly,
                        onChanged: (value) {
                          setState(() {
                            _isEnglishOnly = value;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
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
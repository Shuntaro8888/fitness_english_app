import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fitness_english_app/app/data/dummy_data.dart';
import 'package:fitness_english_app/app/data/models/quote.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  late Quote _currentQuote;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentQuote = _getRandomQuote();
    _playQuoteAudio(_currentQuote);
  }

  Quote _getRandomQuote() {
    final random = Random();
    return dummyQuotes[random.nextInt(dummyQuotes.length)];
  }

  void _playQuoteAudio(Quote quote) async {
    if (quote.audioPath.isNotEmpty) {
      await _audioPlayer.play(AssetSource(quote.audioPath));
    }
  }

  void _showAnotherQuote() {
    setState(() {
      _currentQuote = _getRandomQuote();
      _playQuoteAudio(_currentQuote);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentQuote.englishText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),
              Text(
                _currentQuote.japaneseText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _showAnotherQuote,
                child: const Text('Show Another Quote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
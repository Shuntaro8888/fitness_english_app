import 'package:flutter/material.dart';
import 'package:fitness_english_app/app/data/dummy_data.dart';
import 'package:fitness_english_app/app/presentation/screens/workout_selection_screen.dart';
import 'package:fitness_english_app/app/presentation/screens/quote_screen.dart';

class BodyPartSelectionScreen extends StatelessWidget {
  const BodyPartSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyParts = dummyWorkouts.map((workout) => workout.bodyPart).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Body Part'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bodyParts.length,
              itemBuilder: (context, index) {
                final bodyPart = bodyParts[index];
                return ListTile(
                  title: Text(bodyPart),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutSelectionScreen(bodyPart: bodyPart),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuoteScreen(),
                ),
              );
            },
            child: const Text('Show Quotes'),
          ),
        ],
      ),
    );
  }
}
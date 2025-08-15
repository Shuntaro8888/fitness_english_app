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
        actions: [
          IconButton(
            icon: const Icon(Icons.format_quote),
            tooltip: 'Show Quotes',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuoteScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bodyParts.length,
              itemBuilder: (context, index) {
                final bodyPart = bodyParts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(bodyPart),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutSelectionScreen(bodyPart: bodyPart),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
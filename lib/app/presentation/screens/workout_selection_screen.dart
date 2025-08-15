import 'package:flutter/material.dart';
import 'package:fitness_english_app/app/data/dummy_data.dart';

import 'package:fitness_english_app/app/presentation/screens/workout_execution_screen.dart';

class WorkoutSelectionScreen extends StatelessWidget {
  final String bodyPart;

  const WorkoutSelectionScreen({super.key, required this.bodyPart});

  @override
  Widget build(BuildContext context) {
    final workouts = dummyWorkouts.where((workout) => workout.bodyPart == bodyPart).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(bodyPart),
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(workout.name),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutExecutionScreen(workout: workout),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
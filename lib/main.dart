import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> habits = [];
  List<bool> habitStatus = [];
  Map<String, DateTime> habitDates = {};
  Map<String, DateTime?> completionDates = {};

  // Navigate to Add Habit Page and get the new habit name
  void _navigateToAddHabitPage() async {
    final newHabit = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddHabitPage(),
      ),
    );

    if (newHabit != null && newHabit is String) {
      setState(() {
        habits.add(newHabit);
        habitStatus.add(false); // Initialize new habit status as incomplete
        habitDates[newHabit] = DateTime.now();
        completionDates[newHabit] = null; // Initialize completion date as null
      });
    }
  }

  // Toggle the status of a habit (complete/incomplete)
  void _toggleHabitStatus(int index) {
    setState(() {
      habitStatus[index] = !habitStatus[index];
      completionDates[habits[index]] =
          habitStatus[index] ? DateTime.now() : null; // Update completion date
    });
  }

  // Remove a habit
  void _removeHabit(int index) {
    setState(() {
      completionDates.remove(habits[index]);
      habitDates.remove(habits[index]);
      habits.removeAt(index);
      habitStatus.removeAt(index);
    });
  }

  // Function to calculate relative time
  String timeAgo(DateTime dateTime) {
    return timeago.format(dateTime, locale: 'en_short');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: habits.isEmpty
            ? const Center(
                child: Text(
                  'No habits yet! Tap the + button to add one.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        habit,
                        style: TextStyle(
                          decoration: habitStatus[index]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Added: ${timeAgo(habitDates[habit]!)}',
                          ),
                          if (completionDates[habit] != null)
                            Text(
                              'Completed: ${timeAgo(completionDates[habit]!)}',
                              style: const TextStyle(color: Colors.green),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: habitStatus[index],
                            onChanged: (value) => _toggleHabitStatus(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeHabit(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddHabitPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddHabitPage extends StatelessWidget {
  const AddHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController habitController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Habit'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter the name of your habit:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: habitController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newHabit = habitController.text.trim();
                if (newHabit.isNotEmpty) {
                  Navigator.pop(context, newHabit);
                }
              },
              child: const Text('Add Habit'),
            ),
          ],
        ),
      ),
    );
  }
}

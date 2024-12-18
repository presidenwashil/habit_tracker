import 'package:flutter/material.dart';
import 'package:habit_tracker/splash_screen.dart';
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
      home: const SplashScreen(),
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
  List<Map<String, dynamic>> habits = [];
  List<String> categories = ['Health', 'Productivity', 'Personal Growth'];
  String? selectedCategory;

  // Navigate to Add Habit Page and get the new habit details
  void _navigateToAddHabitPage() async {
    final newHabit = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddHabitPage(categories: categories),
      ),
    );

    if (newHabit != null && newHabit is Map<String, dynamic>) {
      setState(() {
        habits.add(newHabit);
      });
    }
  }

  // Toggle the status of a habit (complete/incomplete)
  void _toggleHabitStatus(int index) {
    setState(() {
      habits[index]['status'] = !habits[index]['status'];
    });
  }

  // Remove a habit
  void _removeHabit(int index) {
    setState(() {
      habits.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredHabits = selectedCategory == null
        ? habits
        : habits.where((habit) => habit['category'] == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedCategory = value == 'All' ? null : value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All')),
              ...categories.map((category) => PopupMenuItem(
                    value: category,
                    child: Text(category),
                  )),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: filteredHabits.isEmpty
            ? const Center(
                child: Text(
                  'No habits yet! Tap the + button to add one.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemCount: filteredHabits.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        filteredHabits[index]['name'],
                        style: TextStyle(
                          decoration: filteredHabits[index]['status']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                          'Category: ${filteredHabits[index]['category']}\nAdded on: ${filteredHabits[index]['date'].toLocal().toString().split(' ')[0]}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: filteredHabits[index]['status'],
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
  final List<String> categories;

  const AddHabitPage({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController habitController = TextEditingController();
    String? selectedCategory;

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
            const SizedBox(height: 20),
            TextField(
              controller: habitController,
              decoration: const InputDecoration(
                hintText: 'E.g. Exercise for 30 minutes',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                selectedCategory = value;
              },
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (habitController.text.isNotEmpty && selectedCategory != null) {
                  Navigator.pop(
                    context,
                    {
                      'name': habitController.text,
                      'category': selectedCategory,
                      'status': false,
                      'date': DateTime.now(),
                    },
                  );
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

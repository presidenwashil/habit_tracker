import 'package:flutter/material.dart';
import 'package:habit_tracker/add_habit_page.dart';

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

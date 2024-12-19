import 'package:flutter/material.dart';

class AddHabitPage extends StatelessWidget {
  final List<String> categories;

  const AddHabitPage({super.key, required this.categories});

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
                        const SizedBox(height: 10),
            TextField(
              controller: habitController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g., Morning Run',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select a category:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedCategory = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (habitController.text.isNotEmpty &&
                    selectedCategory != null) {
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
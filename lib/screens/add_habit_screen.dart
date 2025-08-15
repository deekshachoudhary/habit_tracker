import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/icon_list.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  Color _selectedColor = Colors.teal;
  IconData _selectedIcon = Icons.local_drink;

  void _pickColor() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick a color"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Done"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final newHabit = Habit(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        iconPath: _selectedIcon.codePoint.toString(),
        color: '#${_selectedColor.value.toRadixString(16).substring(2)}',
      );
      Provider.of<HabitProvider>(context, listen: false).addHabit(newHabit);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Add Habit"),
        leading: const BackButton(),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: sw * 0.06, vertical: sh * 0.02),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title input
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Habit Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(sw * 0.04),
                    ),
                    labelStyle: TextStyle(
                      fontSize: sw * 0.045,
                    ),
                  ),
                  style: TextStyle(fontSize: sw * 0.047),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Please enter a habit name"
                      : null,
                ),
                SizedBox(height: sh * 0.03),

                // Color picker
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _selectedColor,
                      radius: sw * 0.055,
                    ),
                    SizedBox(width: sw * 0.04),
                    Text(
                      "Choose Color",
                      style: TextStyle(
                        fontSize: sw * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.color_lens, size: sw * 0.065),
                      onPressed: _pickColor,
                    ),
                  ],
                ),
                SizedBox(height: sh * 0.025),

                // Icon selector grid
                Text(
                  "Select Icon",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: sw * 0.045,
                  ),
                ),
                SizedBox(height: sh * 0.009),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: sw * 0.025,
                  runSpacing: sh * 0.012,
                  children: habitIcons
                      .map(
                        (icon) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIcon = icon;
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: _selectedIcon == icon
                                ? Colors.teal
                                : Colors.grey.shade300,
                            radius: sw * 0.048,
                            child: Icon(
                              icon,
                              size: sw * 0.055,
                              color: _selectedIcon == icon
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                SizedBox(height: sh * 0.045),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveHabit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: sh * 0.019),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw * 0.06)),
                      elevation: 3,
                      textStyle: TextStyle(
                        fontSize: sw * 0.052,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      "Save Habit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

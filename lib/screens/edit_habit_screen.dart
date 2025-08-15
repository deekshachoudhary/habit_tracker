import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/icon_list.dart';

class EditHabitScreen extends StatefulWidget {
  final Habit habit;

  const EditHabitScreen({super.key, required this.habit});

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late Color _selectedColor;
  late IconData _selectedIcon;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.habit.title);
    _selectedColor =
        Color(int.parse(widget.habit.color.replaceFirst('#', '0xff')));
    _selectedIcon = IconData(
      int.parse(widget.habit.iconPath),
      fontFamily: 'MaterialIcons',
    );
  }

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

  void _updateHabit() {
    if (_formKey.currentState!.validate()) {
      final updatedHabit = Habit(
        id: widget.habit.id,
        title: _titleController.text.trim(),
        iconPath: _selectedIcon.codePoint.toString(),
        color: '#${_selectedColor.value.toRadixString(16).substring(2)}',
        currentStreak: widget.habit.currentStreak,
        bestStreak: widget.habit.bestStreak,
        lastCompletedDate: widget.habit.lastCompletedDate,
      );

      Provider.of<HabitProvider>(context, listen: false)
          .updateHabit(updatedHabit);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Habit")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Habit Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Please enter a habit name"
                    : null,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(backgroundColor: _selectedColor),
                title: const Text("Choose Color"),
                trailing: const Icon(Icons.color_lens),
                onTap: _pickColor,
              ),
              const SizedBox(height: 20),
              const Text("Select Icon",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
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
                          child: Icon(
                            icon,
                            color: _selectedIcon == icon
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _updateHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Save Changes",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

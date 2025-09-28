import 'package:flutter/material.dart';

class AddUserButton extends StatefulWidget {
  final Function(String name, String email, int age) onPressed;
  
  const AddUserButton({super.key, required this.onPressed});

  @override
  State<AddUserButton> createState() => _AddUserButtonState();
}

class _AddUserButtonState extends State<AddUserButton> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showAddUserDialog(BuildContext context) {
    // Clear controllers when dialog opens
    nameController.clear();
    ageController.clear();
    emailController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Add User"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter age';
                      }
                      final age = int.tryParse(value);
                      if (age == null) {
                        return 'Please enter a valid number';
                      }
                      if (age < 18) {
                        return 'Age must be 18 or above';
                      }
                      if (age > 120) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an email';
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        caseSensitive: false,
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _onAddPressed(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _onAddPressed(BuildContext context) {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Parse age
      final age = int.tryParse(ageController.text) ?? 0;
      
      // Call the callback with validated data
      widget.onPressed(
        nameController.text.trim(),
        emailController.text.trim(),
        age,
      );
      
      // Close the dialog
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add),
      label: const Text("Add User"),
      onPressed: () => _showAddUserDialog(context),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
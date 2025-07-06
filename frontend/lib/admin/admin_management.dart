import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminManagementPage extends StatefulWidget {
  const AdminManagementPage({super.key});

  @override
  AdminManagementPageState createState() => AdminManagementPageState();
}

class AdminManagementPageState extends State<AdminManagementPage> {
  final List<Map<String, String>> admins = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF423737), // Background color
      appBar: AppBar(
        title: const Text('Admin Management'),
        backgroundColor: const Color(0xFFFEB711),
      ),
      body: ListView.builder(
        itemCount: admins.length,
        itemBuilder: (context, index) {
          final admin = admins[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: admin['profilePhoto'] != null &&
                        admin['profilePhoto']!.isNotEmpty
                    ? FileImage(File(admin['profilePhoto']!))
                    : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
              ),
              title: Text('${admin['firstName']} ${admin['lastName']}'),
              subtitle: Text(admin['designation'] ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () => _viewAdminDetails(admin),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editAdminDetails(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeAdmin(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFEB711),
        onPressed: _showAddAdminForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _viewAdminDetails(Map<String, String> admin) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Admin Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (admin['profilePhoto'] != null &&
                    admin['profilePhoto']!.isNotEmpty)
                  Image.file(File(admin['profilePhoto']!)),
                const SizedBox(height: 10),
                Text('Name: ${admin['firstName']} ${admin['lastName']}'),
                Text('Designation: ${admin['designation']}'),
                Text('Username: ${admin['username']}'),
                Text('Email: ${admin['email']}'),
                Text('Phone: ${admin['phone']}'),
                Text('Address: ${admin['address']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _editAdminDetails(int index) {
    final admin = admins[index];
    TextEditingController firstNameController =
        TextEditingController(text: admin['firstName']);
    TextEditingController lastNameController =
        TextEditingController(text: admin['lastName']);
    TextEditingController designationController =
        TextEditingController(text: admin['designation']);
    TextEditingController usernameController =
        TextEditingController(text: admin['username']);
    TextEditingController emailController =
        TextEditingController(text: admin['email']);
    TextEditingController phoneController =
        TextEditingController(text: admin['phone']);
    TextEditingController addressController =
        TextEditingController(text: admin['address']);
    String profilePhoto = admin['profilePhoto'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateSB) {
          return AlertDialog(
            title: const Text('Edit Admin'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        setStateSB(() {
                          profilePhoto = pickedFile.path;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: profilePhoto.isNotEmpty
                          ? FileImage(File(profilePhoto))
                          : const AssetImage('assets/default_avatar.png')
                              as ImageProvider,
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                      controller: firstNameController,
                      decoration:
                          const InputDecoration(labelText: 'First Name')),
                  TextField(
                      controller: lastNameController,
                      decoration:
                          const InputDecoration(labelText: 'Last Name')),
                  TextField(
                      controller: designationController,
                      decoration:
                          const InputDecoration(labelText: 'Designation')),
                  TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: 'Username')),
                  TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email')),
                  TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Phone')),
                  TextField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Address')),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  setState(() {
                    admins[index] = {
                      'profilePhoto': profilePhoto,
                      'firstName': firstNameController.text,
                      'lastName': lastNameController.text,
                      'designation': designationController.text,
                      'username': usernameController.text,
                      'email': emailController.text,
                      'phone': phoneController.text,
                      'address': addressController.text,
                    };
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }

  void _removeAdmin(int index) {
    setState(() {
      admins.removeAt(index);
    });
  }

  void _showAddAdminForm() {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController designationController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    String profilePhoto = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateSB) {
          return AlertDialog(
            title: const Text('Add New Admin'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        setStateSB(() {
                          profilePhoto = pickedFile.path;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: profilePhoto.isNotEmpty
                          ? FileImage(File(profilePhoto))
                          : const AssetImage('assets/default_avatar.png')
                              as ImageProvider,
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.add_a_photo, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                      controller: firstNameController,
                      decoration:
                          const InputDecoration(labelText: 'First Name')),
                  TextField(
                      controller: lastNameController,
                      decoration:
                          const InputDecoration(labelText: 'Last Name')),
                  TextField(
                      controller: designationController,
                      decoration:
                          const InputDecoration(labelText: 'Designation')),
                  TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: 'Username')),
                  TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email')),
                  TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Phone')),
                  TextField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Address')),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  setState(() {
                    admins.add({
                      'profilePhoto': profilePhoto,
                      'firstName': firstNameController.text,
                      'lastName': lastNameController.text,
                      'designation': designationController.text,
                      'username': usernameController.text,
                      'email': emailController.text,
                      'phone': phoneController.text,
                      'address': addressController.text,
                    });
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
      },
    );
  }
}

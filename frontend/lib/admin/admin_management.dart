import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

// Admin Model
class Admin {
  final int? userId;
  final String email;
  final String username;
  final String password;
  final String role;
  final String? userImage;
  final String phoneNo;
  final String address;
  final String firstName;
  final String lastName;
  final bool isDeleted;

  Admin({
    this.userId,
    required this.email,
    required this.username,
    required this.password,
    required this.role,
    this.userImage,
    required this.phoneNo,
    required this.address,
    required this.firstName,
    required this.lastName,
    this.isDeleted = false,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      userId: json['user_id'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      userImage: json['user_image'],
      phoneNo: json['phone_no'],
      address: json['address'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      isDeleted: json['is_deleted'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'username': username,
      'password': password,
      'role': role,
      'user_image': userImage,
      'phone_no': phoneNo,
      'address': address,
      'first_name': firstName,
      'last_name': lastName,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }
}

// API Service
class AdminApiService {
  static const String baseUrl =
      'https://sip-fresh-backend-new.vercel.app/api/auth';

  // Test connectivity
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admins'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Get all admins
  static Future<List<Admin>> getAllAdmins() async {
    try {
      print('Fetching admins from: $baseUrl/admins');

      final response = await http.get(
        Uri.parse('$baseUrl/admins'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.trim().startsWith('<!DOCTYPE') ||
            response.body.trim().startsWith('<html')) {
          throw Exception(
              'Server returned HTML instead of JSON. Check API endpoint.');
        }

        try {
          final Map<String, dynamic> data = json.decode(response.body);
          if (data['status'] == 'success') {
            final List<dynamic> adminsData = data['data'];
            return adminsData.map((admin) => Admin.fromJson(admin)).toList();
          } else {
            throw Exception('API Error: ${data['message'] ?? 'Unknown error'}');
          }
        } catch (jsonError) {
          throw Exception('Invalid JSON response: $jsonError');
        }
      } else {
        throw Exception(
            'HTTP Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in getAllAdmins: $e');
      throw Exception('Error fetching admins: $e');
    }
  }

  // Add new admin - Cross-platform compatible
  static Future<Map<String, dynamic>> addAdmin(
      Admin admin, dynamic imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/add-admin'),
      );

      // Add headers
      request.headers['Accept'] = 'application/json';

      // Add form fields
      request.fields['first_name'] = admin.firstName;
      request.fields['last_name'] = admin.lastName;
      request.fields['username'] = admin.username;
      request.fields['email'] = admin.email;
      request.fields['password'] = admin.password;
      request.fields['phone_no'] = admin.phoneNo;
      request.fields['address'] = admin.address;
      request.fields['role'] = admin.role;

      // Add image file if provided - handle both web and mobile
      if (imageFile != null) {
        if (kIsWeb) {
          // For web platform
          if (imageFile is XFile) {
            final bytes = await imageFile.readAsBytes();
            request.files.add(
              http.MultipartFile.fromBytes(
                'user_image',
                bytes,
                filename: imageFile.name,
              ),
            );
          }
        } else {
          // For mobile platforms
          if (imageFile is File) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'user_image',
                imageFile.path,
              ),
            );
          } else if (imageFile is XFile) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'user_image',
                imageFile.path,
              ),
            );
          }
        }
      }

      print('Sending request to: ${request.url}');
      print('Request fields: ${request.fields}');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      //print('Add admin response status: ${response.statusCode}');
      print('Add admin response body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final Map<String, dynamic> data = json.decode(responseBody);
          return data;
        } catch (jsonError) {
          throw Exception('Invalid JSON response: $jsonError');
        }
      } else {
        // Try to parse error response
        try {
          final Map<String, dynamic> errorData = json.decode(responseBody);
          throw Exception(
              'Server Error: ${errorData['message'] ?? 'Unknown error'}');
        } catch (jsonError) {
          throw Exception('HTTP Error ${response.statusCode}: $responseBody');
        }
      }
    } catch (e) {
      print('Error in addAdmin: $e');
      throw Exception('Error adding admin: $e');
    }
  }

  // Update admin - Cross-platform compatible
  static Future<Map<String, dynamic>> updateAdmin(
      Admin admin, dynamic imageFile) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/admins/${admin.userId}'),
      );

      // Add headers
      request.headers['Accept'] = 'application/json';

      // Add form fields
      request.fields['first_name'] = admin.firstName;
      request.fields['last_name'] = admin.lastName;
      request.fields['username'] = admin.username;
      request.fields['email'] = admin.email;
      request.fields['password'] = admin.password;
      request.fields['phone_no'] = admin.phoneNo;
      request.fields['address'] = admin.address;
      request.fields['role'] = admin.role;

      // Add image file if provided - handle both web and mobile
      if (imageFile != null) {
        if (kIsWeb) {
          // For web platform
          if (imageFile is XFile) {
            final bytes = await imageFile.readAsBytes();
            request.files.add(
              http.MultipartFile.fromBytes(
                'user_image',
                bytes,
                filename: imageFile.name,
              ),
            );
          }
        } else {
          // For mobile platforms
          if (imageFile is File) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'user_image',
                imageFile.path,
              ),
            );
          } else if (imageFile is XFile) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'user_image',
                imageFile.path,
              ),
            );
          }
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      //print('Update admin response status: ${response.statusCode}');
      print('Update admin response body: $responseBody');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = json.decode(responseBody);
          return data;
        } catch (jsonError) {
          throw Exception('Invalid JSON response: $jsonError');
        }
      } else {
        try {
          final Map<String, dynamic> errorData = json.decode(responseBody);
          throw Exception(
              'Server Error: ${errorData['message'] ?? 'Unknown error'}');
        } catch (jsonError) {
          throw Exception('HTTP Error ${response.statusCode}: $responseBody');
        }
      }
    } catch (e) {
      print('Error in updateAdmin: $e');
      throw Exception('Error updating admin: $e');
    }
  }

  // Delete admin
  static Future<Map<String, dynamic>> deleteAdmin(int adminId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/admins/$adminId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // print('Delete admin response status: ${response.statusCode}');
      print('Delete admin response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = json.decode(response.body);
          return data;
        } catch (jsonError) {
          throw Exception('Invalid JSON response: $jsonError');
        }
      } else {
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          throw Exception(
              'Server Error: ${errorData['message'] ?? 'Unknown error'}');
        } catch (jsonError) {
          throw Exception(
              'HTTP Error ${response.statusCode}: ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      print('Error in deleteAdmin: $e');
      throw Exception('Error deleting admin: $e');
    }
  }
}

class AdminManagementPage extends StatefulWidget {
  const AdminManagementPage({Key? key}) : super(key: key);

  @override
  AdminManagementPageState createState() => AdminManagementPageState();
}

class AdminManagementPageState extends State<AdminManagementPage> {
  List<Admin> admins = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAdmins();
  }

  Future<void> _loadAdmins() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedAdmins = await AdminApiService.getAllAdmins();
      setState(() {
        admins = fetchedAdmins;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE2EEED),
      appBar: AppBar(
        title: const Text('Admin Management'),
        backgroundColor: const Color.fromARGB(255, 174, 156, 115),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAdmins,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 83, 71, 42),
        onPressed: _showAddAdminForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 83, 71, 42)),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: const Color.fromARGB(255, 63, 138, 83),
              ),
              const SizedBox(height: 16),
              Text(
                'Error: $errorMessage',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadAdmins,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 83, 71, 42),
                ),
                child: const Text('Retry'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _testConnection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Test Connection'),
              ),
            ],
          ),
        ),
      );
    }

    if (admins.isEmpty) {
      return const Center(
        child: Text(
          'No admins found',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: admins.length,
      itemBuilder: (context, index) {
        final admin = admins[index];
        return Card(
          color: Color(0xFFF5F5F5),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: _buildAvatar(admin.userImage),
            title: Text('${admin.firstName} ${admin.lastName}'),
            subtitle: Text(admin.role),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  onPressed: () => _viewAdminDetails(admin),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editAdminDetails(admin),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmDeleteAdmin(admin),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (exception, stackTrace) {
          // Handle image loading error
        },
        // child: const Icon(Icons.person), // Fallback icon
      );
    } else {
      return const CircleAvatar(
        child: Icon(Icons.person),
      );
    }
  }

  void _viewAdminDetails(Admin admin) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Admin Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (admin.userImage != null && admin.userImage!.isNotEmpty)
                  Image.network(
                    admin.userImage!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 100);
                    },
                  ),
                const SizedBox(height: 10),
                Text('Name: ${admin.firstName} ${admin.lastName}'),
                Text('Role: ${admin.role}'),
                Text('Username: ${admin.username}'),
                Text('Email: ${admin.email}'),
                Text('Phone: ${admin.phoneNo}'),
                Text('Address: ${admin.address}'),
                Text('User ID: ${admin.userId}'),
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

  void _editAdminDetails(Admin admin) {
    TextEditingController firstNameController =
        TextEditingController(text: admin.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: admin.lastName);
    TextEditingController usernameController =
        TextEditingController(text: admin.username);
    TextEditingController emailController =
        TextEditingController(text: admin.email);
    TextEditingController passwordController =
        TextEditingController(text: admin.password);
    TextEditingController phoneController =
        TextEditingController(text: admin.phoneNo);
    TextEditingController addressController =
        TextEditingController(text: admin.address);
    TextEditingController roleController =
        TextEditingController(text: admin.role);

    dynamic selectedImage;
    Uint8List? webImage;
    String? currentImageUrl = admin.userImage;

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
                          selectedImage = pickedFile;
                          if (kIsWeb) {
                            // For web, store the bytes for preview
                            pickedFile.readAsBytes().then((bytes) {
                              setStateSB(() {
                                webImage = bytes;
                              });
                            });
                          }
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _getImageProvider(
                          selectedImage, webImage, currentImageUrl),
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  TextField(
                    controller: roleController,
                    decoration: const InputDecoration(labelText: 'Role'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final updatedAdmin = Admin(
                    userId: admin.userId,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    username: usernameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    phoneNo: phoneController.text,
                    address: addressController.text,
                    role: roleController.text,
                    userImage: currentImageUrl,
                  );

                  try {
                    final response = await AdminApiService.updateAdmin(
                        updatedAdmin, selectedImage);
                    if (response['status'] == 'success') {
                      Navigator.of(context).pop(); // Close dialog first
                      await _loadAdmins(); // Then refresh the list
                      _showSuccessMessage('Admin updated successfully');
                    } else {
                      _showErrorMessage('Status: ${response['message']}');
                    }
                  } catch (e) {
                    _showErrorMessage('Status: $e');
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }

  void _confirmDeleteAdmin(Admin admin) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete ${admin.firstName} ${admin.lastName}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first
                await _deleteAdmin(admin); // Then perform delete
              },
              child: const Text('Delete',
                  style: TextStyle(color: Color.fromARGB(255, 60, 244, 54))),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAdmin(Admin admin) async {
    try {
      final response = await AdminApiService.deleteAdmin(admin.userId!);
      if (response['status'] == 'success') {
        await _loadAdmins(); // Refresh the list
        _showSuccessMessage('Admin deleted successfully');
      } else {
        _showErrorMessage('Status: ${response['message']}');
      }
    } catch (e) {
      _showErrorMessage('Status: $e');
    }
  }

  void _showAddAdminForm() {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController roleController = TextEditingController(text: 'admin');

    dynamic selectedImage;
    Uint8List? webImage;
    bool isSubmitting = false;

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
                          selectedImage = pickedFile;
                          if (kIsWeb) {
                            // For web, store the bytes for preview
                            pickedFile.readAsBytes().then((bytes) {
                              setStateSB(() {
                                webImage = bytes;
                              });
                            });
                          }
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _getImageProvider(selectedImage, webImage, null),
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
                        const InputDecoration(labelText: 'First Name *'),
                  ),
                  TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name *'),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username *'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email *'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password *'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  TextField(
                    controller: roleController,
                    decoration: const InputDecoration(labelText: 'Role *'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    isSubmitting ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        if (firstNameController.text.isEmpty ||
                            lastNameController.text.isEmpty ||
                            usernameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            roleController.text.isEmpty) {
                          _showErrorMessage(
                              'Please fill in all required fields (*)');
                          return;
                        }

                        // Email validation
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!emailRegex.hasMatch(emailController.text)) {
                          _showErrorMessage(
                              'Please enter a valid email address');
                          return;
                        }

                        setStateSB(() {
                          isSubmitting = true;
                        });

                        final newAdmin = Admin(
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          username: usernameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text,
                          phoneNo: phoneController.text.trim(),
                          address: addressController.text.trim(),
                          role: roleController.text.trim(),
                        );

                        try {
                          final response = await AdminApiService.addAdmin(
                              newAdmin, selectedImage);
                          if (response['status'] == 'success') {
                            Navigator.of(context).pop(); // Close dialog first
                            await _loadAdmins(); // Then refresh the list
                            _showSuccessMessage('Admin added successfully');
                          } else {
                            _showErrorMessage('Status: ${response['message']}');
                          }
                        } catch (e) {
                          _showErrorMessage('Status: $e');
                        } finally {
                          setStateSB(() {
                            isSubmitting = false;
                          });
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit'),
              ),
            ],
          );
        });
      },
    );
  }

  // Helper method to get the appropriate image provider
  ImageProvider? _getImageProvider(
      dynamic selectedImage, Uint8List? webImage, String? currentImageUrl) {
    if (selectedImage != null) {
      if (kIsWeb && webImage != null) {
        return MemoryImage(webImage);
      } else if (!kIsWeb && selectedImage is File) {
        return FileImage(selectedImage);
      }
    }

    if (currentImageUrl != null && currentImageUrl.isNotEmpty) {
      return NetworkImage(currentImageUrl);
    }

    return null;
  }

  Future<void> _testConnection() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final isConnected = await AdminApiService.testConnection();
      setState(() {
        isLoading = false;
        if (isConnected) {
          errorMessage = 'Connection successful! API is reachable.';
        } else {
          errorMessage =
              'Connection failed! Please check your API URL and network.';
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Connection test error: $e';
      });
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 68, 107, 34),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

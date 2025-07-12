import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

// Platform-specific imports
import 'dart:io' if (dart.library.html) 'dart:html' show File;

class ItemManagementPage extends StatefulWidget {
  const ItemManagementPage({Key? key}) : super(key: key);

  @override
  ItemManagementPageState createState() => ItemManagementPageState();
}

class ItemManagementPageState extends State<ItemManagementPage> {
  List<Map<String, dynamic>> items = [];
  final ImagePicker _picker = ImagePicker();
  final String baseUrl = 'https://sip-fresh-backend-new.vercel.app/api/items';
  final String bearerToken = 'YOUR_BEARER_TOKEN_HERE';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAllItems();
  }

  Map<String, String> get headers => {
        'Authorization': 'Bearer $bearerToken',
      };

  Future<void> _fetchAllItems() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_all'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data
              .map((item) => {
                    'item_id': item['item_id'],
                    'name': item['item_name'] ?? '',
                    'description': item['item_description'] ?? '',
                    'price': item['item_price'].toString(),
                    'category': item['category_name'] ?? '',
                    'imagePath': item['item_image'] ?? '',
                  })
              .toList();
        });
      } else {
        _showErrorDialog('Failed to load items');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _addItem(Map<String, dynamic> itemData) async {
    setState(() => _isLoading = true);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/add-item'),
      );

      request.headers['Authorization'] = 'Bearer $bearerToken';

      request.fields['item_name'] = itemData['name'];
      request.fields['item_description'] = itemData['description'];
      request.fields['item_price'] = itemData['price'];
      request.fields['category_name'] = itemData['category'];

      // Handle image upload based on platform
      if (itemData['imageBytes'] != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'item_image',
          itemData['imageBytes'],
          filename: 'image.jpg',
        ));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        _fetchAllItems();
        _showSuccessDialog('Item added successfully');
      } else {
        final respStr = await response.stream.bytesToString();
        _showErrorDialog('Failed to add item: $respStr');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _updateItem(int itemId, Map<String, dynamic> itemData) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$itemId'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'item_name': itemData['name'],
          'item_description': itemData['description'],
          'item_price': itemData['price'],
          'category_name': itemData['category'],
        }),
      );

      if (response.statusCode == 200) {
        _fetchAllItems();
        _showSuccessDialog('Item updated successfully');
      } else {
        _showErrorDialog('Failed to update item');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _deleteItem(int itemId) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$itemId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        _fetchAllItems();
        _showSuccessDialog('Item deleted successfully');
      } else {
        _showErrorDialog('Failed to delete item');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
    setState(() => _isLoading = false);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddItemForm() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final categoryController = TextEditingController();
    Uint8List? imageBytes;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Item'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final XFile? pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            imageBytes = await pickedFile.readAsBytes();
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                            image: imageBytes != null
                                ? DecorationImage(
                                    image: MemoryImage(imageBytes!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: imageBytes == null
                              ? const Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
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
                    if (nameController.text.isNotEmpty) {
                      final newItem = {
                        'name': nameController.text,
                        'description': descriptionController.text,
                        'price': priceController.text,
                        'category': categoryController.text,
                        'imageBytes': imageBytes,
                      };
                      Navigator.of(context).pop();
                      await _addItem(newItem);
                    } else {
                      _showErrorDialog('Name is required');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF423737),
      appBar: AppBar(
        title: const Text('Item Management'),
        backgroundColor: const Color(0xFFFEB711),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAllItems,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(
                  child: Text(
                    'No items added yet.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: _buildImageWidget(item['imagePath']),
                        title: Text(item['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['description']),
                            Text('Price: ${item['price']}'),
                            Text('Category: ${item['category']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editItem(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _showDeleteConfirmation(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFEB711),
        onPressed: _showAddItemForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported),
      );
    }

    return Image.network(
      imagePath,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 50,
          height: 50,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image),
        );
      },
    );
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _removeItem(index);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _removeItem(int index) {
    final itemId = items[index]['item_id'];
    if (itemId != null) {
      _deleteItem(itemId);
    }
  }

  void _editItem(int index) {
    final item = items[index];
    final nameController = TextEditingController(text: item['name']);
    final descriptionController =
        TextEditingController(text: item['description']);
    final priceController = TextEditingController(text: item['price']);
    final categoryController = TextEditingController(text: item['category']);
    Uint8List? imageBytes;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Item'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final XFile? pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            imageBytes = await pickedFile.readAsBytes();
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                            image: imageBytes != null
                                ? DecorationImage(
                                    image: MemoryImage(imageBytes!),
                                    fit: BoxFit.cover,
                                  )
                                : item['imagePath'].isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(item['imagePath']),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                          ),
                          child: imageBytes == null && item['imagePath'].isEmpty
                              ? const Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
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
                    if (nameController.text.isNotEmpty) {
                      final updatedItem = {
                        'name': nameController.text,
                        'description': descriptionController.text,
                        'price': priceController.text,
                        'category': categoryController.text,
                        'imageBytes': imageBytes,
                      };
                      Navigator.of(context).pop();
                      await _updateItem(item['item_id'], updatedItem);
                    } else {
                      _showErrorDialog('Name is required');
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

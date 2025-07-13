import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({Key? key}) : super(key: key);

  @override
  OrderManagementPageState createState() => OrderManagementPageState();
}

class OrderManagementPageState extends State<OrderManagementPage> {
  List<dynamic> orders = [];
  final String baseUrl =
      'https://sip-fresh-backend-new.vercel.app/api/order/admin';
  final String bearerToken =
      'YOUR_TOKEN_HERE'; // Replace with your actual token

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAllOrders();
  }

  Map<String, String> get headers {
    if (bearerToken.isNotEmpty && bearerToken != 'YOUR_TOKEN_HERE') {
      return {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      };
    }
    return {
      'Content-Type': 'application/json',
    };
  }

  Future<void> _fetchAllOrders() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print('Decoded response: $decoded');

        setState(() {
          // Based on your API response, it returns an array directly
          orders = decoded is List ? decoded : [];
        });

        print('Orders count: ${orders.length}');
        if (orders.isNotEmpty) {
          print('First order: ${orders[0]}');
        }
      } else {
        _showErrorDialog(
            'Failed to load orders (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Fetch orders error: $e');
      _showErrorDialog('Error fetching orders: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _deleteOrder(int orderId) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$orderId'),
        headers: headers,
      );

      print('Delete response status: ${response.statusCode}');
      print('Delete response body: ${response.body}');

      if (response.statusCode == 200) {
        await _fetchAllOrders();
        _showSuccessDialog('Order deleted successfully');
      } else {
        _showErrorDialog(
            'Failed to delete order (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Delete order error: $e');
      _showErrorDialog('Error deleting order: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _updateOrderStatus(int orderId, String newStatus) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/order-status/$orderId'),
        headers: headers,
        body: json.encode({'newStatus': newStatus}),
      );

      print('Update Status Response: ${response.statusCode}');
      print('Update Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _fetchAllOrders();
        _showSuccessDialog('Order status updated successfully');
      } else {
        _showErrorDialog(
            'Failed to update order status (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Update Status Error: $e');
      _showErrorDialog('Error updating status: $e');
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

  Future<void> _showOrderDetails(dynamic order) async {
    final orderId = _getOrderField(order, ['order_id', 'id']);
    final orderIdInt = int.tryParse(orderId) ?? 0;

    dynamic orderDetails = order;
    List<dynamic> orderItems = [];
    if (orderIdInt > 0) {
      try {
        setState(() => _isLoading = true);
        final response = await http.get(
          Uri.parse(
              'https://sip-fresh-backend-new.vercel.app/api/order/order-details/$orderIdInt'),
          headers: headers,
        );

        print('Order Details Response: ${response.statusCode}');
        print('Order Details Body: ${response.body}');

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          orderDetails = decoded['orderDetails'] ?? {}; // ✅ fix here
          orderItems = decoded['orderItems'] ?? []; // ✅ fix here
        }
      } catch (e) {
        print('Error fetching order details: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }

    // Extract order details based on API structure
    final displayOrderId = _getOrderField(orderDetails, ['order_id', 'id']);
    final firstName = _getOrderField(orderDetails, ['first_name']);
    final lastName = _getOrderField(orderDetails, ['last_name']);
    final address = _getOrderField(orderDetails, ['address']);
    final city = _getOrderField(orderDetails, ['city']);
    final postalCode = _getOrderField(orderDetails, ['postal_code']);
    final phoneNumber = _getOrderField(orderDetails, ['phone_number']);
    final userId = _getOrderField(orderDetails, ['user_id']);
    final totalPrice = _getOrderField(orderDetails, ['total_price']);
    final discount = _getOrderField(orderDetails, ['discount']);
    final finalTotalPrice = _getOrderField(orderDetails, ['final_total_price']);
    final orderStatus = _getOrderField(orderDetails, ['order_status']);

    // Get order items
    // final orderItems = orderDetails['orderItems'] ?? [];

    String currentStatus = orderStatus.toLowerCase();
    if (currentStatus.isEmpty) currentStatus = 'pending';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Order 0$displayOrderId Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Order ID', displayOrderId),
                _buildDetailRow('Customer', '$firstName $lastName'),
                _buildDetailRow('User ID', userId),
                _buildDetailRow('Phone', phoneNumber),
                _buildDetailRow('Address', address),
                _buildDetailRow('City', city),
                _buildDetailRow('Postal Code', postalCode),
                const SizedBox(height: 15),
                const Text('Order Status:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currentStatus,
                      isExpanded: true,
                      items: ['pending', 'successful', 'canceled']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          currentStatus = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text('Order Items:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...orderItems
                    .map<Widget>((item) => _buildOrderItem(item))
                    .toList(),
                const SizedBox(height: 15),
                _buildPriceRow('Total Price', totalPrice),
                _buildPriceRow('Discount', discount),
                _buildPriceRow('Final Total', finalTotalPrice, isTotal: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (orderIdInt > 0) {
                  _updateOrderStatus(orderIdInt, currentStatus);
                }
              },
              child: const Text('Update Status'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value.isEmpty ? 'N/A' : value),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(dynamic item) {
    final itemName = _getOrderField(item, ['item_name']);
    final quantity = _getOrderField(item, ['quantity']);
    final itemPrice = _getOrderField(item, ['item_price']);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemName.isEmpty ? 'Unknown Item' : itemName,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text('Quantity: $quantity'),
          Text('Price: Rs. $itemPrice'),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            'Rs. ${value.isEmpty ? '0' : value}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _getOrderField(dynamic order, List<String> possibleKeys) {
    if (order == null) return '';

    for (String key in possibleKeys) {
      if (order[key] != null) {
        return order[key].toString();
      }
    }
    return '';
  }

  void _showDeleteConfirmation(int index) {
    final order = orders[index];
    final orderId = _getOrderField(order, ['order_id', 'id']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Order'),
        content: Text('Are you sure you want to delete Order #$orderId?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _removeOrder(index);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _removeOrder(int index) {
    final order = orders[index];
    final orderId = _getOrderField(order, ['order_id', 'id']);
    final orderIdInt = int.tryParse(orderId) ?? 0;

    if (orderIdInt > 0) {
      _deleteOrder(orderIdInt);
    } else {
      _showErrorDialog('Invalid order ID');
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'successful':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF423737),
      appBar: AppBar(
        title: const Text('Order Management'),
        backgroundColor: const Color(0xFFFEB711),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAllOrders,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(
                  child: Text(
                    'No orders found.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchAllOrders,
                  child: ListView.builder(
                    itemCount: orders.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      // Extract order data based on API structure
                      final orderId = _getOrderField(order, ['order_id', 'id']);
                      final itemNames = _getOrderField(order, ['item_names']);
                      final totalFinalPrice =
                          _getOrderField(order, ['total_final_price']);
                      final orderStatus =
                          _getOrderField(order, ['order_status']);

                      // Fallback values
                      final displayOrderId = orderId.isEmpty ? 'N/A' : orderId;
                      final displayItems =
                          itemNames.isEmpty ? 'Unknown Items' : itemNames;
                      final displayTotal =
                          totalFinalPrice.isEmpty ? '0' : totalFinalPrice;
                      final displayStatus = orderStatus.isEmpty
                          ? 'PENDING'
                          : orderStatus.toUpperCase();

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            'Order 0$displayOrderId',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Items: $displayItems'),
                              const SizedBox(height: 2),
                              Text(
                                'Total: Rs. $displayTotal',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(orderStatus),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  displayStatus,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility,
                                    color: Colors.blue),
                                onPressed: () => _showOrderDetails(order),
                                tooltip: 'View Details',
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteConfirmation(index),
                                tooltip: 'Delete Order',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

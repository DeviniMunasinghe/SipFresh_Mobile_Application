import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://sip-fresh-backend-new.vercel.app/api';

  // Fetch all items (we'll limit manually in frontend)
  static Future<List<Map<String, dynamic>>> fetchAllItems() async {
    final response = await http.get(Uri.parse('$baseUrl/items/get_all'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load items');
    }
  }
}

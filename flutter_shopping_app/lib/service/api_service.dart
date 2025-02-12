import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_shopping_app/models/product_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  Future<List<Product>> fetchRecommendedProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/recommended-products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recommended products');
    }
  }

  Future<List<Product>> fetchProducts({int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/products?limit=20&page=$page'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('items')) {
        final List<dynamic> productsData = data['items'];
        return productsData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Key "items" not found in response');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }
}

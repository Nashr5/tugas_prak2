import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  /// Mengambil daftar smartphone dari API DummyJSON
  Future<List<Product>> getSmartphones() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/products/category/smartphones'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productResponse = ProductResponse.fromJson(data);
        return productResponse.products;
      } else {
        throw Exception('Gagal memuat produk (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Kesalahan koneksi: $e');
    }
  }

  /// Mengambil seluruh produk atau kategori terkait gadget
  Future<List<Product>> getAllProducts({int limit = 50}) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/products?limit=$limit'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productResponse = ProductResponse.fromJson(data);
        return productResponse.products;
      } else {
        throw Exception('Gagal memuat semua produk');
      }
    } catch (e) {
      throw Exception('Kesalahan koneksi: $e');
    }
  }

  /// Mencari produk berdasarkan kata kunci pencarian
  Future<List<Product>> searchProducts(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query.trim());
      final response = await http
          .get(Uri.parse('$baseUrl/products/search?q=$encodedQuery'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productResponse = ProductResponse.fromJson(data);
        return productResponse.products;
      } else {
        throw Exception('Gagal melakukan pencarian (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal melakukan pencarian: $e');
    }
  }

  /// Mengambil detail satu produk berdasarkan ID
  Future<Product> getProductById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/products/$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Gagal memuat detail produk');
      }
    } catch (e) {
      throw Exception('Kesalahan koneksi: $e');
    }
  }
}


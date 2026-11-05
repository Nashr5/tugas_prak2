import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // =========================================================
  // BASE URL DOCKER:
  // - Di Android Emulator, localhost host mesin diakses via 10.0.2.2
  // - Di Web (Chrome) & Windows Desktop, diakses via localhost
  // - Jika menggunakan HP fisik via Wi-Fi, Anda bisa mengatur customBaseUrl
  // =========================================================
  static String? customBaseUrl;

  static String get baseUrl {
    if (customBaseUrl != null && customBaseUrl!.isNotEmpty) {
      return customBaseUrl!;
    }
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }

  // ---------- READ (Baca Data) ----------

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
      throw Exception('Kesalahan koneksi ($baseUrl): $e');
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
      throw Exception('Kesalahan koneksi ($baseUrl): $e');
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

  // ---------- CREATE (Tambah Data Baru) ----------

  /// Menambahkan produk baru ke API
  /// DummyJSON akan mengembalikan data produk yang baru dibuat (simulasi)
  Future<Product> createProduct(Product product) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/products/add'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(product.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Gagal menambahkan produk (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal menambahkan produk: $e');
    }
  }

  // ---------- UPDATE (Edit/Perbarui Data) ----------

  /// Memperbarui data produk yang sudah ada berdasarkan ID
  /// DummyJSON menggunakan PUT untuk update seluruh data
  Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/products/$id'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(product.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Gagal memperbarui produk (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal memperbarui produk: $e');
    }
  }

  // ---------- DELETE (Hapus Data) ----------

  /// Menghapus produk berdasarkan ID
  /// DummyJSON akan mengembalikan data produk yang dihapus + field isDeleted
  Future<Product> deleteProduct(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/products/$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Gagal menghapus produk (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }
}

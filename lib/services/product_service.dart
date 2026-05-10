import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rincongaditano/models/response_api.dart';

class ProductService {
  final String _baseUrl = "https://elrincongaditano-backend.onrender.com";

  //get all (admin)
  Future<ResponseApi> getAllProducts(String token) async {
    Uri url = Uri.parse('$_baseUrl/products');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //get available (public)
  Future<ResponseApi> getAvailable() async {
    Uri url = Uri.parse('$_baseUrl/products/available');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //get available by category (public)
  Future<ResponseApi> getAvailableByCategory(String category) async {
    Uri url = Uri.parse('$_baseUrl/products/category/$category');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //get all by category (admin)
  Future<ResponseApi> getAllByCategory(String category, String token) async {
    Uri url = Uri.parse('$_baseUrl/products/admin/category/$category');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //get by id (public)
  Future<ResponseApi> getById(int id) async {
    Uri url = Uri.parse('$_baseUrl/products/$id');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //post create
  Future<ResponseApi> create(
    String token,
    String name,
    String description,
    double price,
    bool available,
    int categoryId,
    String image,
  ) async {
    Uri url = Uri.parse('$_baseUrl/products');
    final response = await http.post(
      url,
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'available': available,
        'categoryId': categoryId,
        'image': image,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //delete
  Future<ResponseApi> delete(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/products/$id');
    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //put switch available
  Future<ResponseApi> switchAvailable(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/products/$id/switchAvailable');
    final response = await http.put(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //put update
  Future<ResponseApi> update(
    int id,
    String token,
    String name,
    String description,
    double price,
    bool available,
    int categoryId,
  ) async {
    Uri url = Uri.parse('$_baseUrl/products/$id');
    final response = await http.put(
      url,
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'available': available,
        'categoryId': categoryId,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }
}

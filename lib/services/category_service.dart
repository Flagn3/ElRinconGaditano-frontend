import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rincongaditano/models/response_api.dart';

class CategoryService {
  final String _baseUrl = "https://elrincongaditano-backend.onrender.com";

  //get all
  Future<ResponseApi> getAllCategories() async {
    Uri url = Uri.parse('$_baseUrl/categories');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  // get by id
  Future<ResponseApi> getById(int id) async {
    Uri url = Uri.parse('$_baseUrl/categories/$id');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //create
  Future<ResponseApi> createCategory(
    String token,
    String name,
    String image,
  ) async {
    Uri url = Uri.parse('$_baseUrl/categories');
    final response = await http.post(
      url,
      body: jsonEncode({'name': name, 'image': image}),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //update
  Future<ResponseApi> updateCategory(
    int id,
    String token,
    String name,
    String image,
  ) async {
    Uri url = Uri.parse('$_baseUrl/categories/$id');
    final response = await http.put(
      url,
      body: jsonEncode({'name': name, 'image': image}),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //delete
  Future<ResponseApi> deleteCategory(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/categories/$id');
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
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rincongaditano/models/response_api.dart';

class UserService {
  final String _baseUrl = "https://elrincongaditano-backend.onrender.com";

  //register
  Future<ResponseApi> register(
    String name,
    String secondName,
    String email,
    String password,
    String address,
  ) async {
    Uri url = Uri.parse('$_baseUrl/auth/register');
    final response = await http.post(
      url,
      body: jsonEncode({
        'name': name,
        'secondName': secondName,
        'email': email,
        'password': password,
        'address': address,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //login
  Future<ResponseApi> login(String email, String password) async {
    Uri url = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      url,
      body: jsonEncode({'email': email, 'password': password}),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  //getAll
  Future<ResponseApi> getAllUsers(String token) async {
    Uri url = Uri.parse('$_baseUrl/users');
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

  //get by id
  Future<ResponseApi> getById(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/users/$id');
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

  //delete
  Future<ResponseApi> deleteUser(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/users/$id');
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

  //activate
  Future<ResponseApi> activateUser(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/users/$id/activate');
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

  //deactivate
  Future<ResponseApi> deactivateUser(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/users/$id/deactivate');
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

  //update
  Future<ResponseApi> updateUser(
    int id,
    String name,
    String secondName,
    String address,
    String token,
  ) async {
    Uri url = Uri.parse('$_baseUrl/users/$id');
    final response = await http.put(
      url,
      body: jsonEncode({
        'name': name,
        'secondName': secondName,
        'address': address,
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

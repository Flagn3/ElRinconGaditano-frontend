import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rincongaditano/models/response_api.dart';

class OrderService {
  final String _baseUrl = "https://elrincongaditano-backend.onrender.com";

  // post /orders
  Future<ResponseApi> createOrder(
    int userId,
    List<Map<String, dynamic>> items,
    String token,
  ) async {
    Uri url = Uri.parse('$_baseUrl/orders');
    final response = await http.post(
      url,
      body: jsonEncode({'userId': userId, 'items': items}),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  // GET /orders (admin)
  Future<ResponseApi> getAllOrders(String token) async {
    Uri url = Uri.parse('$_baseUrl/orders');
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

  // GET /orders/user/{userId}
  Future<ResponseApi> getOrdersByUser(int userId, String token) async {
    Uri url = Uri.parse('$_baseUrl/orders/user/$userId');
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

  // GET /orders/{id}
  Future<ResponseApi> getOrderById(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/orders/$id');
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

  // GET /orders/status/{status} (admin)
  Future<ResponseApi> getOrdersByStatus(String status, String token) async {
    Uri url = Uri.parse('$_baseUrl/orders/status/$status');
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

  // PUT /orders/{id}/status (admin)
  Future<ResponseApi> updateStatus(int id, String status, String token) async {
    Uri url = Uri.parse('$_baseUrl/orders/$id/status');
    final response = await http.put(
      url,
      body: jsonEncode({'status': status}),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return ResponseApi.fromJson(json.decode(response.body));
  }

  // PUT /orders/{id}/cancel
  Future<ResponseApi> cancelOrder(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/orders/$id/cancel');
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
}

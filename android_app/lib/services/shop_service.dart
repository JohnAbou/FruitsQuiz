import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/models/shop_model.dart';

final shopServiceProvider = Provider<ShopService>((ref) {
  final authState = ref.watch(authStateProvider);
  final apiUrl = ref.read(apiUrlProvider);
  return ShopService(authState: authState, baseUrl: apiUrl);
});

class ShopService {
  final AuthState authState;
  final String baseUrl;

  ShopService({
    required this.authState,
    required this.baseUrl,
  });

  Future<int> getUserCurrency(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/currency/$userId'),
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        return _parseJsonResponse<int>(response, (data) => data['currency'] as int);
      } else {
        throw Exception('Failed to load currency: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<ShopItem>> getShopItems(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/shop/$userId'),
        headers: _getHeaders(),
      );
      
      
      if (response.statusCode == 200) {
        return _parseJsonResponse<List<ShopItem>>(
          response,
          (data) => List<ShopItem>.from(
            data['items'].map((item) => ShopItem.fromJson(item)),
          ),
        );
      } else {
        throw Exception('Failed to load shop items: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveShopItems(String userId, List<ShopItem> items) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/shop/$userId'),
        headers: _getHeaders(),
        body: jsonEncode({
          'items': items.map((item) => item.toJson()).toList(),
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to save shop items: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<int> buyItem(String userId, int price) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/currency/$userId/remove'),
        headers: _getHeaders(),
        body: jsonEncode({
          'amount': price,
        }),
      );
      
      
      if (response.statusCode == 200) {
        return _parseJsonResponse<int>(response, (data) => data['currency'] as int);
      } else {
        throw Exception('Failed to buy item: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-session-id': authState.sessionId!,
    };
  }


  T _parseJsonResponse<T>(http.Response response, T Function(dynamic) parser) {
    final contentType = response.headers['content-type'] ?? '';
    if (!contentType.contains('application/json')) {
      throw Exception('Expected JSON but got $contentType');
    }
    
    try {
      final data = jsonDecode(response.body);
      return parser(data);
    } catch (e) {
      throw Exception('Invalid JSON response');
    }
  }
}
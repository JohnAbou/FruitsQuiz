import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/uri_provider.dart';

part 'api_service.g.dart';

@riverpod
Future<List<dynamic>> fetchData(Ref ref) async {
  final apiUrl = ref.watch(apiUrlProvider);
  final response = await http.get(Uri.parse('$apiUrl/quiz'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  } else {
    throw Exception('Failed to load data');
  }
}

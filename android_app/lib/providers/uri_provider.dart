import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'uri_provider.g.dart';

@riverpod
String apiUrl(ref) {
  final apiUrl = dotenv.env['API_URL'];
  if (apiUrl == null) {
    throw Exception('API_URL is not defined in the env file');
  }
  return apiUrl;
}


@riverpod
String socketsUrl(ref) {
  final apiUrl = dotenv.env['SOCKET_URL'];
  if (apiUrl == null) {
    throw Exception('API_URL is not defined in the env file');
  }
  return apiUrl;
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/uri_provider.dart';

class ImageService {
  final String apiUrl;

  ImageService({required this.apiUrl});

  String getQuestionImageUrl(String imageId) {
    return '$apiUrl/image/question/$imageId';
  }
}

final imageServiceProvider = Provider<ImageService>((ref) {
  final apiUrl = ref.watch(apiUrlProvider);
  return ImageService(apiUrl: apiUrl);
});

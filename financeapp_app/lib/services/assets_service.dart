import 'package:financeapp_app/services/http_service.dart';
import 'package:http/http.dart';

// TODO Add caching

class AssetsService {
  final HttpService _httpService = HttpService();

  Future<Response> getAllAssets() async {
    final response = await _httpService.getAsync('assets/getall');
    print('Assets: ${response.body}');
    return response;
  }

  Future<Response> getAllCategories() async {
    final response = await _httpService.getAsync('categories/getall');
    print('Categories: ${response.body}');
    return response;
  }
}

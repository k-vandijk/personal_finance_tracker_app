import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/services/http_service.dart';
import 'package:http/http.dart';

// TODO Add caching

class AssetsService {
  final HttpService _httpService = HttpService();

  Future<Response> getAllAssetsAsync() async {
    final response = await _httpService.getAsync('assets/getall');
    return response;
  }

  Future<Response> getAllCategoriesAsync() async {
    final response = await _httpService.getAsync('categories/getall');
    return response;
  }

  Future<Response> addAssetAsync(CreateAssetDTO asset) async {
    final response = await _httpService.postAsync('assets/create', body: asset);
    return response;
  }

  Future<Response> deleteAssetAsync(String id) async {
    final response = await _httpService.deleteAsync('assets/delete/$id');
    return response;
  }
}

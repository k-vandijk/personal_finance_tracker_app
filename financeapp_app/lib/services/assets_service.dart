import 'package:financeapp_app/services/http_service.dart';
import 'package:http/http.dart';

class AssetsService {
  final HttpService _httpService = HttpService();

  Future<Response> getAllAssets() async {
    final response = await _httpService.getAsync('assets/getall');
    return response;
  }
}

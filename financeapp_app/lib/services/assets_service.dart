// import 'dart:convert';
// import 'package:financeapp_app/dtos/asset_dto.dart';
// import 'package:financeapp_app/services/http_service.dart';

// class AssetsService {
//   final HttpService _httpService = HttpService();

//   Future<List<AssetDTO>> getAllAssets() async {
//     final response = await _httpService.get('assets/getall');
//     if (response.statusCode == 200) {
//       final List<dynamic> jsonList = jsonDecode(response.body);
//       return jsonList.map((json) => AssetDTO.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load assets');
//     }
//   }
// }

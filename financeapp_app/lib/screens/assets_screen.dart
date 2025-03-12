import 'dart:convert';
import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:financeapp_app/services/assets_service.dart';
import 'package:financeapp_app/widgets/assets_categories_list_widget.dart';
import 'package:financeapp_app/widgets/assets_graph_widget.dart';
import 'package:financeapp_app/widgets/assets_hero_widget.dart';
import 'package:financeapp_app/widgets/assets_list_widget.dart';
import 'package:flutter/material.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({Key? key}) : super(key: key);

  @override
  _AssetsScreenState createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  late Future<Map<String, dynamic>> _dataFuture;
  final AssetsService _assetsService = AssetsService();

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchAssetsAndCategories();
  }

  /// Haalt assets en categorieën op van de server en converteert ze naar DTO's.
  /// Als de response body leeg is, wordt een lege lijst gebruikt.
  Future<Map<String, dynamic>> _fetchAssetsAndCategories() async {
    final assetsResponse = await _assetsService.getAllAssets();
    final categoriesResponse = await _assetsService.getAllCategories();

    // Controleer of de response body leeg is, gebruik dan een lege lijst
    final assetsJson = assetsResponse.body.trim().isEmpty
        ? []
        : jsonDecode(assetsResponse.body) as List<dynamic>;
    final categoriesJson = categoriesResponse.body.trim().isEmpty
        ? []
        : jsonDecode(categoriesResponse.body) as List<dynamic>;

    final assets =
        assetsJson.map((json) => AssetDTO.fromJson(json)).toList();
    final categories =
        categoriesJson.map((json) => CategoryDTO.fromJson(json)).toList();

    return {'assets': assets, 'categories': categories};
  }

  double _getTotal(List<AssetDTO> assets) {
    return assets.fold(0.0, (sum, asset) => sum + asset.purchasePrice);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final assets = snapshot.data?['assets'] as List<AssetDTO>;
        final categories = snapshot.data?['categories'] as List<CategoryDTO>;
        final total = _getTotal(assets);

        return ListView(
          children: [
            AssetsHeroWidget(amount: total),
            const SizedBox(height: 16),
            const AssetsGraphWidget(),
            const SizedBox(height: 16),
            AssetsCategoriesListWidget(assets: assets, categories: categories),
            const SizedBox(height: 16),
            AssetsListWidget(assets: assets, categories: categories),
          ],
        );
      },
    );
  }
}

import 'dart:convert';
import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:financeapp_app/services/assets_service.dart';
import 'package:financeapp_app/widgets/add_asset_modal.dart';
import 'package:financeapp_app/widgets/assets_categories_list_widget.dart';
import 'package:financeapp_app/widgets/assets_graph_widget.dart';
import 'package:financeapp_app/widgets/assets_hero_widget.dart';
import 'package:financeapp_app/widgets/assets_list_widget.dart';
import 'package:flutter/material.dart';

// TODO BUG als je komma gebruikt bij double, krijg je een error
// TODO Optimistic update, toon de nieuwe asset direct in de lijst.
// TODO Edit asset
// TODO Filter assets by category
// TODO Create assets graph

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  _AssetsScreenState createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  late Future<Map<String, dynamic>> _dataFuture;
  final AssetsService _assetsService = AssetsService();

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchAssetsAndCategoriesAsync();
  }

  // Fetch methods
  Future<List<AssetDTO>> _fetchAssetsAsync() async {
    final assetsResponse = await _assetsService.getAllAssetsAsync();
    final assetsJson = assetsResponse.body.trim().isEmpty ? [] : jsonDecode(assetsResponse.body) as List<dynamic>;
    return assetsJson.map((json) => AssetDTO.fromJson(json)).toList();
  }

  Future<List<CategoryDTO>> _fetchCategoriesAsync() async {
    final categoriesResponse = await _assetsService.getAllCategoriesAsync();
    final categoriesJson = categoriesResponse.body.trim().isEmpty ? [] : jsonDecode(categoriesResponse.body) as List<dynamic>;
    return categoriesJson.map((json) => CategoryDTO.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> _fetchAssetsAndCategoriesAsync() async {
    final assets = await _fetchAssetsAsync();
    final categories = await _fetchCategoriesAsync();
    return {'assets': assets, 'categories': categories};
  }

  // Helper methods
  double _getTotal(List<AssetDTO> assets) {
    return assets.fold(0.0, (sum, asset) => sum + asset.purchasePrice);
  }

  // Feature methods
  Future<void> _addAssetAsync(CreateAssetDTO asset) async {
    final response = await _assetsService.addAssetAsync(asset);
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.body)));
      return;
    }

    setState(() {
      _dataFuture = _fetchAssetsAndCategoriesAsync();
    });
  }

  Future<void> _deleteAssetAsync(String id) async {
    final response = await _assetsService.deleteAssetAsync(id);
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.body)));
      return;
    }

    setState(() {
      _dataFuture = _fetchAssetsAndCategoriesAsync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {

        // Als de data nog aan het laden is, toon dan een loading indicator.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Als er een error is opgetreden, toon dan een error melding.
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final assets = snapshot.data?['assets'] as List<AssetDTO>;
        final categories = snapshot.data?['categories'] as List<CategoryDTO>;
        final total = _getTotal(assets);

        void openAddAssetModal() {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Zorgt ervoor dat de modal goed schaalt bij toetsenbord
            builder: (ctx) => AddAssetModal(ctx: ctx, categories: categories, onAddAsset: _addAssetAsync),
          );
        }

        return ListView(
          children: [
            AssetsHeroWidget(amount: total),
            const SizedBox(height: 16),
            const AssetsGraphWidget(),
            const SizedBox(height: 16),
            AssetsCategoriesListWidget(assets: assets, categories: categories),
            const SizedBox(height: 16),
            AssetsListWidget(
              assets: assets,
              categories: categories,
              onTapAdd: openAddAssetModal,
              onSwipeLeft: (id) => _deleteAssetAsync(id),
            ),
          ],
        );
      },
    );
  }
}

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

// TODO Edit asset
// TODO BUG als je komma gebruikt bij double, krijg je een error
// TODO Optimistic update, toon de nieuwe asset direct in de lijst.

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  _AssetsScreenState createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  late Future<Map<String, dynamic>> _dataFuture;
  final AssetsService _assetsService = AssetsService();

  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchAssetsAndCategoriesAsync();
  }

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

  double _getTotal(List<AssetDTO> assets) {
    return assets.fold(0.0, (sum, asset) => sum + asset.purchasePrice);
  }

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

  void _filterAssets(String categoryId) {
    setState(() {
      _selectedCategoryId = _selectedCategoryId == categoryId ? null : categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        // Show loading spinner while fetching data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Show error message if fetching data failed
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allAssets = snapshot.data?['assets'] as List<AssetDTO>;
        final allCategories = snapshot.data?['categories'] as List<CategoryDTO>;

        final filteredAssets = _selectedCategoryId == null
            ? allAssets
            : allAssets.where((asset) => asset.categoryId == _selectedCategoryId).toList();

        final filteredCategories = _selectedCategoryId == null
            ? allCategories
            : allCategories.where((category) => category.id == _selectedCategoryId).toList();

        final total = _getTotal(filteredAssets);

        void openAddAssetModal() {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => AddAssetModal(
              ctx: ctx,
              categories: allCategories,
              onAddAsset: _addAssetAsync,
            ),
          );
        }

        return ListView(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: AssetsHeroWidget(
                key: ValueKey(total),
                amount: total,
              ),
            ),
            const SizedBox(height: 16),
            AssetsGraphWidget(assets: filteredAssets),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: AssetsCategoriesListWidget(
                key: ValueKey(_selectedCategoryId ?? 'all'),
                assets: filteredAssets,
                categories: filteredCategories,
                onCategoryTapped: _filterAssets,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: AssetsListWidget(
                key: ValueKey(_selectedCategoryId ?? 'all'),
                assets: filteredAssets,
                categories: filteredCategories,
                onTapAdd: openAddAssetModal,
                onSwipeLeft: (id) => _deleteAssetAsync(id),
              ),
            ),
          ],
        );
      },
    );
  }
}

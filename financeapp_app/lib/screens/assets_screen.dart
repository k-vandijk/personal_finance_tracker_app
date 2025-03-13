import 'package:financeapp_app/config.dart';
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
// TODO Should-have Optimistic update, toon de nieuwe asset direct in de lijst.

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

  // Data fetching methods
  Future<List<AssetDTO>> _fetchAssetsAsync() async {
    try {
      return await _assetsService.getAllAssetsAsync();
    }

    catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
      print('Error fetching assets: $error');
      return [];
    }
  }

  Future<List<CategoryDTO>> _fetchCategoriesAsync() async {
    try {
      return await _assetsService.getAllCategoriesAsync();
    }

    catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
      print('Error fetching categories: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> _fetchAssetsAndCategoriesAsync() async {
    final assets = await _fetchAssetsAsync();
    final categories = await _fetchCategoriesAsync();
    return {'assets': assets, 'categories': categories};
  }

  // Business logic methods
  Future<void> _addAssetAsync(CreateAssetDTO asset) async {
    try {
      await _assetsService.addAssetAsync(asset);

      setState(() {
        _dataFuture = _fetchAssetsAndCategoriesAsync();
      });
    }

    catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
      print('Error adding asset: $error');
    }
  }

  Future<void> _deleteAssetAsync(String assetId) async {
    try {
      await _assetsService.deleteAssetAsync(assetId);

      setState(() {
        _dataFuture = _fetchAssetsAndCategoriesAsync();
      });
    }

    catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
      print('Error deleting asset: $error');
    }
  }

  Future<void> _editAssetAsync(String assetId, CreateAssetDTO asset) async {
    try {
      await _assetsService.editAssetAsync(assetId, asset);

      setState(() {
        _dataFuture = _fetchAssetsAndCategoriesAsync();
      });
    }

    catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
      print('Error editing asset: $error');
    }
  } 

  // Helpers methods
  double _getTotal(List<AssetDTO> assets) {
    return assets
        .where((asset) => asset.saleDate == null)
        .fold(0.0, (sum, asset) => sum + asset.purchasePrice);
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

        void openEditAssetModal(AssetDTO asset) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => AddAssetModal(
              ctx: ctx,
              categories: allCategories, 
              asset: asset,
              onAddAsset: (newAsset) => _editAssetAsync(asset.id!, newAsset),
            ),
          );
        }

        return ListView(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: animationMilliseconds),
              child: AssetsHeroWidget(
                key: ValueKey(total),
                amount: total,
              ),
            ),
            const SizedBox(height: 16),
            AssetsGraphWidget(assets: filteredAssets),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: animationMilliseconds),
              child: AssetsCategoriesListWidget(
                key: ValueKey(_selectedCategoryId ?? 'all'),
                assets: filteredAssets,
                categories: filteredCategories,
                onCategoryTapped: _filterAssets,
                selectedCategoryId: _selectedCategoryId,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: animationMilliseconds),
              child: AssetsListWidget(
                key: ValueKey(_selectedCategoryId ?? 'all'),
                assets: filteredAssets,
                categories: filteredCategories,
                onTapAdd: openAddAssetModal,
                onSwipeLeft: _deleteAssetAsync,
                onTapAsset: (asset) => openEditAssetModal(asset)
              ),
            ),
          ],
        );
      },
    );
  }
}

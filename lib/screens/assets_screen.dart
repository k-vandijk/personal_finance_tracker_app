import 'package:kubera/config.dart';
import 'package:kubera/dtos/asset_dto.dart';
import 'package:kubera/dtos/category_dto.dart';
import 'package:kubera/services/assets_service.dart';
import 'package:kubera/widgets/add_asset_modal.dart';
import 'package:kubera/widgets/assets_categories_list_widget.dart';
import 'package:kubera/widgets/assets_graph_widget.dart';
import 'package:kubera/widgets/assets_hero_widget.dart';
import 'package:kubera/widgets/assets_list_widget.dart';
import 'package:flutter/material.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  _AssetsScreenState createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final AssetsService _assetsService = AssetsService();
  List<AssetDTO> _assets = [];
  List<CategoryDTO> _categories = [];
  String? _selectedCategoryId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAssetsAndCategories();
  }

  Future<void> _fetchAssetsAndCategories() async {
    try {
      final assets = await _assetsService.getAllAssetsAsync();
      final categories = await _assetsService.getAllCategoriesAsync();
      setState(() {
        _assets = assets;
        _categories = categories;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong.')));
    }
  }

  // Optimistic add: update UI immediately, then call service.
  Future<void> _addAssetAsync(CreateAssetDTO asset) async {
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final newAsset = AssetDTO(
      id: tempId,
      categoryId: asset.categoryId,
      name: asset.name,
      description: asset.description,
      purchasePrice: asset.purchasePrice,
      purchaseDate: asset.purchaseDate,
      saleDate: null,
      salePrice: null,
      fictionalPrice: asset.fictionalPrice,
    );
    setState(() {
      _assets.add(newAsset);
    });
    try {
      await _assetsService.addAssetAsync(asset);
      // Refresh the list in the background.
      _assetsService.getAllAssetsAsync().then((updatedAssets) {
        setState(() {
          _assets = updatedAssets;
        });
      });
    } catch (error) {
      setState(() {
        _assets.removeWhere((a) => a.id == tempId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong.')));
    }
  }

  // Optimistic edit: update local asset immediately.
  Future<void> _editAssetAsync(String assetId, CreateAssetDTO asset) async {
    final index = _assets.indexWhere((a) => a.id == assetId);
    if (index == -1) return;
    final oldAsset = _assets[index];
    final updatedAsset = AssetDTO(
      id: assetId,
      categoryId: asset.categoryId,
      name: asset.name,
      description: asset.description,
      purchasePrice: asset.purchasePrice,
      purchaseDate: asset.purchaseDate,
      saleDate: oldAsset.saleDate,
      salePrice: oldAsset.salePrice,
      fictionalPrice: asset.fictionalPrice,
    );
    setState(() {
      _assets[index] = updatedAsset;
    });
    try {
      await _assetsService.editAssetAsync(assetId, asset);
      _assetsService.getAllAssetsAsync().then((updatedAssets) {
        setState(() {
          _assets = updatedAssets;
        });
      });
    } catch (error) {
      setState(() {
        _assets[index] = oldAsset;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong.')));
    }
  }

  // Optimistic delete: remove from UI immediately.
  Future<void> _deleteAssetAsync(String assetId) async {
    final index = _assets.indexWhere((a) => a.id == assetId);
    if (index == -1) return;
    final assetToDelete = _assets[index];
    setState(() {
      _assets.removeAt(index);
    });
    try {
      await _assetsService.deleteAssetAsync(assetId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Asset deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              try {
                await _assetsService.addAssetAsync(assetToDelete.toCreateAssetDTO());
                _assetsService.getAllAssetsAsync().then((updatedAssets) {
                  setState(() {
                    _assets = updatedAssets;
                  });
                });
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Undo failed.')));
              }
            },
          ),
        ),
      );
      _assetsService.getAllAssetsAsync().then((updatedAssets) {
        setState(() {
          _assets = updatedAssets;
        });
      });
    } catch (error) {
      setState(() {
        _assets.insert(index, assetToDelete);
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong.')));
    }
  }

  double _getTotal(List<AssetDTO> assets) {
    return assets
        .where((asset) => asset.saleDate == null)
        .fold(0.0, (sum, asset) => sum + asset.purchasePrice);
  }

  void _filterAssets(String categoryId) {
    setState(() {
      _selectedCategoryId =
          _selectedCategoryId == categoryId ? null : categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final filteredAssets = _selectedCategoryId == null
        ? _assets
        : _assets.where((asset) => asset.categoryId == _selectedCategoryId).toList();

    final filteredCategories = _selectedCategoryId == null
        ? _categories
        : _categories.where((category) => category.id == _selectedCategoryId).toList();
    
    final total = _getTotal(filteredAssets);

    void openAddAssetModal() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => AddAssetModal(
          ctx: ctx,
          categories: _categories,
          onAddAsset: _addAssetAsync,
        ),
      );
    }

    void openEditAssetModal(AssetDTO asset) {
      // Only allow editing if asset has a proper id (not a temporary one).
      if (asset.id?.startsWith('temp_') ?? true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Asset is still being saved. Please wait.')));
        return;
      }
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => AddAssetModal(
          ctx: ctx,
          categories: _categories,
          asset: asset,
          onAddAsset: (newAsset) => _editAssetAsync(asset.id!, newAsset),
        ),
      );
    }

    return ListView(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: animationMilliseconds),
          child: AssetsHeroWidget(key: ValueKey(total), amount: total),
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
            onTapAsset: openEditAssetModal,
          ),
        ),
      ],
    );
  }
}

import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:financeapp_app/widgets/assets_list_item_widget.dart';
import 'package:flutter/material.dart';

class AssetsListWidget extends StatelessWidget {
  const AssetsListWidget({
    super.key,
    required this.assets,
    required this.categories,
    required this.onTapAdd,
    required this.onSwipeLeft,
    required this.onTapAsset,
  });

  final List<AssetDTO> assets;
  final List<CategoryDTO> categories;
  List<AssetDTO> get sortedAssets => List<AssetDTO>.from(assets)..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));

  final void Function() onTapAdd;
  final void Function(String) onSwipeLeft;
  final void Function(AssetDTO) onTapAsset;

  /// Widgets
  Widget _buildAssetsLabelText(BuildContext context) {
    return const Text(
      'Assets',
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAddAssetButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTapAdd,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.tertiary.withAlpha(200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Verkleint de knop
      ),
      icon: Icon(
        Icons.add,
        size: 16,
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      label: Text(
        'Add',
        style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onTertiary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildAssetsLabelText(context),
              _buildAddAssetButton(context)
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true, // Laat de ListView alleen de benodigde hoogte innemen.
            physics: const NeverScrollableScrollPhysics(), // Schakel scrollen uit.
            itemCount: assets.length,
            itemBuilder: (ctx, index) {
              final asset = sortedAssets[index];
              final category = categories.firstWhere(
                (c) => c.id == asset.categoryId,
                orElse: () => CategoryDTO('0', 'Unknown'),
              );
              return AssetsListItemWidget(
                asset: asset,
                category: category,
                onSwipeLeft: (id) => onSwipeLeft(id),
                onTap: (asset) => onTapAsset(asset),
              );
            },
          ),
        ],
      ),
    );
  }
}

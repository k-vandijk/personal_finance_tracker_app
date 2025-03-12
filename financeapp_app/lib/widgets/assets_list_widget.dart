import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:financeapp_app/widgets/assets_list_item_widget.dart';
import 'package:flutter/material.dart';

class AssetsListWidget extends StatelessWidget {
  const AssetsListWidget({super.key, required this.assets, required this.categories, required this.onTapAdd});

  final List<AssetDTO> assets;
  final List<CategoryDTO> categories;
  List<AssetDTO> get sortedAssets => List<AssetDTO>.from(assets)..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));

  final void Function() onTapAdd;

  @override
  Widget build(BuildContext context) {
    final Color buttonBackgroundColor = Theme.of(context).colorScheme.secondaryContainer.withAlpha(120);
    final Color buttonTextColor = Theme.of(context).colorScheme.onSecondaryContainer;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Assets',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: onTapAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBackgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Verkleint de knop
                ),
                icon: Icon(
                  Icons.add,
                  size: 16,
                  color: buttonTextColor,
                ),
                label: Text(
                  'Add',
                  style: TextStyle(fontSize: 14, color: buttonTextColor),
                ),
              ),
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
              return AssetsListItemWidget(asset: asset, category: category);
            },
          ),
        ],
      ),
    );
  }
}

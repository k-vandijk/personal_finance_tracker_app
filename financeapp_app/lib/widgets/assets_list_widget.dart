import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:financeapp_app/widgets/assets_list_item_widget.dart';
import 'package:flutter/material.dart';

class AssetsListWidget extends StatelessWidget {
  const AssetsListWidget({super.key, required this.assets, required this.categories});

  final List<AssetDTO> assets;
  final List<CategoryDTO> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Assets', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true, // Expands the ListView to the height of its content.
            physics: const NeverScrollableScrollPhysics(), // Disables scrolling.

            itemCount: assets.length,
            itemBuilder: (ctx, index) {
              final asset = assets[index];
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

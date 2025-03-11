import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:financeapp_app/widgets/assets_list_item_widget.dart';
import 'package:flutter/material.dart';

class AssetsListWidget extends StatelessWidget {
  const AssetsListWidget({
    super.key,
    required this.assets,
    required this.categories,
  });

  final List<AssetDTO> assets;
  final List<CategoryDTO> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Ensures the ListView only takes up the needed height.
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling for this inner ListView.

      itemCount: assets.length,
      itemBuilder: (ctx, index) {
        final asset = assets[index];
        final category = categories.firstWhere((c) => c.id == asset.categoryId);
        return AssetsListItemWidget(asset: asset, category: category);
      },
    );
  }
}

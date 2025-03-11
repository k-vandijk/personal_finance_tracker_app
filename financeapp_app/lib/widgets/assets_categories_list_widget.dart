import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:financeapp_app/widgets/assets_categories_list_item_widget.dart';
import 'package:flutter/material.dart';

class CategoryTotal {
  final String name;
  final double total;

  CategoryTotal(this.name, this.total);
}

class AssetsCategoriesListWidget extends StatelessWidget {
  const AssetsCategoriesListWidget({
    super.key,
    required this.assets,
    required this.categories,
  });

  final List<AssetDTO> assets;
  final List<CategoryDTO> categories;

  // Compute the category totals on demand.
  List<CategoryTotal> get categoryTotals => _getCategoryTotals(assets, categories);

  // Compute the total purchase price for each category.
  List<CategoryTotal> _getCategoryTotals(List<AssetDTO> assets, List<CategoryDTO> categories) {
    final totals = <CategoryTotal>[];

    for (final category in categories) {
      final categoryAssets = assets.where((asset) => asset.categoryId == category.id);
      final total = categoryAssets.fold<double>(0.0, (sum, asset) => sum + asset.purchasePrice);
      totals.add(CategoryTotal(category.name, total));
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryTotals.length,
        itemBuilder: (context, index) {
          final categoryTotal = categoryTotals[index];
          return AssetsCategoriesListItemWidget(categoryTotal: categoryTotal);
        },
      ),
    );
  }
}

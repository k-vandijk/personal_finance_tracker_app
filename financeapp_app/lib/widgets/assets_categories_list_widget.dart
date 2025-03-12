import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:financeapp_app/widgets/assets_categories_list_item_widget.dart';
import 'package:flutter/material.dart';

class CategoryTotal {
  final String id;
  final String name;
  final double total;

  CategoryTotal(this.id, this.name, this.total);
}

class AssetsCategoriesListWidget extends StatelessWidget {
  const AssetsCategoriesListWidget({super.key, required this.assets, required this.categories, 
                                    required this.onCategoryTapped, required this.selectedCategoryId});

  final List<AssetDTO> assets;
  final List<CategoryDTO> categories;
  final String? selectedCategoryId;

  List<CategoryTotal> get categoryTotals => _getCategoryTotals(assets, categories);

  final void Function(String) onCategoryTapped;

  List<CategoryTotal> _getCategoryTotals(List<AssetDTO> assets, List<CategoryDTO> categories) {
    final totals = <CategoryTotal>[];

    for (final category in categories) {
      final categoryAssets = assets.where((asset) => asset.categoryId == category.id);
      final total = categoryAssets
          .where((asset) => asset.saleDate == null)
          .fold<double>(0.0, (sum, asset) => sum + asset.purchasePrice);
          
      totals.add(CategoryTotal(category.id, category.name, total));
    }
    
    // Return the list of category totals ordered by total amount
    return totals..sort((a, b) => b.total.compareTo(a.total));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('Categories', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryTotals.length,
              itemBuilder: (context, index) {
                final categoryTotal = categoryTotals[index];
                return AssetsCategoriesListItemWidget(
                  categoryTotal: categoryTotal, 
                  onCategoryTapped: (id) => onCategoryTapped(id),
                  selectedCategoryId: selectedCategoryId,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

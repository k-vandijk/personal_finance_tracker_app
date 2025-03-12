import 'package:financeapp_app/utils/formatter.dart';
import 'package:financeapp_app/widgets/assets_categories_list_widget.dart';
import 'package:flutter/material.dart';

class AssetsCategoriesListItemWidget extends StatelessWidget {
  const AssetsCategoriesListItemWidget({super.key, required this.categoryTotal, required this.onCategoryTapped});

  final CategoryTotal categoryTotal;

  final void Function(String) onCategoryTapped;

  Widget _buildCategoryNameLabel(BuildContext context) {
    return Text(
      categoryTotal.name,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }

  Widget _buildCategoryTotalLabel(BuildContext context) {
    return Text(
      formatCurrency(categoryTotal.total),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: InkWell(
        onTap: () => onCategoryTapped(categoryTotal.id),
        borderRadius: BorderRadius.circular(20),
        child: Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryNameLabel(context),
                const SizedBox(height: 8),
                _buildCategoryTotalLabel(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

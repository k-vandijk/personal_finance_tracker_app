import 'package:financeapp_app/utils/formatter.dart';
import 'package:financeapp_app/widgets/assets_categories_list_widget.dart';
import 'package:flutter/material.dart';

class AssetsCategoriesListItemWidget extends StatelessWidget {
  const AssetsCategoriesListItemWidget({
    super.key,
    required this.categoryTotal,
  });

  final CategoryTotal categoryTotal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Theme.of(context).colorScheme.inverseSurface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                categoryTotal.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(categoryTotal.total),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

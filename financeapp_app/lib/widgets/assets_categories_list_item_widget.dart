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
    final Color backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
    final Color textColor = Theme.of(context).colorScheme.onSecondaryContainer;

    return SizedBox(
      width: 120,
      child: Card(
        color: backgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                categoryTotal.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(categoryTotal.total),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

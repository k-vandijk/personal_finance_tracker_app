import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:financeapp_app/utils/formatter.dart';
import 'package:flutter/material.dart';

class AssetsListItemWidget extends StatelessWidget {
  const AssetsListItemWidget({
    super.key,
    required this.asset,
    required this.category,
  });

  final AssetDTO asset;
  final CategoryDTO category;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
    final Color textColor = Theme.of(context).colorScheme.onSecondaryContainer;

    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                asset.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            Text(
              formatCurrency(asset.purchasePrice),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.name,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            Text(
              formatDateTime(asset.purchaseDate),
              style: TextStyle(fontSize: 14, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}

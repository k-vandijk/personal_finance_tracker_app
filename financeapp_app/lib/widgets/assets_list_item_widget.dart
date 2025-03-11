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
    return Dismissible(
      key: ValueKey(asset.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {},
      child: Card(
        color: Theme.of(context).colorScheme.inverseSurface,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
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
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
              ),
              Text(
                formatCurrency(asset.purchasePrice),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              Text(
                formatDateTime(asset.purchaseDate),
                style: TextStyle(
                  fontSize: 14,
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

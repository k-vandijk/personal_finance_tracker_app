import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:financeapp_app/utils/formatter.dart';
import 'package:flutter/material.dart';

class AssetsListItemWidget extends StatelessWidget {
  const AssetsListItemWidget({super.key, required this.asset, required this.category, required this.onSwipeLeft});

  final AssetDTO asset;
  final CategoryDTO category;

  final void Function(String) onSwipeLeft;

  /// Widgets
  Widget _buildDismissibleContainer(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.error.withAlpha(150),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Icon(
        Icons.delete,
        color: Theme.of(context).colorScheme.onError,
        size: 24,
      ),
    );
  }

  Widget _buildAssetName(BuildContext context) {
    return Text(
      asset.name,
      overflow: TextOverflow.ellipsis, // Zorgt ervoor dat lange namen niet overlopen
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }
  
  Widget _buildAssetPrice(BuildContext context) {
    return Text(
      formatCurrency(asset.purchasePrice),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }

  Widget _buildAssetCategory(BuildContext context) {
    return Text(
      category.name,
      overflow: TextOverflow.ellipsis, // Zorgt ervoor dat lange categorieën niet overlopen
      style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSecondaryContainer),
    );
  }

  Widget _buildAssetPurchaseDate(BuildContext context) {
    return Text(
      formatDateTime(asset.purchaseDate),
      style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSecondaryContainer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(asset.id),
      direction: DismissDirection.endToStart,
      background: _buildDismissibleContainer(context),
      onDismissed: (_) => onSwipeLeft(asset.id!),
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(vertical: 4),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          title: Row(
            children: [
              Expanded(child: _buildAssetName(context)), // Voorkomt overflow bij lange namen
              _buildAssetPrice(context)
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(child: _buildAssetCategory(context)), // Voorkomt overflow bij lange categorieën
              _buildAssetPurchaseDate(context),
            ],
          ),
        ),
      ),
    );
  }
}

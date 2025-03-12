import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:financeapp_app/widgets/assets_categories_list_widget.dart';
import 'package:financeapp_app/widgets/assets_graph_widget.dart';
import 'package:financeapp_app/widgets/assets_hero_widget.dart';
import 'package:financeapp_app/widgets/assets_list_widget.dart';
import 'package:flutter/material.dart';

// TODO get the assets and categories from the database
// TODO add add asset button and modal
// TODO add delete asset functionality
// TODO add edit asset functionality
// TODO create graph widget

class AssetsScreen extends StatelessWidget {
  AssetsScreen({super.key});

  final List<AssetDTO> assets = [
    AssetDTO('1', '1', 'Fender American Vintage \'65 Stratocaster', DateTime.now(), 1250.00),
    AssetDTO('2', '1', 'Eastman E1D', DateTime.now(), 619.00),
    AssetDTO('3', '1', 'Fender American Vintage \'61 Stratocaster', DateTime.now(), 2198.00),
    AssetDTO('4', '1', 'Tokai LS48', DateTime.now(), 375.00),
    AssetDTO('5', '2', 'Boss Katana 50 MKII', DateTime.now(), 249.00),
    AssetDTO('6', '2', 'Marshall JCM 800 2203x', DateTime.now(), 1050.00),
    AssetDTO('7', '2', 'Marshall 1960A', DateTime.now(), 250.00),
    AssetDTO('8', '2', 'Marshall 1960A', DateTime.now(), 225.00),
    AssetDTO('9', '2', 'Marshall Silver Jubilee 2555x', DateTime.now(), 800.00),
  ];

  final List<CategoryDTO> categories = [
    CategoryDTO('1', 'Guitars'),
    CategoryDTO('2', 'Amplifiers'),
    CategoryDTO('3', 'Pedals'),
    CategoryDTO('4', 'Synthesizers'),
    CategoryDTO('5', 'Other'),
  ];

  double get _total => _getTotal(assets);

  double _getTotal(List<AssetDTO> assets) {
    return assets.fold<double>(0.0, (sum, asset) => sum + asset.purchasePrice);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AssetsHeroWidget(amount: _total),
        const SizedBox(height: 16),
        const AssetsGraphWidget(),
        const SizedBox(height: 16),
        AssetsCategoriesListWidget(assets: assets, categories: categories),
        const SizedBox(height: 16),
        AssetsListWidget(assets: assets, categories: categories),
      ],
    );
  }
}

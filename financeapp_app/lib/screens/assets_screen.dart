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
    AssetDTO('1', '1', 'Fender Stratocaster', DateTime.now(), 1250.00),
    AssetDTO('2', '1', 'Gibson Les Paul', DateTime.now(), 2200.00),
    AssetDTO('3', '1', 'Yamaha Acoustic', DateTime.now(), 800.00),
    AssetDTO('4', '2', 'Roland Keyboard', DateTime.now(), 1500.00),
    AssetDTO('5', '4', 'Pearl Drum Set', DateTime.now(), 999.99),
    AssetDTO('6', '3', 'Korg Synthesizer', DateTime.now(), 1800.00),
  ];

  final List<CategoryDTO> categories = [
    CategoryDTO('1', 'Guitars'),
    CategoryDTO('2', 'Keyboards'),
    CategoryDTO('3', 'Synthesizers'),
    CategoryDTO('4', 'Drums'),
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

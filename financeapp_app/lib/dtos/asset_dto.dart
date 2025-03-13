class AssetDTO {
  final String? id;
  final String categoryId;
  final String name;
  final String? description;
  final DateTime purchaseDate;
  final double purchasePrice;
  final DateTime? saleDate;
  final double? salePrice;
  final double? fictionalPrice;

  AssetDTO({
    this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.purchaseDate,
    required this.purchasePrice,
    this.saleDate,
    this.salePrice,
    this.fictionalPrice,
  });

  bool get isSold => saleDate != null;
}

class CreateAssetDTO {
  final String name;
  final String description;
  final double purchasePrice;
  final DateTime purchaseDate;
  final double fictionalPrice;
  final String categoryId;

  CreateAssetDTO({
    required this.name,
    required this.description,
    required this.purchasePrice,
    required this.purchaseDate,
    required this.fictionalPrice,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'purchasePrice': purchasePrice,
      'purchaseDate': purchaseDate.toIso8601String(),
      'fictionalPrice': fictionalPrice,
      'categoryId': categoryId,
    };
  }
}
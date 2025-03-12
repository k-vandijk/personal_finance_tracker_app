class AssetDTO {
  final String? id;
  final String categoryId;
  final String name;
  final String? description;
  final DateTime purchaseDate;
  final DateTime? saleDate;
  final double purchasePrice;
  final double? salePrice;
  final double? fictionalPrice;

  AssetDTO({
    this.id,
    required this.categoryId,
    required this.name,
    required this.purchaseDate,
    required this.purchasePrice,
    this.description,
    this.saleDate,
    this.salePrice,
    this.fictionalPrice,
  });

  bool get isSold => saleDate != null;

  /// Creates a new instance of AssetDTO from a JSON map.
  factory AssetDTO.fromJson(Map<String, dynamic> json) {
    return AssetDTO(
      id: json['id'],
      categoryId: json['categoryId'],
      name: json['name'],
      description: json['description'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      saleDate: json['saleDate'] != null ? DateTime.parse(json['saleDate']) : null,
      purchasePrice: json['purchasePrice'],
      salePrice: json['salePrice'],
      fictionalPrice: json['fictionalPrice'],
    );
  }
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
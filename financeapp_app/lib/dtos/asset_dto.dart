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

  CreateAssetDTO toCreateAssetDTO() {
    return CreateAssetDTO(
      name: name,
      description: description ?? '',
      purchasePrice: purchasePrice,
      purchaseDate: purchaseDate,
      fictionalPrice: fictionalPrice ?? 0.0,
      categoryId: categoryId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'purchaseDate': purchaseDate.toIso8601String(),
      'purchasePrice': purchasePrice,
      'saleDate': saleDate?.toIso8601String(),
      'salePrice': salePrice,
      'fictionalPrice': fictionalPrice,
    };
  }

  factory AssetDTO.fromJson(Map<String, dynamic> json) {
    return AssetDTO(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      salePrice: json['salePrice'] != null ? (json['salePrice'] as num).toDouble() : null,
      saleDate: json['saleDate'] != null ? DateTime.parse(json['saleDate'] as String) : null,
      fictionalPrice: json['fictionalPrice'] != null ? (json['fictionalPrice'] as num).toDouble() : null,
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
class AssetDTO {
  final String id;
  final String categoryId;
  final String name;
  final String? description;
  final DateTime purchaseDate;
  final DateTime? saleDate;
  final double purchasePrice;
  final double? salePrice;
  final double? fictionalPrice;

  AssetDTO(
    this.id,
    this.categoryId,
    this.name,
    this.purchaseDate,
    this.purchasePrice, {
    this.description,
    this.saleDate,
    this.salePrice,
    this.fictionalPrice,
  });

  /// Creates a new instance of AssetDTO from a JSON map.
  factory AssetDTO.fromJson(Map<String, dynamic> json) {
    return AssetDTO(
      json['id'] as String,
      json['categoryId'] as String,
      json['name'] as String,
      DateTime.parse(json['purchaseDate'] as String),
      (json['purchasePrice'] as num).toDouble(),
      description: json['description'] as String?,
      saleDate: json['saleDate'] == null
          ? null
          : DateTime.parse(json['saleDate'] as String),
      salePrice: json['salePrice'] == null
          ? null
          : (json['salePrice'] as num).toDouble(),
      fictionalPrice: json['fictionalPrice'] == null
          ? null
          : (json['fictionalPrice'] as num).toDouble(),
    );
  }

  /// Converts this AssetDTO instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'purchaseDate': purchaseDate.toIso8601String(),
      'saleDate': saleDate?.toIso8601String(),
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'fictionalPrice': fictionalPrice,
    };
  }
}

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

  AssetDTO(this.id, this.categoryId, this.name, this.purchaseDate, this.purchasePrice, {
    this.description,
    this.saleDate,
    this.salePrice,
    this.fictionalPrice,
  });
}
class CategoryDTO {
  final String id;
  final String name;

  CategoryDTO(this.id, this.name);

  factory CategoryDTO.fromJson(Map<String, dynamic> json) {
    return CategoryDTO(
      json['id'] as String,
      json['name'] as String,
    );
  }
}

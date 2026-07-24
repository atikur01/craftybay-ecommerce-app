class SliderModel {
  final String id;
  final String photoUrl;
  final String description;
  final String? product;
  final String? brand;
  final String? category;

  SliderModel({
    required this.id,
    required this.photoUrl,
    required this.description,
    required this.product,
    required this.brand,
    required this.category,
  });

  factory SliderModel.fromJson(Map<String, dynamic> jsonData) {
    return SliderModel(
      id: jsonData['_id'],
      photoUrl: jsonData['photo_url'],
      description: jsonData['description'],
      product: jsonData['product'],
      brand: jsonData['brand'],
      category: jsonData['category'],
    );
  }
}

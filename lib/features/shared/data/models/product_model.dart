// {
// "_id": "67c369ca5e8a445235de1b49",
// "title": "Motorola Edge 50 Fusion",
// "photos": [
// "https://owp.klarna.com/product/232x232/3146103049/Motorola-Edge-50-Fusion-8GB-RAM-256GB.jpg?ph=true"
// ],
// "current_price": 12000,
// }
class ProductModel {
  final String id;
  final String title;
  final List<String> photos;
  final int price;
  final double rating;
  final int quantity;

  ProductModel({
    required this.id,
    required this.title,
    required this.photos,
    required this.price,
    required this.rating,
    required this.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> jsonData) {
    return ProductModel(
      id: jsonData['_id'],
      title: jsonData['title'],
      photos: List.from(jsonData['photos']),
      price: jsonData['current_price'],
      quantity: jsonData['quantity'],
      rating: 4.0,
    );
  }
}

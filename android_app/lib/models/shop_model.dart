class ShopItem {
  final int id;
  final String name;
  final String image;
  final String type;
  final int price;
  int state;

  ShopItem({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.price,
    required this.state,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      type: json['type'],
      price: json['price'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'type': type,
      'price': price,
      'state': state,
    };
  }
}
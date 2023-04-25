class Item {
  final String id;
  final String name;
  final String description;
  final double price;
  final String cancellation;
  final String providerId;
  final String? ownerId;

  Item(
    this.id,
    this.name,
    this.description,
    this.price,
    this.cancellation,
    this.providerId,
    this.ownerId,
  );

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['itemId'],
      json['name'],
      json['description'],
      double.parse(json['price']),
      json['cancellation'],
      json['providerId'],
      json['ownerId'],
    );
  }

  Map toJson() => {
        'itemId': id,
        'name': name,
        'description': description,
        'price': price,
        'providerId': providerId,
        'ownerId': ownerId,
      };
}

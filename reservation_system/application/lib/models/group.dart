class Group {
  final String id;
  final String name;
  final String description;
  final int numberOfItems;
  final int numberOfReservations;
  final int overbooking;
  final String userId;

  Group(
    this.id,
    this.name,
    this.description,
    this.numberOfItems,
    this.numberOfReservations,
    this.overbooking,
    this.userId,
  );

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      json['groupId'],
      json['name'],
      json['description'],
      json['numberOfItems'],
      json['numberOfReservations'],
      int.parse(json['overbooking']),
      json['userId'],
    );
  }

  Map toJson() => {
        'groupId': id,
        'name': name,
        'description': description,
        'numberOfItems': numberOfItems,
        'numberOfReservations': numberOfReservations,
        'overbooking': overbooking,
        'userId': userId,
      };
}

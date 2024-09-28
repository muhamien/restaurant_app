class Favorite {
  late String? id;
  late String? name;
  late String? description;
  late String? pictureId;
  late String? city;
  late double? rating;

  Favorite({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'rating': rating,
    };
  }

  Favorite.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    description = map['description'];
    pictureId = map['pictureId'];
    city = map['city'];
    rating = map['rating'];
  }

}

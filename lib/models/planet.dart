class Planet {
  int? id;
  String name;
  double distance;
  double size;
  String? nickname;

  Planet({
    this.id,
    required this.name,
    required this.distance,
    required this.size,
    this.nickname,
  });

  // Convert a Planet object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'distance': distance,
      'size': size,
      'nickname': nickname,
    };
  }

  // Create a Planet object from a Map
  factory Planet.fromMap(Map<String, dynamic> map) {
    return Planet(
      id: map['id'],
      name: map['name'],
      distance: (map['distance'] as num?)?.toDouble() ?? 0.0,
      size: (map['size'] as num?)?.toDouble() ?? 0.0,
      nickname: map['nickname'],
    );
  }
}

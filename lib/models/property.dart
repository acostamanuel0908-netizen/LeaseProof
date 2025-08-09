class Property {
  int? id;
  String name;
  String address;

  Property({this.id, required this.name, required this.address});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'address': address,
      };

  static Property fromMap(Map<String, dynamic> m) => Property(
        id: m['id'] as int?,
        name: m['name'] as String,
        address: m['address'] as String,
      );
}

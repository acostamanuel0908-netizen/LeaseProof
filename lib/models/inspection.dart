class Inspection {
  int? id;
  int propertyId;
  String tenantName;
  String type; // 'move_in' or 'move_out'
  String createdAt;

  Inspection({
    this.id,
    required this.propertyId,
    required this.tenantName,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'propertyId': propertyId,
        'tenantName': tenantName,
        'type': type,
        'createdAt': createdAt,
      };

  static Inspection fromMap(Map<String, dynamic> m) => Inspection(
        id: m['id'] as int?,
        propertyId: m['propertyId'] as int,
        tenantName: m['tenantName'] as String,
        type: m['type'] as String,
        createdAt: m['createdAt'] as String,
      );
}

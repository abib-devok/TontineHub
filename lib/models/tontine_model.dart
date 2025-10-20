class TontineModel {
  final String id;
  final String name;
  final Map<String, dynamic>? rulesJson;
  final String ownerId;

  TontineModel({
    required this.id,
    required this.name,
    this.rulesJson,
    required this.ownerId,
  });

  factory TontineModel.fromJson(Map<String, dynamic> json) {
    return TontineModel(
      id: json['id'],
      name: json['name'],
      rulesJson: json['rules_json'],
      ownerId: json['owner_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rules_json': rulesJson,
      'owner_id': ownerId,
    };
  }
}

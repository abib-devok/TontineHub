class UserModel {
  final String id;
  final String phone;
  final Map<String, dynamic>? profileJson;
  final double confianceScore;

  UserModel({
    required this.id,
    required this.phone,
    this.profileJson,
    required this.confianceScore,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      profileJson: json['profile_json'],
      confianceScore: (json['confiance_score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'profile_json': profileJson,
      'confiance_score': confianceScore,
    };
  }
}

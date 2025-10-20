enum PaymentStatus { pending, success, failed }

class PaymentModel {
  final String id;
  final String tontineId;
  final String userId;
  final double amount;
  final PaymentStatus status;

  PaymentModel({
    required this.id,
    required this.tontineId,
    required this.userId,
    required this.amount,
    required this.status,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      tontineId: json['tontine_id'],
      userId: json['user_id'],
      amount: (json['amount'] as num).toDouble(),
      status: PaymentStatus.values
          .firstWhere((e) => e.toString() == 'PaymentStatus.${json['status']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tontine_id': tontineId,
      'user_id': userId,
      'amount': amount,
      'status': status.toString().split('.').last,
    };
  }
}

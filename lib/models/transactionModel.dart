class Transaction {
  final int id;
  final String senderId;
  final String recipientId;
  final double amount;
  final String type;
  final String? authMethod;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.amount,
    required this.type,
    this.authMethod,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        senderId: json['sender_id'],
        recipientId: json['recipient_id'],
        amount: json['amount'].toDouble(),
        type: json['type'],
        authMethod: json['auth_method'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender_id': senderId,
        'recipient_id': recipientId,
        'amount': amount,
        'type': type,
        'auth_method': authMethod,
        'created_at': createdAt.toIso8601String(),
      };
}
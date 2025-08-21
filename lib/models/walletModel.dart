class Wallet {
  final String userId;
  final double balance;
  final double loyaltyPoints;

  Wallet({
    required this.userId,
    required this.balance,
    required this.loyaltyPoints,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        userId: json['user_id'],
        balance: json['balance'].toDouble(),
        loyaltyPoints: json['loyalty_points'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'balance': balance,
        'loyalty_points': loyaltyPoints,
      };
}
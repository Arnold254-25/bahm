class CryptoCurrency {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCap;
  final int marketCapRank;
  final double totalVolume;

  CryptoCurrency({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.marketCapRank,
    required this.totalVolume,
  });

  factory CryptoCurrency.fromJson(Map<String, dynamic> json) {
    return CryptoCurrency(
      id: json['id'] ?? '',
      symbol: json['symbol']?.toUpperCase() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0.0).toDouble(),
      priceChange24h: (json['price_change_24h'] ?? 0.0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0.0).toDouble(),
      marketCap: (json['market_cap'] ?? 0.0).toDouble(),
      marketCapRank: (json['market_cap_rank'] ?? 0).toInt(),
      totalVolume: (json['total_volume'] ?? 0.0).toDouble(),
    );
  }

  bool get isPriceUp => priceChangePercentage24h > 0;
  bool get isPriceDown => priceChangePercentage24h < 0;

  CryptoCurrency copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    double? currentPrice,
    double? priceChange24h,
    double? priceChangePercentage24h,
    double? marketCap,
    int? marketCapRank,
    double? totalVolume,
  }) {
    return CryptoCurrency(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      totalVolume: totalVolume ?? this.totalVolume,
    );
  }
}

class CryptoTransaction {
  final String id;
  final String cryptoId;
  final String type; // 'buy' or 'sell'
  final double amount;
  final double price;
  final double total;
  final DateTime timestamp;
  final String status; // 'pending', 'completed', 'failed'

  CryptoTransaction({
    required this.id,
    required this.cryptoId,
    required this.type,
    required this.amount,
    required this.price,
    required this.total,
    required this.timestamp,
    required this.status,
  });

  factory CryptoTransaction.fromJson(Map<String, dynamic> json) {
    return CryptoTransaction(
      id: json['id'] ?? '',
      cryptoId: json['cryptoId'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      price: (json['price'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'pending',
    );
  }
}

class CryptoPortfolio {
  final Map<String, double> holdings; // cryptoId -> amount
  final double totalValue;
  final double totalInvestment;
  final double totalProfitLoss;
  final double totalProfitLossPercentage;

  CryptoPortfolio({
    required this.holdings,
    required this.totalValue,
    required this.totalInvestment,
    required this.totalProfitLoss,
    required this.totalProfitLossPercentage,
  });

  factory CryptoPortfolio.fromJson(Map<String, dynamic> json) {
    return CryptoPortfolio(
      holdings: Map<String, double>.from(json['holdings'] ?? {}),
      totalValue: (json['totalValue'] ?? 0.0).toDouble(),
      totalInvestment: (json['totalInvestment'] ?? 0.0).toDouble(),
      totalProfitLoss: (json['totalProfitLoss'] ?? 0.0).toDouble(),
      totalProfitLossPercentage: (json['totalProfitLossPercentage'] ?? 0.0).toDouble(),
    );
  }
}

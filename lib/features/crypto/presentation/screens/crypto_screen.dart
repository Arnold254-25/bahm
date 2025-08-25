import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bahm/providers/auth_providers.dart';
import 'package:bahm/models/crypto_model.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({Key? key}) : super(key: key);

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Market', 'Buy', 'Portfolio', 'Convert'];

  // Mock data for demonstration - replace with real API data
  final List<CryptoCurrency> _cryptoList = [
    CryptoCurrency(
      id: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      image: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
      currentPrice: 43250.0,
      priceChange24h: 1250.0,
      priceChangePercentage24h: 2.98,
      marketCap: 845000000000,
      marketCapRank: 1,
      totalVolume: 28500000000,
    ),
    CryptoCurrency(
      id: 'ethereum',
      symbol: 'ETH',
      name: 'Ehereum',
      image: 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
      currentPrice: 2580.0,
      priceChange24h: -120.0,
      priceChangePercentage24h: -4.45,
      marketCap: 310000000000,
      marketCapRank: 2,
      totalVolume: 18500000000,
    ),
    CryptoCurrency(
      id: 'binancecoin',
      symbol: 'BNB',
      name: 'Binance Coin',
      image: 'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png',
      currentPrice: 315.0,
      priceChange24h: 8.5,
      priceChangePercentage24h: 2.77,
      marketCap: 48000000000,
      marketCapRank: 4,
      totalVolume: 1200000000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Crypto',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              // Refresh crypto data
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _tabs.map((tab) {
                final index = _tabs.indexOf(tab);
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: _selectedTab == index ? const Color(0xFF1E88E5) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        color: _selectedTab == index ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Content based on selected tab
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildMarketTab(),
                _buildBuyTab(),
                _buildPortfolioTab(),
                _buildConvertTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Market Overview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Market Cap',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$1.65T',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '24h Volume',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$85.2B',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Top Cryptocurrencies
          Text(
            'Top Cryptocurrencies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _cryptoList.length,
            itemBuilder: (context, index) {
              final crypto = _cryptoList[index];
              return _buildCryptoListItem(crypto);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoListItem(CryptoCurrency crypto) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(crypto.image),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crypto.name,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  crypto.symbol,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          // Price and Change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${crypto.currentPrice.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '${crypto.priceChangePercentage24h.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: crypto.isPriceUp ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buy Crypto',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Quick Buy Buttons
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: _cryptoList.length,
            itemBuilder: (context, index) {
              final crypto = _cryptoList[index];
              return _buildQuickBuyButton(crypto);
            },
          ),

          const SizedBox(height: 24),
          Text(
            'All Cryptocurrencies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _cryptoList.length,
            itemBuilder: (context, index) {
              final crypto = _cryptoList[index];
              return _buildBuyCryptoListItem(crypto);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickBuyButton(CryptoCurrency crypto) {
    return GestureDetector(
      onTap: () {
        _showBuyDialog(crypto);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(crypto.image),
              radius: 16,
            ),
            const SizedBox(width: 8),
            Text(
              crypto.symbol,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyCryptoListItem(CryptoCurrency crypto) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(crypto.image),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crypto.name,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${crypto.currentPrice.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showBuyDialog(crypto);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wallet, size: 64, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'Portfolio Coming Soon',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your crypto investments and performance',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConvertTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.swap_horiz, size: 64, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'Convert Coming Soon',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Convert between different cryptocurrencies',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showBuyDialog(CryptoCurrency crypto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Buy ${crypto.name}',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Current Price: \$${crypto.currentPrice.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount to buy',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle buy logic
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Buy order placed for ${crypto.name}'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Buy'),
            ),
          ],
        );
      },
    );
  }
}

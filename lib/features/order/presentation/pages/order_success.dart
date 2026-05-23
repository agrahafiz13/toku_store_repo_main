import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:toku_store/core/routes/app_router.dart';

import 'package:toku_store/features/order/presentation/providers/order_provider.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final order = context.watch<OrderProvider>().lastOrder;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Success')),
        body: const Center(child: Text('Data order tidak ditemukan')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // ================= ICON =================
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.withOpacity(0.1),

                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),

              const SizedBox(height: 24),

              // ================= TITLE =================
              Text(
                'Checkout Berhasil 🎉',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Pesanan kamu berhasil dibuat',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 30),

              // ================= ORDER INFO =================
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    children: [
                      _buildRow('Order ID', '#${order.id}'),

                      const Divider(),

                      _buildRow(
                        'Total',
                        'Rp ${order.totalAmount.toStringAsFixed(0)}',
                      ),

                      const Divider(),

                      _buildRow('Status', order.status),

                      const Divider(),

                      _buildRow('Payment', order.paymentMethod),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ================= BACK TO HOME =================
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.dashboard,
                      (route) => false,
                    );
                  },

                  child: const Text('Kembali ke Dashboard'),
                ),
              ),

              const SizedBox(height: 12),

              // ================= SEE ORDERS =================
              SizedBox(
                width: double.infinity,

                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'My Orders akan dibuat di step berikutnya',
                        ),
                      ),
                    );
                  },

                  child: const Text('Lihat Pesanan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(title),

        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

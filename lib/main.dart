import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:toko_online/features/cart/providers/cartProvider.dart';

import 'package:toko_online/features/product/views/barang_view.dart';
import 'package:toko_online/features/admin/views/admin_dashboard_view.dart';
import 'package:toko_online/features/user/views/user_dashboard_view.dart';
import 'package:toko_online/features/user/views/profil_view.dart';
import 'package:toko_online/features/auth/views/login_view.dart';
import 'package:toko_online/features/order/views/pesan_view.dart';
import 'package:toko_online/features/auth/views/register_user_view.dart';
import 'package:toko_online/features/cart/views/cart_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/register': (context) => const RegisterUserView(),
          '/login': (context) => const LoginView(),
          '/user_dashboard': (context) => const UserDashboardView(),
          '/admin_dashboard': (context) => const AdminDashboardView(),
          '/barang': (context) => const BarangView(),
          '/cart': (context) => const CartView(),
          '/pesan': (context) => const PesanView(),
          '/profil': (context) => const ProfilView(),
        },
      ),
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:toko_online/views/dashboard.dart';
import 'package:toko_online/views/login_view.dart';
import 'package:toko_online/views/register_user_view.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/register',
      routes: {
      '/register': (context) => RegisterUserView(),
      '/login': (context) => LoginView(),
      '/dashboard': (context) => DashboardView(),
      },
    ),
  );
}

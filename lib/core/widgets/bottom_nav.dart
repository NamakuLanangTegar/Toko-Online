import 'package:flutter/material.dart';
import 'package:toko_online/features/auth/models/user_login.dart';

class BottomNav extends StatefulWidget {
  final int activePage;
  const BottomNav(this.activePage, {super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  UserLogin userLogin = UserLogin();
  String? role;

  @override
  void initState() {
    super.initState();
    getDataLogin();
  }

  getDataLogin() async {
    try {
      var user = await userLogin.getUserLogin();
      if (user.status != false) {
        setState(() {
          role = user.role;
        });
      } else {
        Navigator.popAndPushNamed(context, '/login');
      }
    } catch (_) {
      Navigator.popAndPushNamed(context, '/login');
    }
  }

  void getLink(int index) {
    if (role == "admin") {
      // Admin nav dikelola langsung di AdminDashboardView
      return;
    } else {
      // USER: 0=Home, 1=Product, 2=History, 3=Profil
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/user_dashboard');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/barang');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/pesan');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/profil');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) return const SizedBox();

    if (role == "admin") {
      // Admin tidak memakai BottomNav global ini — pakai yg di AdminDashboardView
      return const SizedBox();
    }

    // USER bottom nav
    int safeIndex = widget.activePage.clamp(0, 3);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF4C7DAF),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      currentIndex: safeIndex,
      onTap: (index) => getLink(index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.storefront),
          label: 'Product',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:toko_online/features/auth/models/user_login.dart';
import 'package:toko_online/core/widgets/bottom_nav.dart';

class UserDashboardView extends StatefulWidget {
  const UserDashboardView({super.key});

  @override
  State<UserDashboardView> createState() => _UserDashboardViewState();
}

class _UserDashboardViewState extends State<UserDashboardView> {
  UserLogin userLogin = UserLogin();
  String? nama;
  String? role;

  final Color primaryColor = const Color(0xFF4C7DAF);
  final Color softColor = const Color(0xFFEAF2FB);

  getUserLogin() async {
    var user = await userLogin.getUserLogin();
    if (user.status != false) {
      setState(() {
        nama = user.nama_user;
        role = user.role;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softColor,
      appBar: AppBar(
        title: const Text("Toko Online"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// GREETING BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selamat Datang,",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nama ?? "-",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/barang');
                    },
                    child: const Text("Mulai Belanja"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            /// QUICK MENU
            const Text(
              "Menu Utama",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMenu(Icons.storefront, "Katalog", '/barang'),
                _buildMenu(Icons.shopping_cart, "Keranjang", '/cart'), // We'll add route /cart
                _buildMenu(Icons.history, "Pesanan", '/pesan'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(0),
    );
  }

  Widget _buildMenu(IconData icon, String title, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5),
              ],
            ),
            child: Icon(icon, color: primaryColor, size: 30),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

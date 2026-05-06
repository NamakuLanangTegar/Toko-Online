import 'package:flutter/material.dart';
import 'package:toko_online/features/auth/models/user_login.dart';
import 'package:toko_online/features/product/views/barang_view.dart';
import 'package:toko_online/features/product/views/tambah_barang_view.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  UserLogin userLogin = UserLogin();
  String? nama;
  String? role;

  final Color adminPrimary = const Color(0xFF2C3E50);
  final Color adminAccent = const Color(0xFF34495E);
  final Color adminBackground = const Color(0xFFECF0F1);

  int _currentIndex = 0;
  
  // Key untuk memaksa BarangView refresh
  Key _barangKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    getUserLogin();
  }

  getUserLogin() async {
    var user = await userLogin.getUserLogin();
    if (user.status != false) {
      setState(() {
        nama = user.nama_user;
        role = user.role;
      });
    }
  }

  void _refreshProduk() {
    setState(() {
      _barangKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: adminBackground,
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: adminPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // TOMBOL REFRESH (Hanya muncul di Tab Produk)
          if (_currentIndex == 1)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Produk',
              onPressed: _refreshProduk,
            ),
          
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHome(),
          _buildProduk(),
          _buildProfil(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: adminPrimary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Admin Panel';
      case 1:
        return 'Kelola Produk';
      case 2:
        return 'Profil Admin';
      default:
        return 'Admin Panel';
    }
  }

  // =============== HOME ===============
  Widget _buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [adminPrimary, adminAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white24,
                  child: const Icon(Icons.admin_panel_settings, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Selamat Datang,", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      nama ?? "Admin",
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text("ADMIN", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Action Cards
          const Text("Menu Cepat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _quickCard(
                  icon: Icons.add_box,
                  label: "Tambah Produk",
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const TambahBarangView(title: "Tambah Barang"),
                    )).then((value) {
                      if (value == true) {
                        setState(() {
                          _currentIndex = 1; // Pindah ke tab produk
                          _refreshProduk(); // Refresh data
                        });
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _quickCard(
                  icon: Icons.list_alt,
                  label: "Daftar Produk",
                  color: adminPrimary,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickCard({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // =============== PRODUK (pakai BarangView tapi tanpa Scaffold) ===============
  Widget _buildProduk() {
    return BarangView(isEmbedded: true, key: _barangKey);
  }

  // =============== PROFIL ===============
  Widget _buildProfil() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: adminPrimary,
            child: const Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            nama ?? "Admin",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: adminPrimary),
          ),
          const SizedBox(height: 8),
          const Text("Role: ADMIN", style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.popAndPushNamed(context, '/login'),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

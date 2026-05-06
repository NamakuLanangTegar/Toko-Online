import 'package:flutter/material.dart';
import 'package:toko_online/features/auth/models/user_login.dart';
import 'package:toko_online/core/widgets/bottom_nav.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  UserLogin userLogin = UserLogin();
  String? nama;
  String? email;
  String? role;

  final Color primaryBlue = const Color(0xFF4C7DAF);
  final Color softBlue = const Color(0xFFEAF2FB);

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  loadUser() async {
    var user = await userLogin.getUserLogin();
    if (user.status != false) {
      setState(() {
        nama = user.nama_user;
        email = user.email;
        role = user.role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlue,
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// AVATAR
            CircleAvatar(
              radius: 60,
              backgroundColor: primaryBlue,
              child: Text(
                (nama?.isNotEmpty == true) ? nama![0].toUpperCase() : "U",
                style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            /// NAMA
            Text(
              nama ?? "-",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 6),

            /// EMAIL
            Text(
              email ?? "-",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            /// ROLE BADGE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                (role ?? "user").toUpperCase(),
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 40),

            /// INFO CARD
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _infoTile(Icons.person, "Nama Lengkap", nama ?? "-"),
                  const Divider(height: 1),
                  _infoTile(Icons.email, "Email", email ?? "-"),
                  const Divider(height: 1),
                  _infoTile(Icons.badge, "Role", (role ?? "user").toUpperCase()),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(3),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4C7DAF)),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }
}

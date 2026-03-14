import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../services/supabase_service.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';
import 'register_screen.dart';
import 'admin_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Semua';
  final _categories = ['Semua', 'Lingkungan', 'Kesehatan', 'Pendidikan', 'Sosial'];

  @override
  void initState() {
    super.initState();
    // Fetch data dari Supabase di halaman pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AppProvider>().fetchActivities();
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar?'),
        content: const Text('Kamu akan keluar dari akun ini.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await SupabaseService.logout();
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activities = provider.activities.where((a) {
      if (_selectedCategory == 'Semua') return true;
      return a.category == _selectedCategory;
    }).toList();

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF0F4FF);
    final appBarColor = isDark ? const Color(0xFF0A1929) : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(children: [
          Icon(Icons.volunteer_activism, color: Colors.white),
          SizedBox(width: 8),
          Text('GoVolunteer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ]),
        actions: [
          // Toggle Dark/Light Mode
          IconButton(
            icon: Icon(themeProvider.isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: themeProvider.isDark ? 'Mode Terang' : 'Mode Gelap',
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
          // Admin Panel
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Admin Panel',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen())),
          ),
          // Logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: _logout,
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)))
          : provider.errorMessage != null
              ? Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(provider.errorMessage!, textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.read<AppProvider>().fetchActivities(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1565C0), foregroundColor: Colors.white),
                    ),
                  ]),
                )
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Header Banner
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: appBarColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        'Halo, ${SupabaseService.currentUsername}!',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      const Text('Temukan kegiatan sosial\ndi Samarinda',
                          style: TextStyle(color: Colors.white, fontSize: 22,
                              fontWeight: FontWeight.bold, height: 1.3)),
                    ]),
                  ),
                  const SizedBox(height: 14),

                  // Category chips
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (context, i) {
                        final cat = _categories[i];
                        final isSelected = cat == _selectedCategory;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF1565C0) : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF1565C0) : Colors.grey.shade400,
                              ),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: const Color(0xFF1565C0).withValues(alpha: 0.3), blurRadius: 6)]
                                  : null,
                            ),
                            child: Text(cat,
                              style: TextStyle(
                                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.grey.shade700),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 13,
                              )),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('${activities.length} Kegiatan Tersedia',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  ),
                  const SizedBox(height: 6),

                  Expanded(
                    child: activities.isEmpty
                        ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text('Belum ada kegiatan',
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
                          ]))
                        : RefreshIndicator(
                            color: const Color(0xFF1565C0),
                            onRefresh: () => context.read<AppProvider>().fetchActivities(),
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                              itemCount: activities.length,
                              itemBuilder: (context, i) {
                                final act = activities[i];
                                return ActivityCard(
                                  activity: act,
                                  onTap: () => Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => ActivityDetailScreen(activity: act))),
                                  onRegister: () => Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => RegisterScreen(activity: act))),
                                );
                              },
                            ),
                          ),
                  ),
                ]),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/activity.dart';
import 'activity_form_screen.dart';
import 'participants_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final activities = provider.activities;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        title: const Text('Admin Panel'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah Kegiatan',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityFormScreen())),
          ),
        ],
      ),
      body: Column(children: [
        // Stats header
        Container(
          color: const Color(0xFF0D47A1),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Row(children: [
            _statCard('Kegiatan', activities.length.toString(), Icons.event),
            const SizedBox(width: 12),
            _statCard('Total Relawan',
                activities.fold(0, (s, a) => s + a.registeredCount).toString(), Icons.people),
          ]),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Row(children: [
            Text('Daftar Kegiatan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ]),
        ),
        Expanded(
          child: activities.isEmpty
              ? Center(child: Text('Belum ada kegiatan', style: TextStyle(color: Colors.grey.shade500)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemCount: activities.length,
                  itemBuilder: (context, i) => _AdminActivityTile(activity: activities[i]),
                ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityFormScreen())),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kegiatan'),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ]),
      ),
    );
  }
}

class _AdminActivityTile extends StatelessWidget {
  final Activity activity;
  const _AdminActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 4),
          Text(activity.organizer, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.people, size: 13, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text('${activity.registeredCount}/${activity.maxParticipants} relawan',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(activity.category,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF1565C0), fontWeight: FontWeight.bold)),
            ),
          ]),
        ]),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            icon: const Icon(Icons.group, color: Colors.blue, size: 20),
            tooltip: 'Lihat Peserta',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ParticipantsScreen(activity: activity))),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF1565C0), size: 20),
            tooltip: 'Edit',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ActivityFormScreen(activity: activity))),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            tooltip: 'Hapus',
            onPressed: () => _confirmDelete(context),
          ),
        ]),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Kegiatan?'),
        content: Text('Kegiatan "${activity.title}" akan dihapus beserta semua data peserta.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              context.read<AppProvider>().deleteActivity(activity.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kegiatan berhasil dihapus'), backgroundColor: Colors.red),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
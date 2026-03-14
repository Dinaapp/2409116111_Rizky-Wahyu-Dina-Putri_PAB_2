import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../models/participant.dart';
import '../providers/app_provider.dart';

class ParticipantsScreen extends StatefulWidget {
  final Activity activity;
  const ParticipantsScreen({super.key, required this.activity});
  @override
  State<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  late Future<List<Participant>> _future;

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  void _loadParticipants() {
    _future = context.read<AppProvider>().getParticipantsFor(widget.activity.id);
  }

  void _refresh() => setState(() => _loadParticipants());

  Future<void> _confirmRemove(BuildContext context, String participantId, String name) async {
    // Simpan provider sebelum async gap
    final provider = context.read<AppProvider>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Peserta?'),
        content: Text('Data "$name" akan dihapus dari kegiatan ini.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      if (!mounted) return;
      await provider.removeParticipant(participantId, widget.activity.id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        title: Text('Peserta: ${widget.activity.title}', maxLines: 1, overflow: TextOverflow.ellipsis),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh, tooltip: 'Refresh'),
        ],
      ),
      body: FutureBuilder<List<Participant>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)));
          }
          if (snap.hasError) {
            return Center(child: Text('Gagal memuat peserta: ${snap.error}',
                style: const TextStyle(color: Colors.red)));
          }
          final participants = snap.data ?? [];
          return Column(children: [
            Container(
              color: const Color(0xFF0D47A1),
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                '${participants.length} dari ${widget.activity.maxParticipants} slot terisi',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
            participants.isEmpty
                ? const Expanded(
                    child: Center(child: Text('Belum ada peserta terdaftar',
                        style: TextStyle(color: Colors.grey))))
                : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: participants.length,
                      itemBuilder: (context, i) {
                        final p = participants[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
                          ),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(p.email, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                Text(p.phone, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                Text(p.institution, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              ]),
                            ),
                            TextButton(
                              onPressed: () => _confirmRemove(context, p.id, p.name),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red, padding: EdgeInsets.zero,
                                minimumSize: const Size(48, 32),
                              ),
                              child: const Text('Hapus', style: TextStyle(fontSize: 12)),
                            ),
                          ]),
                        );
                      },
                    ),
                  ),
          ]);
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/app_provider.dart';

class ParticipantsScreen extends StatelessWidget {
  final Activity activity;
  const ParticipantsScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final participants = provider.getParticipantsFor(activity.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        title: Text('Peserta: ${activity.title}', maxLines: 1, overflow: TextOverflow.ellipsis),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF0D47A1),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              '${participants.length} dari ${activity.maxParticipants} slot terisi',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),

          participants.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      'Belum ada peserta terdaftar',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(p.email,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey.shade600)),
                                  Text(p.phone,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey.shade600)),
                                  Text(p.institution,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => _confirmRemove(context, p.id, p.name),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(48, 32),
                              ),
                              child: const Text('Hapus', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context, String participantId, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Peserta?'),
        content: Text('Data "$name" akan dihapus dari kegiatan ini.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              context.read<AppProvider>().removeParticipant(participantId, activity.id);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
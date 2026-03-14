import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/app_provider.dart';
import 'register_screen.dart';

class ActivityDetailScreen extends StatelessWidget {
  final Activity activity;
  const ActivityDetailScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final bgColor   = isDark ? const Color(0xFF121212) : const Color(0xFFF0F4FF);

    final provider = context.watch<AppProvider>();
    final current = provider.activities.firstWhere(
      (a) => a.id == activity.id,
      orElse: () => activity,
    );
    final slotPercent = current.maxParticipants > 0
        ? current.registeredCount / current.maxParticipants
        : 0.0;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // AppBar dengan gradient
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.volunteer_activism, size: 72, color: Colors.white24),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Title card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(current.category,
                            style: const TextStyle(color: Color(0xFF1565C0), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                      Text(current.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('oleh ${current.organizer}',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    ]),
                  ),
                  const SizedBox(height: 12),

                  // Info Grid
                  Row(children: [
                    Expanded(child: _infoTile(Icons.calendar_today, 'Tanggal', current.date, cardColor)),
                    const SizedBox(width: 12),
                    Expanded(child: _infoTile(Icons.access_time, 'Waktu', current.time, cardColor)),
                  ]),
                  const SizedBox(height: 12),
                  _infoTile(Icons.location_on, 'Lokasi', current.location, cardColor),
                  const SizedBox(height: 12),

                  // Kapasitas slot
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('Kapasitas Relawan', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${current.registeredCount}/${current.maxParticipants} terdaftar',
                          style: TextStyle(
                            color: slotPercent > 0.8 ? Colors.red : const Color(0xFF1565C0),
                            fontWeight: FontWeight.bold, fontSize: 13,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: slotPercent.toDouble(),
                          backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(
                            slotPercent > 0.8 ? Colors.red : const Color(0xFF1E88E5),
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        current.isFull ? 'Slot penuh! Pendaftaran ditutup.' : '${current.availableSlots} slot tersisa',
                        style: TextStyle(
                          fontSize: 12,
                          color: current.isFull ? Colors.red : Colors.blue.shade400,
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),

                  // Deskripsi & Benefit
                  _sectionCard('Deskripsi Kegiatan', current.description, cardColor, isDark),
                  const SizedBox(height: 12),
                  _sectionCard('Benefit Relawan', current.benefits, cardColor, isDark),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom button
      bottomNavigationBar: Container(
        color: bgColor,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: current.isFull
            ? ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Slot Penuh'),
              )
            : ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen(activity: current)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Daftar Sekarang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: const Color(0xFF1565C0), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ]),
        ),
      ]),
    );
  }

  Widget _sectionCard(String title, String content, Color cardColor, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        Text(content,
            style: TextStyle(
              height: 1.5,
              color: isDark ? Colors.grey.shade300 : const Color(0xFF444444),
            )),
      ]),
    );
  }
}
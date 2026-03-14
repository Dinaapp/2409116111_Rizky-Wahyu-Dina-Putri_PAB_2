import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;
  final VoidCallback? onRegister;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
    this.onRegister,
  });

  List<Color> get _gradientColors {
    switch (activity.category) {
      case 'Lingkungan': return [const Color(0xFF0D47A1), const Color(0xFF64B5F6)];
      case 'Kesehatan':  return [const Color(0xFFB71C1C), const Color(0xFFEF9A9A)];
      case 'Pendidikan': return [const Color(0xFF0D47A1), const Color(0xFF64B5F6)];
      case 'Sosial':     return [const Color(0xFF4A148C), const Color(0xFFCE93D8)];
      default:           return [const Color(0xFF263238), const Color(0xFF90A4AE)];
    }
  }

  IconData get _categoryIcon {
    switch (activity.category) {
      case 'Lingkungan': return Icons.park;
      case 'Kesehatan':  return Icons.favorite;
      case 'Pendidikan': return Icons.school;
      case 'Sosial':     return Icons.people;
      default:           return Icons.volunteer_activism;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.grey.shade300 : const Color(0xFF444444);
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final progressBg = isDark ? Colors.grey.shade800 : Colors.grey.shade100;

    final slotPercent = activity.maxParticipants > 0
        ? activity.registeredCount / activity.maxParticipants
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _gradientColors[0].withValues(alpha: isDark ? 0.25 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner gradient
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                height: 155,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _gradientColors,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(right: -24, top: -24,
                      child: Container(width: 130, height: 130,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08)))),
                    Positioned(right: 24, bottom: -36,
                      child: Container(width: 100, height: 100,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08)))),
                    Positioned(left: -16, bottom: -16,
                      child: Container(width: 80, height: 80,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.06)))),
                    // Category badge
                    Positioned(
                      top: 12, left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(_categoryIcon, size: 12, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(activity.category,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                    // PENUH badge
                    if (activity.isFull)
                      Positioned(
                        top: 12, right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('PENUH',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    Center(child: Icon(_categoryIcon, size: 68, color: Colors.white.withValues(alpha: 0.22))),
                    Positioned(
                      bottom: 12, left: 14, right: 14,
                      child: Text(activity.title,
                        style: const TextStyle(color: Colors.white, fontSize: 17,
                            fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 8, color: Colors.black38)]),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Body info
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.business_outlined, size: 14, color: subTextColor),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(activity.organizer,
                        style: TextStyle(color: subTextColor, fontSize: 12, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis),
                  ),
                ]),
                const SizedBox(height: 8),
                Text(activity.description,
                    style: TextStyle(fontSize: 13, color: textColor, height: 1.45),
                    maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Row(children: [
                  Icon(Icons.calendar_today_outlined, size: 13, color: _gradientColors[0]),
                  const SizedBox(width: 5),
                  Text(activity.date,
                      style: TextStyle(fontSize: 12, color: _gradientColors[0], fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  Icon(Icons.access_time_outlined, size: 13, color: subTextColor),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(activity.time,
                        style: TextStyle(fontSize: 12, color: subTextColor),
                        overflow: TextOverflow.ellipsis),
                  ),
                ]),
                const SizedBox(height: 5),
                Row(children: [
                  Icon(Icons.location_on_outlined, size: 13, color: subTextColor),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(activity.location,
                        style: TextStyle(fontSize: 12, color: subTextColor),
                        overflow: TextOverflow.ellipsis),
                  ),
                ]),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Slot Tersedia', style: TextStyle(fontSize: 11, color: subTextColor)),
                  Text(
                    '${activity.availableSlots} / ${activity.maxParticipants} relawan',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold,
                      color: slotPercent > 0.8 ? Colors.red : _gradientColors[0],
                    ),
                  ),
                ]),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: slotPercent.toDouble(),
                    backgroundColor: progressBg,
                    valueColor: AlwaysStoppedAnimation(
                      slotPercent > 0.8 ? Colors.red : _gradientColors[0],
                    ),
                    minHeight: 6,
                  ),
                ),
              ]),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _gradientColors[0]),
                    foregroundColor: _gradientColors[0],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: const Text('Detail', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: activity.isFull ? null : onRegister,
                  icon: Icon(activity.isFull ? Icons.lock_outline : Icons.how_to_reg, size: 16),
                  label: Text(
                    activity.isFull ? 'Slot Penuh' : 'Daftar Sekarang',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activity.isFull ? Colors.grey.shade400 : _gradientColors[0],
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                    disabledForegroundColor: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
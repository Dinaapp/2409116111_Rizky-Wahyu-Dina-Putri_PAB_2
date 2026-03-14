import 'package:flutter/foundation.dart';
import '../models/activity.dart';
import '../models/participant.dart';
import '../services/supabase_service.dart';

class AppProvider extends ChangeNotifier {
  List<Activity> _activities = [];
  bool isLoading = false;
  String? errorMessage;

  List<Activity> get activities => List.unmodifiable(_activities);

  // READ
  Future<void> fetchActivities() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _activities = await SupabaseService.fetchActivities();
    } catch (e) {
      errorMessage = 'Gagal memuat kegiatan: $e';
    }
    isLoading = false;
    notifyListeners();
  }

  // CREATE
  Future<void> addActivity(Activity activity) async {
    try {
      final inserted = await SupabaseService.insertActivity(activity);
      _activities.insert(0, inserted);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Gagal menambah kegiatan: $e';
      notifyListeners();
    }
  }

  // UPDATE
  Future<void> updateActivity(Activity updated) async {
    try {
      await SupabaseService.updateActivity(updated);
      final i = _activities.indexWhere((a) => a.id == updated.id);
      if (i != -1) { _activities[i] = updated; notifyListeners(); }
    } catch (e) {
      errorMessage = 'Gagal update kegiatan: $e';
      notifyListeners();
    }
  }

  // DELETE
  Future<void> deleteActivity(String id) async {
    try {
      await SupabaseService.deleteActivity(id);
      _activities.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Gagal hapus kegiatan: $e';
      notifyListeners();
    }
  }

  // REGISTER PARTICIPANT
  Future<bool> registerParticipant({
    required String activityId,
    required String name,
    required String phone,
    required String email,
    required String institution,
  }) async {
    final idx = _activities.indexWhere((a) => a.id == activityId);
    if (idx == -1 || _activities[idx].isFull) return false;

    try {
      final p = Participant(
        id: '', activityId: activityId, name: name,
        phone: phone, email: email, institution: institution,
        registeredAt: DateTime.now().toIso8601String(),
      );
      await SupabaseService.insertParticipant(p);
      final newCount = _activities[idx].registeredCount + 1;
      await SupabaseService.updateRegisteredCount(activityId, newCount);

      // update lokal
      final a = _activities[idx];
      _activities[idx] = Activity(
        id: a.id, title: a.title, organizer: a.organizer,
        description: a.description, location: a.location,
        date: a.date, time: a.time, benefits: a.benefits,
        maxParticipants: a.maxParticipants, registeredCount: newCount,
        category: a.category,
      );
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Gagal mendaftar: $e';
      notifyListeners();
      return false;
    }
  }

  // DELETE PARTICIPANT
  Future<void> removeParticipant(String participantId, String activityId) async {
    try {
      await SupabaseService.deleteParticipant(participantId);
      final idx = _activities.indexWhere((a) => a.id == activityId);
      if (idx != -1 && _activities[idx].registeredCount > 0) {
        final a = _activities[idx];
        final newCount = a.registeredCount - 1;
        await SupabaseService.updateRegisteredCount(activityId, newCount);
        _activities[idx] = Activity(
          id: a.id, title: a.title, organizer: a.organizer,
          description: a.description, location: a.location,
          date: a.date, time: a.time, benefits: a.benefits,
          maxParticipants: a.maxParticipants, registeredCount: newCount,
          category: a.category,
        );
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Gagal hapus peserta: $e';
      notifyListeners();
    }
  }

  // Fetch peserta langsung dari Supabase
  Future<List<Participant>> getParticipantsFor(String activityId) async {
    return await SupabaseService.fetchParticipants(activityId);
  }
}
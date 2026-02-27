import 'package:flutter/foundation.dart';
import '../models/activity.dart';
import '../models/participant.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class AppProvider extends ChangeNotifier {
  final List<Activity> _activities = [];
  final List<Participant> _participants = [];

  List<Activity> get activities => List.unmodifiable(_activities);

  List<Participant> getParticipantsFor(String activityId) =>
      _participants.where((p) => p.activityId == activityId).toList();

  // CREATE
  void addActivity(Activity activity) {
    _activities.add(activity);
    notifyListeners();
  }

  // UPDATE
  void updateActivity(Activity updated) {
    final index = _activities.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      _activities[index] = updated;
      notifyListeners();
    }
  }

  // DELETE
  void deleteActivity(String id) {
    _activities.removeWhere((a) => a.id == id);
    _participants.removeWhere((p) => p.activityId == id);
    notifyListeners();
  }

  // REGISTER
  bool registerParticipant({
    required String activityId,
    required String name,
    required String phone,
    required String email,
    required String institution,
  }) {
    final activityIndex = _activities.indexWhere((a) => a.id == activityId);
    if (activityIndex == -1) return false;

    final activity = _activities[activityIndex];
    if (activity.isFull) return false;

    // Simpan peserta
    final participant = Participant(
      id: _uuid.v4(),
      activityId: activityId,
      name: name,
      phone: phone,
      email: email,
      institution: institution,
      registeredAt: DateTime.now().toIso8601String(),
    );
    _participants.add(participant);

    // Rebuild activity dengan registeredCount baru
    _activities[activityIndex] = Activity(
      id: activity.id,
      title: activity.title,
      organizer: activity.organizer,
      description: activity.description,
      location: activity.location,
      date: activity.date,
      time: activity.time,
      benefits: activity.benefits,
      maxParticipants: activity.maxParticipants,
      registeredCount: activity.registeredCount + 1,
      category: activity.category,
    );

    notifyListeners();
    return true;
  }

  // DELETE Participant
  void removeParticipant(String participantId, String activityId) {
    _participants.removeWhere((p) => p.id == participantId);

    final activityIndex = _activities.indexWhere((a) => a.id == activityId);
    if (activityIndex != -1 && _activities[activityIndex].registeredCount > 0) {
      final activity = _activities[activityIndex];
      _activities[activityIndex] = Activity(
        id: activity.id,
        title: activity.title,
        organizer: activity.organizer,
        description: activity.description,
        location: activity.location,
        date: activity.date,
        time: activity.time,
        benefits: activity.benefits,
        maxParticipants: activity.maxParticipants,
        registeredCount: activity.registeredCount - 1,
        category: activity.category,
      );
    }

    notifyListeners();
  }

  Activity createNewActivity({
    required String title,
    required String organizer,
    required String description,
    required String location,
    required String date,
    required String time,
    required String benefits,
    required int maxParticipants,
    required String category,
  }) {
    return Activity(
      id: _uuid.v4(),
      title: title,
      organizer: organizer,
      description: description,
      location: location,
      date: date,
      time: time,
      benefits: benefits,
      maxParticipants: maxParticipants,
      category: category,
    );
  }
}
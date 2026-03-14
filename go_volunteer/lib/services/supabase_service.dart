import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activity.dart';
import '../models/participant.dart';

class SupabaseService {
  static final _db = Supabase.instance.client;

  // ACTIVITIES
  static Future<List<Activity>> fetchActivities() async {
    final res = await _db
        .from('activities')
        .select()
        .order('created_at', ascending: false);
    return (res as List).map((e) => Activity.fromMap(e)).toList();
  }

  static Future<Activity> insertActivity(Activity a) async {
    final res = await _db.from('activities').insert(a.toMap()).select().single();
    return Activity.fromMap(res);
  }

  static Future<void> updateActivity(Activity a) async {
    await _db.from('activities').update(a.toMap()).eq('id', a.id);
  }

  static Future<void> deleteActivity(String id) async {
    await _db.from('activities').delete().eq('id', id);
  }

  static Future<void> updateRegisteredCount(String activityId, int count) async {
    await _db.from('activities').update({'registered_count': count}).eq('id', activityId);
  }

  // PARTICIPANTS
  static Future<List<Participant>> fetchParticipants(String activityId) async {
    final res = await _db
        .from('participants')
        .select()
        .eq('activity_id', activityId)
        .order('registered_at', ascending: false);
    return (res as List).map((e) => Participant.fromMap(e)).toList();
  }

  static Future<Participant> insertParticipant(Participant p) async {
    final res = await _db.from('participants').insert(p.toMap()).select().single();
    return Participant.fromMap(res);
  }

  static Future<void> deleteParticipant(String id) async {
    await _db.from('participants').delete().eq('id', id);
  }

  // ── AUTH ─────────────────────────────────────────────
  static Future<AuthResponse> register(String email, String password, {String? username}) async {
    return await _db.auth.signUp(
      email: email,
      password: password,
      data: username != null ? {'username': username} : null,
    );
  }

  // Ambil username dari metadata user yang sedang login
  static String get currentUsername {
    final meta = _db.auth.currentUser?.userMetadata;
    return meta?['username'] as String? ??
        _db.auth.currentUser?.email?.split('@').first ??
        'Relawan';
  }

  static Future<AuthResponse> login(String email, String password) async {
    return await _db.auth.signInWithPassword(email: email, password: password);
  }

  static Future<void> logout() async => await _db.auth.signOut();

  static User? get currentUser => _db.auth.currentUser;
  static bool get isLoggedIn => _db.auth.currentUser != null;
}
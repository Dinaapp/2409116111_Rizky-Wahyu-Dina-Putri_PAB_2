class Participant {
  final String id, activityId, name, phone, email, institution, registeredAt;

  Participant({
    required this.id,
    required this.activityId,
    required this.name,
    required this.phone,
    required this.email,
    required this.institution,
    required this.registeredAt,
  });

  factory Participant.fromMap(Map<String, dynamic> m) => Participant(
        id:           m['id'] as String,
        activityId:   m['activity_id'] as String,
        name:         m['name'] as String,
        phone:        m['phone'] as String,
        email:        m['email'] as String,
        institution:  m['institution'] as String,
        registeredAt: m['registered_at'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'activity_id': activityId,
        'name':        name,
        'phone':       phone,
        'email':       email,
        'institution': institution,
      };
}
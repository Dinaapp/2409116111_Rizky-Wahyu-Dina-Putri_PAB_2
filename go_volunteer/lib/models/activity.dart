class Activity {
  final String id;
  String title, organizer, description, location, date, time, benefits, category;
  int maxParticipants, registeredCount;

  Activity({
    required this.id,
    required this.title,
    required this.organizer,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.benefits,
    required this.maxParticipants,
    this.registeredCount = 0,
    required this.category,
  });

  int get availableSlots => maxParticipants - registeredCount;
  bool get isFull => registeredCount >= maxParticipants;

  factory Activity.fromMap(Map<String, dynamic> m) => Activity(
        id:               m['id'] as String,
        title:            m['title'] as String,
        organizer:        m['organizer'] as String,
        description:      m['description'] as String,
        location:         m['location'] as String,
        date:             m['date'] as String,
        time:             m['time'] as String,
        benefits:         m['benefits'] as String,
        maxParticipants:  m['max_participants'] as int,
        registeredCount:  m['registered_count'] as int? ?? 0,
        category:         m['category'] as String,
      );

  Map<String, dynamic> toMap() => {
        'title':            title,
        'organizer':        organizer,
        'description':      description,
        'location':         location,
        'date':             date,
        'time':             time,
        'benefits':         benefits,
        'max_participants': maxParticipants,
        'registered_count': registeredCount,
        'category':         category,
      };
}
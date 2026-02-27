class Activity {
  final String id;
  String title;
  String organizer;
  String description;
  String location;
  String date;
  String time;
  String benefits;
  int maxParticipants;
  int registeredCount;
  String category;

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'organizer': organizer,
      'description': description,
      'location': location,
      'date': date,
      'time': time,
      'benefits': benefits,
      'maxParticipants': maxParticipants,
      'registeredCount': registeredCount,
      'category': category,
    };
  }
}
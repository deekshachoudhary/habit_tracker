class Habit {
  final String id;
  final String title;
  final String iconPath; // optional
  final String color; // HEX color string like "#FF5722"
  int currentStreak;
  int bestStreak;
  DateTime? lastCompletedDate;

  Habit({
    required this.id,
    required this.title,
    this.iconPath = '',
    this.color = '#2196F3',
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastCompletedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconPath': iconPath,
      'color': color,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      iconPath: map['iconPath'],
      color: map['color'],
      currentStreak: map['currentStreak'],
      bestStreak: map['bestStreak'],
      lastCompletedDate: map['lastCompletedDate'] != null
          ? DateTime.parse(map['lastCompletedDate'])
          : null,
    );
  }
}

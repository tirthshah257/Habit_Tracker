class Habit {
  final String id;
  final String name;
  final String description;
  final List<DateTime> completedDates;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    List<DateTime>? completedDates,
  }) : completedDates = completedDates ?? [];

  // Convert a Habit into a Map. The keys must correspond to the names of the JSON attributes.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'completedDates': completedDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  // Extract a Habit object from a Map.
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      completedDates: (json['completedDates'] as List<dynamic>)
          .map((dateStr) => DateTime.parse(dateStr))
          .toList(),
    );
  }

  // Check if completed on a specific day
  bool isCompletedOn(DateTime date) {
    return completedDates.any((completedDate) =>
        completedDate.year == date.year &&
        completedDate.month == date.month &&
        completedDate.day == date.day);
  }
}

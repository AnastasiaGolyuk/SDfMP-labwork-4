class Event {
  final int id;
  final String title;
  final String date;

  Event(
      {required this.id,
        required this.title, required this.date});

  factory Event.fromJson(Map<String, dynamic> json) => Event(
      id: json["id"],
      title: json["title"],
      date: json["date"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "date": date
  };
}

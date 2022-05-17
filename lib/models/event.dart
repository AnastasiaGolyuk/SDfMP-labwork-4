class Event {
  final int id;
  final int idUser;
  final String title;
  final String date;

  Event(
      {required this.idUser,required this.id,
        required this.title, required this.date});

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    idUser: json["idUser"],
      id: json["id"],
      title: json["title"],
      date: json["date"]
  );

  Map<String, dynamic> toJson() => {
    "idUser": idUser,
    "id": id,
    "title": title,
    "date": date
  };
}

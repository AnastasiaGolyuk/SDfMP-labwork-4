class Event {
  final int id;
  final int idUser;
  final String title;
  final String start;
  final String end;
  final String repeat;
  final int isAllDay;

  Event(
      {required this.idUser,required this.id,
        required this.title, required this.start, required this.end, required this.repeat, required this.isAllDay});

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    idUser: json["idUser"],
      id: json["id"],
      title: json["title"],
      start: json["start"],
    end: json["end"],
    repeat: json["repeat"],
    isAllDay: json["isAllDay"]
  );

  Map<String, dynamic> toJson() => {
    "idUser": idUser,
    "id": id,
    "title": title,
    "start": start,
    "end": end,
    "repeat": repeat,
    "isAllDay": isAllDay
  };

  @override
  String toString() {
    // TODO: implement toString
    return title+" "+idUser.toString();
  }
}

class Note {
  final int id;
  final int idUser;
  final String title;
  final String description;

  Note(
      {required this.id,
        required this.idUser,
        required this.title, required this.description});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
      id: json["id"],
      idUser: json["idUser"],
      title: json["title"],
      description: json["description"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idUser": idUser,
    "title": title,
    "description": description
  };
}

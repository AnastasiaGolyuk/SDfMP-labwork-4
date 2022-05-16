import 'dart:convert';

import 'dart:typed_data';

class UploadedImage {
  final int id;
  final int idNote;
  final Uint8List bytes;

  UploadedImage(
      {required this.id,
        required this.idNote,
        required this.bytes});

  factory UploadedImage.fromJson(Map<String, dynamic> json) => UploadedImage(
    id: json["id"],
    idNote: json["idNote"],
    bytes: json["bytes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idNote": idNote,
    "bytes": bytes,
  };
}

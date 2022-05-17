import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/db/db_helper.dart';
import 'package:planner/models/note.dart';
import 'package:planner/models/uploaded_image.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  late Uint8List imgBytes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    UploadedImage? img = await DatabaseHelper.instance.getImage(widget.noteId);
    imgBytes = img?.bytes ?? Uint8List(1);
    note = await DatabaseHelper.instance.getNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Consts.textColor),
          actions: [deleteButton()],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Consts.textColor,
              ))
            : Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  children: [
                    if (imgBytes.length > 1)
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        height: 180,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(imgBytes),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    SizedBox(height: 10),
                    Text(
                      note.title,
                      style: TextStyle(
                        color: Consts.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.description,
                      style: TextStyle(color: Consts.textColor, fontSize: 15),
                    )
                  ],
                ),
              ),
      );

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await DatabaseHelper.instance.deleteNote(widget.noteId);
          await DatabaseHelper.instance.deleteImage(widget.noteId);
          Navigator.of(context).pop();
        },
      );
}

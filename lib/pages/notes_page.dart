import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/db/db_helper.dart';
import 'package:planner/models/note.dart';
import 'package:planner/models/uploaded_image.dart';
import 'package:planner/models/user.dart';

import 'package:planner/pages/detail_note_page.dart';
import 'package:planner/widgets/note_card_widget.dart';

import 'add_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;
  late List<UploadedImage> images;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await DatabaseHelper.instance.getNotes(widget.user.id);
    images = await DatabaseHelper.instance.getImages();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    //refreshNotes();
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
      child: isLoading
          ? CircularProgressIndicator(
        color: Consts.textColor,
      )
          : notes.isEmpty
          ? Text(
        'No Notes',
        style: TextStyle(color: Consts.textColor, fontSize: 25),
      )
          : buildNotes(),
    ), floatingActionButton: FloatingActionButton(
      backgroundColor: Consts.btnColor,
      child: Icon(Icons.add),
      onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddNotePage(user: widget.user)),
          );
          refreshNotes();
      },
    ));
  }

  Widget buildNotes() =>
      StaggeredGridView.countBuilder(

        padding: EdgeInsets.all(5),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];
          final imgs = images
              .where((element) => element.idNote == note.id);
          final bytes = imgs.isEmpty?Uint8List(1):imgs.first.bytes;
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id),
              ));
              refreshNotes();
            },
            child: NoteCardWidget(
              note: note,
              index: index,
              imgBytes: bytes,
            ),
          );
        },
      );
}

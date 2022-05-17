import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/db/db_helper.dart';
import 'package:planner/models/note.dart';
import 'package:planner/models/uploaded_image.dart';
import 'package:planner/models/user.dart';
import 'package:planner/widgets/note_form_widget.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  String title = "";
  String description = "";

  Uint8List imgBytes = Uint8List(1);
  late File imageUpload;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        imageUpload = File(image.path);
        imgBytes = imageUpload.readAsBytesSync();
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Create Note",
          style: TextStyle(fontSize: 18, color: Consts.textColor),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Consts.textColor),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        actions: [buildButton()],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: NoteFormWidget(
                title: title,
                description: description,
                onChangedTitle: (title) => setState(() => this.title = title),
                onChangedDescription: (description) =>
                    setState(() => this.description = description),
              ),
            )),
        Container(
          alignment: Alignment.center,
          child: IconButton(
              onPressed: () {pickImage();}, icon: Image.asset("assets/icons/image.png")),
        ),
        if (imgBytes.length != 1)
          Container(
            padding: EdgeInsets.all(5),
            width: 300,
            child: Image.memory(imgBytes),
          )
      ]));

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white, shadowColor: Colors.transparent),
        onPressed: addOrUpdateNote,
        child: Text(
          'Save',
          style: TextStyle(
              fontSize: 18,
              color: isFormValid ? Consts.textColor : Colors.grey.shade700),
        ),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      await addNote();
      Navigator.of(context).pop();
    }
  }

  Future addNote() async {
    int idNote = await DatabaseHelper.instance.getNotesCount() + 1;
    final note = Note(
      title: title,
      description: description,
      idUser: widget.user.id,
      id: idNote,
    );
    await DatabaseHelper.instance.addNote(note);

    if(imgBytes.length>1) {
      int idImage = await DatabaseHelper.instance.getImagesCount() + 1;
      final img = UploadedImage(id: idImage, idNote: idNote, bytes: imgBytes);
      await DatabaseHelper.instance.addImage(img);
    }
  }
}

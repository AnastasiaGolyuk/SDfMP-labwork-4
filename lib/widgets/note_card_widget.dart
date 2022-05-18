import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/models/note.dart';

class NoteCardWidget extends StatelessWidget {
  NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
    required this.imgBytes,
  }) : super(key: key);

  final Note note;
  final int index;
  final Uint8List imgBytes;

  @override
  Widget build(BuildContext context) {
    final minHeight = getMinHeight();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Consts.bgColor,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        //padding: EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imgBytes.length > 1)
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  image: DecorationImage(
                    image: MemoryImage(imgBytes),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            Container(padding: EdgeInsets.only(top: 10, left: 5, right: 5), child:Text(
              note.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Consts.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),),
            Container( padding: EdgeInsets.all(5),child: Text(
              note.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),)
          ],
        ),
      ),
    );
  }

  double getMinHeight() {
    if (imgBytes.length<=1) {
      return 120;
    } else {
      return 180;
    }

  }
}

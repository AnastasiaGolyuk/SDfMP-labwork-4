import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planner/consts/consts.dart';

class NoteFormWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    Key? key,
    this.title = '',
    this.description = '',
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Container(
      width: Consts.getWidth(context)-30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Consts.bgColor),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitle(),
          buildDescription(),
          SizedBox(height: 10),
        ],
      ),
    ),
  );

  Widget buildTitle() => TextFormField(
    maxLines: 1,
    initialValue: title,
    style: TextStyle(
      color: Colors.black,
      fontSize: 18,
    ),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'Header',
      hintStyle: TextStyle(color: Colors.grey.shade500),
    ),
    validator: (title) =>
    title != null && title.isEmpty ? 'The title cannot be empty' : null,
    onChanged: onChangedTitle,
  );

  Widget buildDescription() => TextFormField(
    maxLines: 10,
    initialValue: description,
    style: TextStyle(color: Colors.black, fontSize: 16),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'Start typing',
      hintStyle: TextStyle(color: Colors.grey.shade500),
    ),
    validator: (title) => title != null && title.isEmpty
        ? 'The description cannot be empty'
        : null,
    onChanged: onChangedDescription,
  );
}
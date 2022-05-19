import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/db/db_helper.dart';
import 'package:planner/models/event.dart';
import 'package:planner/models/user.dart';
import 'package:planner/pages/calendar.dart';
import 'package:planner/pages/main_page.dart';

class AddChangeEventPage extends StatefulWidget {
  const AddChangeEventPage({
    Key? key,
    required this.user,
    this.event,
  }) : super(key: key);

  final User user;
  final Event? event;

  @override
  _AddChangeEventPageState createState() => _AddChangeEventPageState();
}

class _AddChangeEventPageState extends State<AddChangeEventPage> {
  String title = "";
  bool isAllDay = true;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  String repeat = "";
  List<Text> list = [
    Text('Once'),
    Text('Daily'),
    Text('On weekdays'),
    Text('Annually')
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      repeat = list[0].data!;
      if (widget.event != null) {
        title = widget.event!.title;
        start = DateTime.parse(widget.event!.start);
        end = DateTime.parse(widget.event!.end);
        repeat = widget.event!.repeat;
        isAllDay = widget.event!.isAllDay == 0 ? false : true;
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.event == null ? "Create Event" : "Edit Event",
          style: TextStyle(fontSize: 18, color: Consts.textColor),
        ),
        leading: IconButton(onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => MainPage(
              user: widget.user, index: 0,
            ))); }, icon: Icon(CupertinoIcons.back),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Consts.textColor),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        actions: [
          buildButton(),
          if (widget.event != null)
              IconButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteEvent(widget.event!.id);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => MainPage(
                          user: widget.user, index: 0,
                        )));
                  },
                  icon: Icon(
                    CupertinoIcons.delete,
                    color: Colors.red[300],
                  ))
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(alignment: Alignment.center, child: buildForm()),
      ]));

  Widget buildForm() {
    return SingleChildScrollView(
      child: Container(
        width: Consts.getWidth(context) - 20,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(),
            SizedBox(height: 25),
            buildIsAllDay(),
            SizedBox(height: 2),
            buildStartDate(),
            SizedBox(height: 2),
            buildEndDate(),
            SizedBox(height: 2),
            buildRepeat(),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() => Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Consts.bgColor),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
              maxLines: 1,
              initialValue: title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Event Title',
                hintStyle: TextStyle(color: Colors.grey.shade500),
              ),
              validator: (title) => title != null && title.isEmpty
                  ? 'The title cannot be empty'
                  : null,
              onChanged: (title) => setState(
                    () => this.title = title,
                  ))));

  Widget buildIsAllDay() => Container(
      height: 42,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Consts.bgColor),
      child: InkWell(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "All day",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              )),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Switch.adaptive(
                  activeColor: Consts.textColor,
                  value: isAllDay,
                  onChanged: (value) {
                    setState(() {
                      isAllDay = !isAllDay;
                    });
                  }))
        ],
      )));

  Widget buildStartDate() => Container(
      height: 42,
      decoration: BoxDecoration(color: Consts.bgColor),
      child: InkWell(
          onTap: () {
            BottomPicker.dateTime(
                    title: "Start",
                    titleStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Consts.textColor),
                    onSubmit: (value) {
                      setState(() {
                        start = value;
                      });
                    },
                    iconColor: Colors.black,
                    minDateTime: DateTime(1990, 7, 1),
                    maxDateTime: DateTime(2050, 8, 2),
                    gradientColors: [Consts.btnColor, Consts.btnColor])
                .show(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Start",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "${DateFormat.yMMMd().format(start)} ${DateFormat.jm().format(start)} ❯",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ))
            ],
          )));

  Widget buildEndDate() => Container(
      height: 42,
      decoration: BoxDecoration(color: Consts.bgColor),
      child: InkWell(
          onTap: () {
            BottomPicker.dateTime(
                    title: "Ending",
                    titleStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Consts.textColor),
                    onSubmit: (value) {
                      setState(() {
                        end = value;
                      });
                    },
                    iconColor: Colors.black,
                    minDateTime: start,
                    maxDateTime: DateTime(2050, 8, 2),
                    gradientColors: [Consts.btnColor, Consts.btnColor])
                .show(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Ending",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "${DateFormat.yMMMd().format(end)} ${DateFormat.jm().format(end)} ❯",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ))
            ],
          )));

  Widget buildRepeat() => Container(
      height: 42,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          color: Consts.bgColor),
      child: InkWell(
          onTap: () {
            BottomPicker(
                    items: list,
                    pickerTextStyle:
                        TextStyle(fontSize: 18, color: Colors.black),
                    onSubmit: (index) {
                      setState(() {
                        repeat = list[index].data!;
                      });
                    },
                    gradientColors: [Consts.btnColor, Consts.btnColor],
                    title: "Repeat",
                    titleStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                .show(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Repeat",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    repeat,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  )),
            ],
          )));

  Widget buildButton() {
    final isFormValid = title.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white, shadowColor: Colors.transparent),
        onPressed: addOrUpdateEvent,
        child: Text(
          'Save',
          style: TextStyle(
              fontSize: 18,
              color: isFormValid ? Consts.textColor : Colors.grey.shade700),
        ),
      ),
    );
  }

  void addOrUpdateEvent() async {
    await addEvent();
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => MainPage(
          user: widget.user, index: 0,
        )));
  }

  Future addEvent() async {
    var id = 0;
    if (widget.event == null) {
      id = await DatabaseHelper.instance.getEventsCount() + 1;
    } else {
      id = widget.event!.id;
    }
    var event = Event(
        idUser: widget.user.id,
        id: id,
        title: title,
        start: start.toString(),
        end: end.toString(),
        repeat: repeat,
        isAllDay: isAllDay == true ? 1 : 0);
    if (widget.event == null) {
      await DatabaseHelper.instance.addEvent(event);
    } else {
      await DatabaseHelper.instance.updateEvent(event);
    }
  }
}

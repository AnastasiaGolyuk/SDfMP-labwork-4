import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/db/db_helper.dart';
import 'package:planner/models/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import 'add_change_event_page.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<Event>> selectedEvents = Map();
  List<Event> events = List.empty(growable: true);
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    selectedEvents = {};
    initEvents();
    super.initState();
  }

  Future<List<Event>> fetchEvents() async {
    var evnts = await DatabaseHelper.instance.getEvents();
    List<Event> res = List.empty(growable: true);
    if (evnts.isNotEmpty) {
      for (Event event in evnts) {
        if (event.idUser == widget.user.id) {
          res.add(event);
          if (selectedEvents[DateTime.parse(event.start.substring(0, 10))] ==
              null) {
            setState(() {
              selectedEvents[DateTime.parse(event.start.substring(0, 10))] = [
                event
              ];
            });
          } else {
            var list =
                selectedEvents[DateTime.parse(event.start.substring(0, 10))];
            bool exists = false;
            for (Event existEvent in list!) {
              if (event.id == existEvent.id) {
                exists = true;
                break;
              }
            }
            if (!exists) {
              setState(() {
                selectedEvents[DateTime.parse(event.start.substring(0, 10))]
                    ?.add(event);
              });
            }
          }
        }
      }
    }
    return res;
  }

  void initEvents() {
    fetchEvents().then((value) {
      setState(() {
        events = value;
      });
    });
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[DateTime.parse(
            date.toString().substring(0, date.toString().length - 2))] ??
        [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekVisible: true,
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            eventLoader: _getEventsfromDay,
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Consts.btnColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.green[200],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Consts.btnColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ..._getEventsfromDay(selectedDay).map((Event event) => InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => AddChangeEventPage(
                            user: widget.user,
                            event: event,
                          )),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Text(
                        "●",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Consts.btnColor),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        event.title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            decoration: DateTime.parse(event.start)
                                        .difference(DateTime.now())
                                        .inDays <
                                    0
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                          DateTime.parse(event.start)
                                      .difference(DateTime.now())
                                      .inDays ==
                                  0
                              ? "(today)"
                              : "(${DateFormat.MMMd().format(DateTime.parse(event.start))})",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ))
                    ]),
                    Text(
                      event.isAllDay == 0
                          ? "${DateFormat.jm().format(DateTime.parse(event.start))}"
                          : "all day",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ))),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Consts.btnColor,
        onPressed: () async {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => AddChangeEventPage(user: widget.user)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

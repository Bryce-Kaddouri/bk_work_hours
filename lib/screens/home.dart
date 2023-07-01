import 'package:bk_work_hours/api.dart';
import 'package:bk_work_hours/screens/add_event.dart';
import 'package:bk_work_hours/screens/antest.dart';
import 'package:bk_work_hours/screens/edit_event_screen.dart';
import 'package:bk_work_hours/screens/splash_delete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'login.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('BK Work Hours'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await ApiInit().signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddEventScreen()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: ApiInit().getEventsForUser(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Text('active');
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('error');
              } else {
                return SfCalendar(
                  firstDayOfWeek: 1,
                  onLongPress: (CalendarLongPressDetails details) {
                    int i = 0;
                    if (details.targetElement == CalendarElement.calendarCell) {
                      final DateTime date = details.date!;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEventScreen(
                                    dateEventParam: date,
                                  )));
                    } else {
                      print('data');
                      details.appointments!.forEach((element) {
                        print(element.to);
                        print(element.from);
                        print(element.id);
                      });
                      // show dialog to edit or delete the appointment
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.arrow_back),
                                  ),
                                  Text('supprimer ou modifier ?'),
                                ],
                              ),
                              content: Container(
                                width: double.maxFinite,
                                height: 300,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // elevated button with an animated icon when the user click on it
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        minimumSize: Size(100, 100),
                                        maximumSize: Size(200, 200),
                                      ),
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Supprimer'),
                                              content: const Text(
                                                  'Are you sure you want to delete this event?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await ApiInit()
                                                        .deleteEventForUser(
                                                            details
                                                                .appointments![
                                                                    0]
                                                                .id);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      label: const Text('Supprimer'),
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        minimumSize: Size(100, 100),
                                        maximumSize: Size(200, 200),
                                      ),
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        DateTime dayEdit =
                                            details.appointments![0].from;
                                        TimeOfDay startHourEdit =
                                            TimeOfDay.fromDateTime(
                                                details.appointments![0].from);
                                        TimeOfDay endHourEdit =
                                            TimeOfDay.fromDateTime(
                                                details.appointments![0].to);

                                        // show the splash screen while we wait for the app to load
                                        // push splash screen
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditEventScreen(
                                                      dateEventParam: dayEdit,
                                                      startHourEventParam:
                                                          startHourEdit,
                                                      endHourEventParam:
                                                          endHourEdit,
                                                      id: details
                                                          .appointments![0].id,
                                                    )));
                                      },
                                      label: const Text('Modifier'),
                                    ),
                                  ],
                                ),
                              )
                              // actions: <Widget>[
                              //   TextButton(
                              //     onPressed: () async {
                              //       // await ApiInit().deleteEvent(
                              //       //     appointmentDetails.eventName);
                              //       Navigator.pop(
                              //         context,
                              //       );
                              //     },
                              //     child: const Text('OK'),
                              //   ),
                              // ],
                              );
                        },
                      );
                    }
                  },
                  onTap: (CalendarTapDetails details) {
                    if (details.targetElement == CalendarElement.appointment) {
                      final Meeting appointmentDetails =
                          details.appointments![0];
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          int minDiff = appointmentDetails.to
                              .difference(appointmentDetails.from)
                              .inMinutes;
                          int resHour = minDiff ~/ 60;
                          int resMin = minDiff % 60;
                          String res = resHour.toString() +
                              ' hours ' +
                              resMin.toString() +
                              ' minutes';
                          return AlertDialog(
                            title: Text('Informmation'),
                            content: Text(
                                'From: ${appointmentDetails.from}\nTo: ${appointmentDetails.to}\nDuration: ${res} minutes'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  // await ApiInit().deleteEvent(
                                  //     appointmentDetails.eventName);
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  view: CalendarView.week,
                  allowViewNavigation: true,
                  allowedViews: [
                    CalendarView.day,
                    CalendarView.week,
                    CalendarView.workWeek,
                    CalendarView.month,
                    CalendarView.timelineDay,
                    CalendarView.timelineWeek,
                    CalendarView.timelineWorkWeek,
                    CalendarView.timelineMonth,
                    CalendarView.schedule
                  ],
                  showDatePickerButton: true,
                  showNavigationArrow: true,
                  showTodayButton: true,
                  showWeekNumber: false,
                  dataSource:
                      MeetingDataSource(_getDataSource(snapshot.data!.docs)),
                  monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment),
                );
              }
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Container(
                margin: EdgeInsets.all(5),
                width: 80,
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, size: 30, color: Colors.blue),
                    Text('Home',
                        style: TextStyle(fontSize: 10, color: Colors.blue)),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              width: 80,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  minimumSize: Size(60, 50),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddEventScreen()));
                },
                child: Icon(Icons.add),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilScreen()));
              },
              child: Container(
                margin: EdgeInsets.all(5),
                width: 80,
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 30, color: Colors.white),
                    Text('Profil',
                        style: TextStyle(fontSize: 10, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Meeting> _getDataSource(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    final List<Meeting> meetings = <Meeting>[];

    docs.forEach((element) {
      final DateTime today = DateTime.now();
      final Timestamp startTime = element.get('startDate');
      final Timestamp endTime = element.get('endDate');

      final DateTime startedAt = startTime.toDate();
      final DateTime finishedAt = endTime.toDate();

      // final DateTime endTime = startTime.add(const Duration(hours: 2));
      meetings.add(Meeting(
          startedAt, finishedAt, const Color(0xFF0F8644), false, element.id));
    });

    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  // @override
  // String getSubject(int index) {
  //   return appointments![index].eventName;
  // }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.from, this.to, this.background, this.isAllDay, this.id);

  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String id;
}

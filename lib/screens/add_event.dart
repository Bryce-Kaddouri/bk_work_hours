import 'package:bk_work_hours/api.dart';
import 'package:bk_work_hours/screens/home.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  DateTime? dateEventParam;
  AddEventScreen({super.key, this.dateEventParam});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  // global key for the form
  final _formKey = GlobalKey<FormState>();
  DateTime dateEvent = DateTime.now();
  TimeOfDay startHourEvent = TimeOfDay.now();
  TimeOfDay endHourEvent = TimeOfDay.now();

  // DateTime _startHourEvent = DateTime.now();
  // DateTime _endEventDate = DateTime.now().add(const Duration(hours: 1));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('Add Event'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Start Date',
                    label: Text('Start Date'),
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  readOnly: true,
                  controller: TextEditingController(
                      text:
                          '${dateEvent.day}/${dateEvent.month}/${dateEvent.year}'),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: dateEvent,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        dateEvent = DateTime(date.year, date.month, date.day);
                      });
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Start Hour',
                    label: Text('Start Hour'),
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  readOnly: true,
                  controller: TextEditingController(
                      text: '${startHourEvent.hour < 10 ? '0' : ''}'
                          '${startHourEvent.hour}:${startHourEvent.minute < 10 ? '0' : ''}'
                          '${startHourEvent.minute}'),
                  onTap: () async {
                    final startHour = await showTimePicker(
                      context: context,
                      initialTime: startHourEvent,
                    );

                    if (startHour != null) {
                      setState(() {
                        startHourEvent = TimeOfDay(
                            hour: startHour.hour, minute: startHour.minute);
                      });
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'End Hour',
                    label: Text('End Hour'),
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  readOnly: true,
                  controller: TextEditingController(
                      text: '${endHourEvent.hour < 10 ? '0' : ''}'
                          '${endHourEvent.hour}:${endHourEvent.minute < 10 ? '0' : ''}'
                          '${endHourEvent.minute}'),
                  onTap: () async {
                    final endHour = await showTimePicker(
                      context: context,
                      initialTime: startHourEvent,
                    );

                    if (endHour != null) {
                      setState(() {
                        endHourEvent = TimeOfDay(
                            hour: endHour.hour, minute: endHour.minute);
                      });
                    }
                  },
                ),
              ),

              // start datetime
              // Container(
              //   margin: const EdgeInsets.all(10),
              //   width: MediaQuery.of(context).size.width,
              //   child: TextFormField(
              //     decoration: const InputDecoration(
              //       hintText: 'Start Date',
              //       label: Text('Start Date'),
              //       border: OutlineInputBorder(),
              //       errorBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.red),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.blue),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.grey),
              //       ),
              //     ),
              //     onTapOutside: (event) {
              //       FocusScope.of(context).unfocus();
              //     },
              //     readOnly: true,
              //     controller: TextEditingController(
              //         text:
              //             '${_startEventDate.day}/${_startEventDate.month}/${_startEventDate.year} ${_startEventDate.hour}:${_startEventDate.minute}'),
              //     onTap: () async {
              //       final date = await showDatePicker(
              //         context: context,
              //         initialDate: _startEventDate,
              //         firstDate: DateTime.now(),
              //         lastDate: DateTime.now().add(const Duration(days: 365)),
              //       );
              //       if (date != null) {
              //         TimeOfDay? time = await showTimePicker(
              //           context: context,
              //           initialTime: TimeOfDay.now(),
              //         );
              //         if (time != null) {
              //           setState(() {
              //             _startEventDate = DateTime(date.year, date.month,
              //                 date.day, time.hour, time.minute);
              //           });
              //         }
              //       }
              //     },
              //   ),
              // ),
              // // end datetime
              // Container(
              //   margin: const EdgeInsets.all(10),
              //   width: MediaQuery.of(context).size.width,
              //   child: TextFormField(
              //     decoration: const InputDecoration(
              //       hintText: 'End Date',
              //       label: Text('End Date'),
              //       border: OutlineInputBorder(),
              //       errorBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.red),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.blue),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.grey),
              //       ),
              //     ),
              //     onTapOutside: (event) {
              //       FocusScope.of(context).unfocus();
              //     },
              //     readOnly: true,
              //     controller: TextEditingController(
              //         text:
              //             '${_endEventDate.day}/${_endEventDate.month}/${_endEventDate.year} ${_endEventDate.hour}:${_endEventDate.minute}'),
              //     onTap: () async {
              //       final date = await showDatePicker(
              //         context: context,
              //         initialDate: _endEventDate,
              //         firstDate: DateTime.now(),
              //         lastDate: DateTime.now().add(const Duration(days: 365)),
              //       );
              //       if (date != null) {
              //         TimeOfDay? time = await showTimePicker(
              //           context: context,
              //           initialTime: TimeOfDay.now(),
              //         );
              //         if (time != null) {
              //           setState(() {
              //             _endEventDate = DateTime(date.year, date.month,
              //                 date.day, time.hour, time.minute);
              //           });
              //         }
              //       }
              //     },
              //   ),
              // ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      minimumSize: const Size(150, 50),
                    ),
                    onPressed: () async {
                      DateTime _startEventDate = DateTime(
                          dateEvent.year,
                          dateEvent.month,
                          dateEvent.day,
                          startHourEvent.hour,
                          startHourEvent.minute,
                          0);
                      DateTime _endEventDate = DateTime(
                          dateEvent.year,
                          dateEvent.month,
                          dateEvent.day,
                          endHourEvent.hour,
                          endHourEvent.minute,
                          0);
                      if (_startEventDate.isAfter(_endEventDate) ||
                          _startEventDate.isAtSameMomentAs(_endEventDate)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            showCloseIcon: true,
                            closeIconColor: Colors.white,
                            content: Text('Start date must be before end date'),
                          ),
                        );
                        return;
                      }
                      await ApiInit().addEventForUser(
                        _startEventDate,
                        _endEventDate,
                      );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Add Event'),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

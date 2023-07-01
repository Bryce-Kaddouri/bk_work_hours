import 'package:bk_work_hours/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkHourScreen extends StatefulWidget {
  const WorkHourScreen({super.key});

  @override
  State<WorkHourScreen> createState() => _WorkHourScreenState();
}

class _WorkHourScreenState extends State<WorkHourScreen> {
  // global key for the form
  final _formKey = GlobalKey<FormState>();

  DateTimeRange? dateInit = null;
  String copyText = '';
  int totalMinutes = 0;

  TextEditingController _dateController = TextEditingController();

  getMoisStrFromDate(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Janvier';
      case 2:
        return 'Février';
      case 3:
        return 'Mars';
      case 4:
        return 'Avril';
      case 5:
        return 'Mai';
      case 6:
        return 'Juin';
      case 7:
        return 'Juillet';
      case 8:
        return 'Août';
      case 9:
        return 'Septembre';
      case 10:
        return 'Octobre';
      case 11:
        return 'Novembre';
      case 12:
        return 'Décembre';
      default:
        return '';
    }
  }

  getJourStrFromDate(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Lundi';
      case 2:
        return 'Mardi';
      case 3:
        return 'Mercredi';
      case 4:
        return 'Jeudi';
      case 5:
        return 'Vendredi';
      case 6:
        return 'Samedi';
      case 7:
        return 'Dimanche';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Heures travaillées'),
      ),
      body: Container(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 50,
                child: TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    label: Text('Date de début'),
                    hintText: 'Sélectionner un intervalle de date',
                    border: OutlineInputBorder(),
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your email';
                  //   }
                  //   return null;
                  // },
                  onTap: () async {
                    DateTimeRange? dateRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now().add(Duration(days: 365)));
                    if (dateRange != null) {
                      print(dateRange.start);
                      print(dateRange.end);
                      _dateController.text =
                          '${dateRange.start.day}/${dateRange.start.month}/${dateRange.start.year} - ${dateRange.end.day}/${dateRange.end.month}/${dateRange.end.year}';
                      setState(() {
                        dateInit = dateRange;
                      });
                    }
                  },
                ),
              ),
            ),
            FutureBuilder<QuerySnapshot?>(
              future: ApiInit().getEventsForUserByDate(dateInit),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      int totalMinutes1 = 0;
                      for (var i = 0; i < snapshot.data!.docs.length; i++) {
                        Timestamp dateStart =
                            snapshot.data!.docs[i]['startDate'];
                        Timestamp endStart = snapshot.data!.docs[i]['endDate'];

                        DateTime dateStart2 = dateStart.toDate();
                        DateTime endStart2 = endStart.toDate();

                        Duration duration = endStart2.difference(dateStart2);
                        if (endStart2
                            .isBefore(dateInit!.end.add(Duration(days: 1)))) {
                          totalMinutes1 += duration.inMinutes;
                        }
                      }

                      print(totalMinutes1);
                      return Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Timestamp dateStart =
                                    snapshot.data!.docs[index]['startDate'];
                                Timestamp endStart =
                                    snapshot.data!.docs[index]['endDate'];

                                DateTime dateStart2 = dateStart.toDate();
                                DateTime endStart2 = endStart.toDate();

                                if (endStart2.isBefore(
                                    dateInit!.end.add(Duration(days: 1)))) {
                                  String moisStart =
                                      getMoisStrFromDate(dateStart2);
                                  String jourStart =
                                      getJourStrFromDate(dateStart2);

                                  // String moisEnd = getMoisStrFromDate(endStart2);
                                  // String jourEnd = getJourStrFromDate(endStart2);

                                  Duration duration =
                                      endStart2.difference(dateStart2);

                                  copyText +=
                                      'Le ${jourStart} ${dateStart2.day} $moisStart ${dateStart.toDate().day} de ${dateStart.toDate().hour}h${dateStart.toDate().minute} à ${endStart.toDate().hour}h${endStart.toDate().minute}\n';
                                  print(totalMinutes);
                                  // totalMinutes1 += duration.inMinutes;

                                  return ListTile(
                                    title: Text(
                                        'Le ${jourStart} ${dateStart2.day} $moisStart ${dateStart.toDate().day} de ${dateStart.toDate().hour}h${dateStart.toDate().minute} à ${endStart.toDate().hour}h${endStart.toDate().minute}'),
                                    subtitle: Text(
                                        'Durée: ${duration.inHours}h${duration.inMinutes.remainder(60)}'),
                                  );
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                    'Total: ${totalMinutes1 ~/ 60}h${totalMinutes1.remainder(60)}'),
                                ElevatedButton.icon(
                                    onPressed: () {
                                      print(copyText);
                                      Clipboard.setData(ClipboardData(
                                          text:
                                              '$copyText\n\nTotal: ${totalMinutes1 ~/ 60}h${totalMinutes1.remainder(60)}'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Texte copié dans le presse papier'),
                                      ));
                                    },
                                    icon: Icon(Icons.copy),
                                    label: Text('Copier le texte')),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: Text('Aucune donnée'));
                    }

                  // return Expanded(
                  //   child: ListView.builder(
                  //     itemCount: snapshot.data!.docs.length,
                  //     itemBuilder: (context, index) {
                  //       DocumentSnapshot event =
                  //           snapshot.data!.docs[index];
                  //       DateTime date = event['date'].toDate();
                  //       int minutes = event['minutes'];
                  //       totalMinutes += minutes;
                  //       return Container(
                  //         margin: EdgeInsets.all(10),
                  //         child: Column(
                  //           children: [
                  //             Text(
                  //               '${getJourStrFromDate(date)} ${date.day} ${getMoisStrFromDate(date)} ${date.year}',
                  //               style: TextStyle(
                  //                   fontSize: 20,
                  //                   fontWeight: FontWeight.bold),
                  //             ),
                  //             Text(
                  //               '${event['start']} - ${event['end']}',
                  //               style: TextStyle(
                  //                   fontSize: 20,
                  //                   fontWeight: FontWeight.bold),
                  //             ),
                  //             Text(
                  //               '${minutes} minutes',
                  //               style: TextStyle(
                  //                   fontSize: 20,
                  //                   fontWeight: FontWeight.bold),
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

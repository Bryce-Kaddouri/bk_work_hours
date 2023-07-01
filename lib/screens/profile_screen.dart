import 'package:bk_work_hours/screens/work_hours_screen.dart';
import 'package:flutter/material.dart';

import '../api.dart';
import 'add_event.dart';
import 'home.dart';
import 'login.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
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
      body: ListView(
        children: [
          ListTile(
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('Nombres d\'heures travaillées'),
            leading: const Icon(Icons.timer),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WorkHourScreen()));
            },
          ),
        ],
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
                    Icon(Icons.home, size: 30, color: Colors.white),
                    Text('Home',
                        style: TextStyle(fontSize: 10, color: Colors.white)),
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
                    Icon(Icons.person, size: 30, color: Colors.blue),
                    Text('Profil',
                        style: TextStyle(fontSize: 10, color: Colors.blue)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:final_emeds/admin/authentication/login.dart';
import 'package:final_emeds/user/cart/order_history.dart';
import 'package:final_emeds/user/doctor/view_doctor.dart';
import 'package:final_emeds/user/medicine/view_med.dart';
import 'package:final_emeds/user/menubar/privacy_policy.dart';
import 'package:final_emeds/user/menubar/terms_and_conditions.dart';
import 'package:final_emeds/user/wellness/view_well.dart';
import 'package:flutter/material.dart';


class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _listItem = [
    {"image": 'asset/img/medicine.jpeg', "isSaved": false},
    {"image": 'asset/img/stethescope.jpg', "isSaved": false},
    {"image": 'asset/img/wellness.jpeg', "isSaved": true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Add this key to control the Scaffold
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.teal,
        
        
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
          
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer(); // Open the Drawer
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Image.asset(
                      'asset/img/emeds.png',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Purchase Your Medicine',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
               // Navigator.push(
                //  context,
                //  MaterialPageRoute(
               //     builder: (context) =>  const Useraccount(),
               //   ),
               // );
              },
            ),
            ListTile(
              title: const Text('Terms & Conditions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Termscondition(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Privacy policy'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Privacypolicy(),
                  ),
                );
              },
            ),
             ListTile(
              title: const Text('My orders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderHistoryPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                _confirmLogout(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                        image: AssetImage('asset/img/emeds.png'),
                        fit: BoxFit.cover)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.black.withOpacity(.4),
                            Colors.black.withOpacity(.2),
                          ])),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                  
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: _listItem.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> item = entry.value;

                    return GestureDetector(
                      onTap: () {
                        // Add your navigation logic here
                        // Use a switch statement or if-else to determine the destination based on the index
                        switch (index) {
                          case 0:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Viewmed(),
                              ),
                            );
                            break;
                          case 1:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Docdetails(),
                              ),
                            );
                            break;
                          case 2:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Wellview(),
                              ),
                            );
                            break;
                          default:
                            break;
                        }
                      },
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(item["image"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Transform.translate(
                            offset: const Offset(55, -58),
                            child: Container(
                              width: 30,
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(),
                              
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                _handleLogout(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginForm(),
      ),
    );
  }
}

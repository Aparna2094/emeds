import 'package:final_emeds/admin/authentication/database/data.dart';
import 'package:final_emeds/admin/authentication/login.dart';
import 'package:final_emeds/user/account.dart';
import 'package:final_emeds/user/doctor/view_doctor.dart';
import 'package:final_emeds/user/medicine/view_med.dart';
import 'package:final_emeds/user/menubar/privacy_policy.dart';
import 'package:final_emeds/user/menubar/terms_and_conditions.dart';
import 'package:final_emeds/user/wellness/view_well.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class UserMenu extends StatefulWidget {
  const UserMenu({super.key});

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  // ignore: unused_field
  late Future<Box<Data>> _boxdata;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<MenuOption> menuOptions = [
    MenuOption("Medicine", 'asset/img/medicine.jpeg', 'medicineHeroTag'),
    MenuOption("Consult Doctor", 'asset/img/stethescope.jpg', 'doctorHeroTag'),
    MenuOption("Wellness", 'asset/img/wellness.jpeg', 'wellnessHeroTag'),
    //   MenuOption("User", 'asset/img/person.jpeg', 'userHeroTag'),
  ];

   @override
  void initState() {
    super.initState();
    _boxdata = _openBox();
  }

   Future<Box<Data>> _openBox() async {
    await Hive.initFlutter(); // Initialize Hive
    final box = await Hive.openBox<Data>('box');
    return box;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor:const Color.fromARGB(255, 190, 182, 111),
          title:const Text(
            'Services',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
         
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 190, 182, 111),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Image.asset(
                        'asset/img/emeds.png',
                        
                      ),
                      // Add user profile picture here
                      // backgroundImage: NetworkImage('url_of_user_profile_picture'),
                    ),
                    const SizedBox(height: 10),
                   const Text(
                      'Purchace Your Medicine', // Replace with actual user name
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
                  // Add navigation to user profile page here
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  const Useraccount(),
                    ),
                  );
                },
              ),
              ListTile(
               title: const Text('Terms & Conditions'),
                onTap: () {
                  // Add navigation to user profile page here
                  Navigator.pop(context); // Close the drawer
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
                  // Add navigation to user profile page here
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Privacypolicy(),
                    ),
                  );
                },
              ),
              ListTile(
                title:const Text('Logout'),
                onTap: () {
                  _confirmLogout(context);
                },
              ),
            ],
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 246, 242, 242),
          padding:const  EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8, // Adjust as needed
            ),
            itemCount: menuOptions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _handleMenuTap(context, menuOptions[index]);
                },
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage(menuOptions[index].imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                     const  SizedBox(height: 8.0),
                      Text(
                        menuOptions[index].title,
                        style:const TextStyle(
                          color: Colors.teal,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleMenuTap(BuildContext context, MenuOption menuOption) {
    // Add your navigation logic or actions here
    if (menuOption.title == "Medicine") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Viewmed(),
        ),
      );
    } else if (menuOption.title == "Consult Doctor") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Docdetails(),
        ),
      );
    } else if (menuOption.title == "User") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  const Useraccount(),
        ),
      );
    } else if (menuOption.title == "Wellness") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Wellview(),
        ),
      );
    }
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
              child:const  Text("No"),
            ),
            TextButton(
              onPressed: () {
                _handleLogout(context);
              },
              child:const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    // Add your logic for the logout button action here
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginForm(),
      ),
    );
  }
}

class MenuOption {
  final String title;
  final String imagePath;
  final String heroTag;

  MenuOption(this.title, this.imagePath, this.heroTag);
}

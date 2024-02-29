
import 'package:final_emeds/admin/authentication/login.dart';
import 'package:final_emeds/admin/doctor/doc_add.dart';
import 'package:final_emeds/admin/medicine/add_medicine.dart';
import 'package:final_emeds/admin/user_details.dart';
import 'package:final_emeds/admin/wellness/well_add.dart';
import 'package:flutter/material.dart';


class Mymenu extends StatelessWidget {
  final List<MenuOption> menuOptions = [
    MenuOption("Medicine", Icons.local_pharmacy, Colors.teal),
    MenuOption("Consult Doctor", Icons.person, Colors.teal),
    MenuOption("Wellness", Icons.favorite, Colors.teal),
        MenuOption("User", Icons.account_box, Colors.teal),

    // Added Logout option
  ];

   Mymenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor:const Color.fromARGB(255, 190, 182, 111),
          title: const Text('Services'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app), // Logout icon in the AppBar
              onPressed: () {
                _confirmLogout(context);
              },
            ),
          ],
        ),
        body: Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: menuOptions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _handleMenuTap(context, menuOptions[index]);
                },
                child: Card(
                  color: menuOptions[index].color,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          menuOptions[index].icon,
                          size: 50,
                          color: Colors.white,
                        ),
                       const SizedBox(height: 8),
                        Text(
                          menuOptions[index].title,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
          builder: (context) => const ProductAddingPage(), // Replace with the correct destination
        ),
      );
    }

    else if (menuOption.title == "Consult Doctor") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>const Doctoraddingpage(), // Replace with the correct destination
      ),
    );
  }
   else if (menuOption.title == "User") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>AdProfile(), // Replace with the correct destination
      ),
    );
  }

  else if (menuOption.title == "Wellness") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>const WellnessAdd(), // Replace with the correct destination
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
          content: const Text("Are you sure  want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                _handleLogout(context);
              },
              child:const  Text("Yes"),
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
        builder: (context) => const LoginForm(), // Replace with the correct destination
      ),
    );
  }
}

class MenuOption {
  final String title;
  final IconData icon;
  final Color color;

  MenuOption(this.title, this.icon, this.color);
}

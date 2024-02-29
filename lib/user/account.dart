import 'package:final_emeds/admin/authentication/database/data.dart';
import 'package:final_emeds/admin/authentication/database/user_data.dart';
import 'package:final_emeds/user/menubar/fade_transition.dart';
import 'package:flutter/material.dart';



class Useraccount extends StatefulWidget {
  const Useraccount({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UseraccountState createState() => _UseraccountState();
}

class _UseraccountState extends State<Useraccount> {
  Data? userData;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    String email = 'user@example.com';

    List<Data> users = await getUserByEmail(email);

    if (users.isNotEmpty) {
      setState(() {
        userData = users.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.teal,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 450,
                backgroundColor: Colors.teal,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('asset/img/emeds.png'),
                            fit: BoxFit.cover)),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [Colors.teal, Colors.white.withOpacity(.3)])),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FadeAnimation(1, Text(
                              "Emma Watson",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
                            )),
                            SizedBox(height: 20,),
                            Row(
                              children: <Widget>[
                                FadeAnimation(1.2,
                                    Text(
                                      "60 Videos",
                                      style: TextStyle(color: Colors.grey, fontSize: 16),
                                    )),
                                SizedBox(width: 50,),
                                FadeAnimation(1.3, Text(
                                  "240K Subscribers",
                                  style: TextStyle(color: Colors.grey, fontSize: 16),
                                ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const FadeAnimation(1.6, Text(
                          "Emma Charlotte Duerre Watson was born in Paris, France, to English parents, Jacqueline Luesby and Chris Watson, both lawyers. She moved to Oxfordshire when she was five, where she attended the Dragon School.",
                          style: TextStyle(color: Colors.grey, height: 1.4),)),
                        const SizedBox(height: 40,),
                        const FadeAnimation(1.6,
                            Text("Born", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
                        ),
                        const SizedBox(height: 10,),
                        const FadeAnimation(1.6,
                            Text("April, 15th 1990, Paris, France", style: TextStyle(color: Colors.grey),)
                        ),
                        const SizedBox(height: 20,),
                        const FadeAnimation(1.6,
                            Text("Nationality", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
                        ),
                        const SizedBox(height: 10,),
                        const FadeAnimation(1.6,
                            Text("British", style: TextStyle(color: Colors.grey),)
                        ),
                        const SizedBox(height: 20,),
                        const FadeAnimation(1.6,
                            Text("Videos", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
                        ),
                        const SizedBox(height: 20,),
                        FadeAnimation(1.8, SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              makeVideo(image: 'assets/images/emma-1.jpg'),
                              makeVideo(image: 'assets/images/emma-2.jpg'),
                              makeVideo(image: 'assets/images/emma-3.jpg'),
                            ],
                          ),
                        )),
                        const SizedBox(height: 120,)
                      ],
                    ),
                  )
                ]),
              )
            ],
          ),
          Positioned.fill(
            bottom: 50,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FadeAnimation(2,
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.yellow[700]
                  ),
                  child: const Align(child: Text("Follow", style: TextStyle(color: Colors.white),)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget makeVideo({image}) {
    return AspectRatio(
      aspectRatio: 1.5/ 1,
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover
            )
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(.9),
                    Colors.black.withOpacity(.3)
                  ]
              )
          ),
          child: const Align(
            child: Icon(Icons.play_arrow, color: Colors.white, size: 70,),
          ),
        ),
      ),
    );
  }
}

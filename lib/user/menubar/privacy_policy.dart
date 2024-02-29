import 'package:final_emeds/user/menubar/fade_transition.dart';
import 'package:flutter/material.dart';


class Privacypolicy extends StatefulWidget {
  const Privacypolicy({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PrivacypolicyState createState() => _PrivacypolicyState();
}

class _PrivacypolicyState extends State<Privacypolicy> {
  @override
  Widget build(BuildContext context) {
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
                        fit: BoxFit.cover
                      )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.teal,
                            Colors.white.withOpacity(.3)
                          ]
                        )
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FadeAnimation(1, Text("Privacy Policy", style: 
                              TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40)
                            ,)),
                            SizedBox(height: 20,),
                            Row(
                              children: <Widget>[
                                FadeAnimation(1.2, 
                                  Text("60 Videos", style: TextStyle(color: Colors.white, fontSize: 16),)
                                ),
                                SizedBox(width: 50,),
                                FadeAnimation(1.3, Text("240K Subscribers", style: 
                                  TextStyle(color: Colors.white, fontSize: 16)
                                ,))
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
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(1.6, Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesettin", 
                        style: TextStyle(color: Color.fromARGB(255, 219, 216, 216), height: 1.4),)),
                        SizedBox(height: 40,),
                       
                       
                        SizedBox(height: 120,)
                      ],
                    ),
                  )
                ]),
              )
            ],
          ),
          
        ],
      ),
    );
  }


  }

import 'dart:convert';
import 'dart:typed_data';


import 'package:final_emeds/admin/doctor/database/doctordata.dart';
import 'package:final_emeds/user/doctor/details_doc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';




class Docdetails extends StatefulWidget {
  const Docdetails({super.key});

  @override
  State<Docdetails> createState() => _DocdetailsState();
}

class _DocdetailsState extends State<Docdetails> {
  late Future<Box<Doctordata>> _boxdoctorFuture;

  @override
  void initState() {
    super.initState();
    _boxdoctorFuture = _openBox1();
  }

  Future<Box<Doctordata>> _openBox1() async {
    await Hive.initFlutter(); // Initialize Hive
    final box1 = await Hive.openBox<Doctordata>('boxdoctor');
    return box1;
  }
 

  

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Doctor details'),
         
      ),
      body: FutureBuilder(
        future: _boxdoctorFuture,
        builder: (context, AsyncSnapshot<Box<Doctordata>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return  Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No products added yet.'));
          } else {
            final boxdoctor = snapshot.data!;
            final doctorList = boxdoctor.values.toList();
            return doctorList.isNotEmpty
                ? GridView.builder(
                   shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 0.7,
                    ),
                    itemCount: doctorList.length,
                    itemBuilder: (context, index) {
                      List<int> bytes = base64Decode(doctorList[index].image1);

                      return InkWell(
                        onTap: (){
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context)=>DoctorDetailsPage(product: doctorList[index]),),);
                        },
                        child: Card(
                          elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                      
                              color:const Color.fromARGB(255, 221, 228, 227),
                       
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Expanded(
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12.0),
                                        ),
                                        child: Image.memory(
                                          Uint8List.fromList(bytes),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      doctorList[index].docname,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                      Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${doctorList[index].doccategory}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.teal, // Set category text color
                                      ),
                                    ),
                                  ),
                                   Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 11.0,
                                      vertical: 5.0,
                                    ),
                                    child: Text(
                                      ' ${doctorList[index].education}',
                                      style:const  TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  
                              ],
                            ),
                          ),
                        
                      );
                    },
                  )
                : const Center(child: Text('No products added yet.'));
          }
        },
      ),
    );
  }
}

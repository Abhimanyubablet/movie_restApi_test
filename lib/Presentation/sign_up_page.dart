import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_for_movie_with_api/Presentation/login_page.dart';

class SinpUpPage extends StatefulWidget {
  const SinpUpPage({super.key});

  @override
  State<SinpUpPage> createState() => _SinpUpPageState();
}

class _SinpUpPageState extends State<SinpUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference _items =
      FirebaseFirestore.instance.collection('UserProfileData');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Regester Page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 16.0, horizontal: 30.0), // Customize padding
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text("Let's Get Started",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xFF625A5A),
                              )),
                        ),
                        Container(
                          child: Text(
                            'Create an account',
                            style: TextStyle(color: Color(0xFF0D4619)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Your Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Your Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      prefixIcon: Icon(Icons.phone),
                      prefixText: "+91 ",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    width: 300,
                    height: 50,
                    margin: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        await Firebase.initializeApp(); // Initialize Firebase
                        var phoneNumber = mobileController.text.trim();
                        if (!phoneNumber.startsWith("+91")) {
                          phoneNumber = "+91$phoneNumber";
                        }
                        try {
                          UserCredential userCredential = await auth
                              .createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString(),
                          )
                              .whenComplete(() async {
                            QuerySnapshot emailQuery = await _items
                                .where("email", isEqualTo: emailController.text)
                                .get();
                            QuerySnapshot mobileQuery = await _items
                                .where("mobile",
                                    isEqualTo: mobileController.text)
                                .get();

                            if (emailQuery.docs.isNotEmpty &&
                                mobileQuery.docs.isNotEmpty) {
                              Fluttertoast.showToast(
                                msg:
                                    "Both email and mobile number are already in use.",
                                backgroundColor: Colors.blueGrey,
                                timeInSecForIosWeb: 5,
                              );
                              return;                             }

                            if (emailQuery.docs.isNotEmpty) {
                              Fluttertoast.showToast(
                                msg: "Email is already in use",
                                backgroundColor: Colors.blueGrey,
                                timeInSecForIosWeb: 5,
                              );
                              return;
                            }

                            if (mobileQuery.docs.isNotEmpty) {
                              Fluttertoast.showToast(
                                msg:
                                    "Mobile number is already in use. Please use a different mobile number.",
                                backgroundColor: Colors.blueGrey,
                                timeInSecForIosWeb: 5,
                              );
                            } else {
                              final String name = nameController.text;
                              final String email = emailController.text;
                              final String password = passwordController.text;
                              String userId = auth.currentUser?.uid ?? "";
                              await _items.doc(userId).set({
                                "name": name,
                                "email": email,
                                "mobile": phoneNumber,
                                "password": password,
                                "userId": userId,
                              });
                            }
                          });
                          nameController.text = '';
                          emailController.text = '';
                          mobileController.text = '';
                          passwordController.text = '';
                          print("User created: ${userCredential.user?.uid}");
                          print("Registration successful!");
                          Fluttertoast.showToast(
                            msg: "Registration successful",
                            backgroundColor: Colors.blueGrey,
                            timeInSecForIosWeb: 5,
                          );
                        } catch (e) {
                          print("Error during sign up: $e");
                        }
                      },
                      child: Text("Regester"),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center,
                        children: [
                          Container(
                            child: Text(
                              "Have an acount?",
                            ),
                          ),
                          Container(
                            child: Container(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text(
                                  " Sign In ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF625A5A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

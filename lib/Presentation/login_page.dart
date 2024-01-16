import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_for_movie_with_api/Presentation/sign_up_page.dart';
import 'Dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailLoginController = TextEditingController();
  final passwordLoginController = TextEditingController();

  void _handleSignIn() async {
    try {
      Fluttertoast.showToast(
        msg: "Login successful",
        backgroundColor: Colors.blueGrey,
        timeInSecForIosWeb: 5,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashBoard()),
      );
    } catch (error) {
      print("Error: $error");
      String errorMessage = "An error occurred during login.";
      if (error is FirebaseAuthException) {
        errorMessage = error.message ?? "An unexpected error occurred.";
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.blueGrey,
        timeInSecForIosWeb: 5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 30.0,
            ),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          "Let's Get Started",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xFF625A5A),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Color(0xFF0D4619)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: TextFormField(
                      controller: emailLoginController,
                      decoration: InputDecoration(
                        labelText: "Your Email",
                        prefixIcon: Icon(Icons.email),
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: TextFormField(
                      controller: passwordLoginController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 50,
                        margin: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: _handleSignIn,
                          child: Text("Login"),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 120,
                        height: 50,
                        margin: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SinpUpPage()));
                          },
                          child: Text("SignUp"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

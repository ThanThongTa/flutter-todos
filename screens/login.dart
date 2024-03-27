// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:futures_local_storage_and_database/screens/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // variable for the obscurity of the password
  bool isPasswordObscured = true;
  // key for the password in the local storage
  final String passwordKey = "login-password";
  // temp variable for password from the local storage
  late String localPassword;
  late Map<String, String> localPasswords = {};
  // controller for the password text field
  final myPasswordController = TextEditingController();
  // controller for the username text field
  final myUserNameController = TextEditingController();

  // function to change the obscurity of the password
  changeObscurity() {
    setState(() {
      isPasswordObscured = !isPasswordObscured;
    });

    @override
    // ignore: unused_element
    void dispose() {
      // Clean up the controller when the widget is disposed.
      myPasswordController.dispose();
      myUserNameController.dispose();
      super.dispose();
    }
  }

//#region shared Preferences

// controller of widgets

  // init of the SharedPreferences / local storage
  final Future<SharedPreferences> meinSpeicher =
      SharedPreferences.getInstance();

  // function to save a password in the local storage / shared preferences
  Future<bool> setPassword({required String neuesPasswort}) async {
    SharedPreferences speicher = await meinSpeicher;
    bool result = await speicher.setString(passwordKey, neuesPasswort);
    return result;
  }

  Future<bool> setUserNameAndPassword(
      {required String userName, required String neuesPasswort}) async {
    SharedPreferences speicher = await meinSpeicher;
    bool result = await speicher.setString(userName, neuesPasswort);
    return result;
  }

  // function to get the password from the local storage / shared preferences
  Future<String> getPassword() async {
    SharedPreferences speicher = await meinSpeicher;
    localPassword = speicher.getString(passwordKey) ?? "default";
    return localPassword;
  }

  Future<void> getUsernamesAndPasswords() async {
    SharedPreferences speicher = await meinSpeicher;
    Set<String> keys = speicher.getKeys();
    for (var element in keys) {
      localPassword = speicher.getString(passwordKey) ?? "default";
      localPasswords[element] = localPassword;
    }
  }

  Future<String> getPasswordForUserName({required String userName}) async {
    SharedPreferences speicher = await meinSpeicher;
    localPassword = speicher.getString(userName) ?? "noPassword";
    return localPassword;
  }

//#endregion

  SnackBar snackBarWithPasswordErrorMessage = SnackBar(
    content: Center(
      child: Text(
        "Falsches oder fehlendes Passwort",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ),
  );

  SnackBar snackBarWithUserNameErrorMessage = SnackBar(
    content: Center(
      child: Text(
        "Bitte Usernamen eingeben",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ),
  );

  @override
  void initState() {
    setPassword(neuesPasswort: "passwort");
    getPassword();
    setUserNameAndPassword(userName: "Thong", neuesPasswort: "Test");
    setUserNameAndPassword(userName: "Test", neuesPasswort: "passwort");
    getUsernamesAndPasswords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.blueGrey,
              padding: EdgeInsets.all(2.h),
              child: TextField(
                controller: myUserNameController,
                decoration: InputDecoration(
                  hintText: "UserName",
                  hintStyle: TextStyle(color: Colors.black45),
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              color: Colors.teal,
              padding: EdgeInsets.all(2.h),
              child: TextField(
                controller: myPasswordController,
                decoration: InputDecoration(
                    hintText: "Passwort",
                    hintStyle: TextStyle(color: Colors.black45),
                    // Button to change obscurity of the password
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: IconButton(
                          icon: Icon(Icons.visibility_off),
                          color: Colors.white,
                          onPressed: () => changeObscurity(),
                        ))),
                obscureText: isPasswordObscured,
                obscuringCharacter: "*",
                // besser keine Autokorrektur bei Passwörtern
                autocorrect: false,
                // damit die Passwörter bei der Angabe nicht in den Suggestions angezeigt werden
                enableSuggestions: false,
              ),
            ),
            SizedBox(height: 5.h),
            ElevatedButton(
              onPressed: () {
                String userName = myUserNameController.text;
                if (userName.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBarWithUserNameErrorMessage);
                }

                // falls das Passwort aus dem local storage
                // mit dem angegebenen Passwort übereinstimmt
                if (localPasswords[userName] == myPasswordController.text) {
                  // Navigiere zum To Do Screem
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ToDos(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBarWithPasswordErrorMessage);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

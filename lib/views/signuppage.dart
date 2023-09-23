import 'package:checkin/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:checkin/database/database.dart';
import 'package:pocketbase/pocketbase.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Sign up for a new account")),
      ),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Image.asset(
                'assets/icon.png',
                width: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  onChanged: (value) {
                    c.username_signup.value = value;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    c.password_signup.value = value;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    c.password_c_signup.value = value;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    c.email_signup.value = value;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () async {
                    try {
                      await database.signup(
                          email: c.email_signup.value,
                          emailVisibility: true,
                          password: c.password_signup.value,
                          passwordConfirm: c.password_c_signup.value,
                          username: c.username_signup.value);
                      Get.back();
                    } on ClientException catch (e) {
                      var resp = e.response;
                      Get.showSnackbar(
                        GetSnackBar(
                          title: 'Error',
                          message: resp['data'].toString(),
                          icon: const Icon(Icons.error, color: Colors.red),
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.app_registration_rounded)),
            ),
          ],
        ),
      ),
    );
  }
}

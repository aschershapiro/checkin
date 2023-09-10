import 'package:checkin/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:checkin/database/obx2pb.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Welcome to Checkin")),
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
                    c.username.value = value;
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
                    c.password.value = value;
                  },
                  onSubmitted: (value) async {
                    if (c.username.value != '') {
                      c.isLoading.value = true;
                      final authData = await pb.collection('users').authWithPassword(
                            c.username.value,
                            c.password.value,
                          );
                      c.isLoading.value = false;
                      if (pb.authStore.isValid) {
                        //Database.syncBox2Server(objectBox: objectBox, pocketBase: pb);
                        Database.syncServer2Box(objectBox: objectBox, pocketBase: pb);
                        Get.offAndToNamed('/todolist');
                      }
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () async {
                  c.isLoading.value = true;
                  final authData = await pb.collection('users').authWithPassword(
                        c.username.value,
                        c.password.value,
                      );
                  c.isLoading.value = false;
                  if (pb.authStore.isValid) {
                    //Database.syncBox2Server(objectBox: objectBox, pocketBase: pb);
                    Get.offAndToNamed('/todolist');
                  }
                },
                icon: Obx(() => c.isLoading.value ? const CircularProgressIndicator() : const Icon(Icons.login)),
                splashColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

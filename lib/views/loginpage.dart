import 'package:checkin/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:checkin/database/obx2pb.dart';
import 'package:pocketbase/pocketbase.dart';

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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () async {
                  try {
                    c.isLoading.value = true;
                    c.isSyncing.value = false;
                    final authData =
                        await pb.collection('users').authWithPassword(
                              c.username.value,
                              c.password.value,
                            );

                    if (pb.authStore.isValid) {
                      c.isSyncing.value = true;
                      await Database.initialSync(
                          objectBox: objectBox,
                          pocketBase: pb,
                          settings: set.value);
                      await c.init();
                      c.isSyncing.value = false;
                      c.isLoading.value = false;
                      Get.offAndToNamed('/todolist');
                    }
                  } on ClientException catch (e) {
                    var resp = e.response;

                    Get.showSnackbar(
                      GetSnackBar(
                        title: 'Error',
                        message: resp['message'].toString(),
                        icon: const Icon(Icons.error, color: Colors.red),
                        duration: const Duration(seconds: 4),
                      ),
                    );
                    c.isLoading.value = false;
                    c.isSyncing.value = false;
                  }
                },
                icon: Obx(() => c.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.login)),
                splashColor: Colors.blue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () async {
                    Get.toNamed('/signup');
                  },
                  child: const Text('Sign up for a new account.')),
            ),
            Obx(() => Visibility(
                  visible: c.isSyncing.value,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Syncing your data with cloud.'),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

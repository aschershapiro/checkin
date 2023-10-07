import 'package:checkin/main.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var pass = '';
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Checkin 0.1b\n${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} \nID: ${c.settings.value.userId}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('Log out'),
              leading: const Icon(Icons.logout),
              onTap: () {
                database.logout();
                Get.off(() => const LoginPage());
              },
            ),
            ListTile(
              title: const Text('Settings'),
              leading: const Icon(Icons.settings),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Center(child: Text("Welcome back!")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    pass = value;
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
                    if (pass == c.settings.value.password) {
                      c.isLoading.value = false;
                      Get.offAndToNamed('/todolist');
                    } else {
                      Get.showSnackbar(
                        const GetSnackBar(
                          title: 'Error',
                          message: "Incorrect Password!",
                          icon: Icon(Icons.error, color: Colors.red),
                          duration: Duration(seconds: 4),
                        ),
                      );
                      c.isLoading.value = false;
                    }
                  } on ClientException catch (e) {
                    var resp = e;

                    Get.showSnackbar(
                      GetSnackBar(
                        title: 'Error',
                        message: resp.toString(),
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
          ],
        ),
      ),
    );
  }
}

import 'package:checkin/main.dart';
import 'package:checkin/views/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var pass = '';
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Center(child: Text("welcomeBack".tr)),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          height: 200,
          child: Card(
            color: const Color.fromARGB(255, 211, 241, 255),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'password'.tr,
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
                            GetSnackBar(
                              title: 'error'.tr,
                              message: "incorrectPassword".tr,
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
                            title: 'error'.tr,
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
        ),
      ),
    );
  }
}

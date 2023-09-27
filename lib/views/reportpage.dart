import 'package:checkin/main.dart';
import 'package:checkin/models/reports.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:checkin/views/pichartwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    var reports = Reports();
    //reports.dailyReport(DateTime(1990), DateTime.now());
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
        toolbarHeight: 50,
        title: const Text('Reports'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400,
              decoration: BoxDecoration(color: Colors.green),
              height: 40,
              child: const Center(
                  child: Text(
                "Daily Plus Tasks",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),
            ),
            FutureBuilder(
              future: reports.dailyPlusReport(DateTime(1990), DateTime.now()),
              builder: (context, snapshot) {
                Widget child;
                if (snapshot.hasData) {
                  child = Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      height: snapshot.data!.length * 205,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) => PieChartWidget(
                            title: snapshot.data![index].title,
                            values: snapshot.data![index].values),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  child = const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  );
                } else {
                  child = const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return child;
              },
            ),
            Container(
              width: 400,
              decoration: BoxDecoration(color: Colors.red),
              height: 40,
              child: const Center(
                  child: Text(
                "Daily Plus Tasks",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),
            ),
            FutureBuilder(
              future: reports.dailyMinusReport(DateTime(1990), DateTime.now()),
              builder: (context, snapshot) {
                Widget child;
                if (snapshot.hasData) {
                  child = Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      height: snapshot.data!.length * 205,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) => PieChartWidget(
                            title: snapshot.data![index].title,
                            values: snapshot.data![index].values),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  child = const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  );
                } else {
                  child = const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return child;
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: c.pagecounter.value,
          onDestinationSelected: (value) {
            c.pagecounter.value = value;
            Get.toNamed(appRoutes[value].name);
          },
          destinations: const <Widget>[
            NavigationDestination(
                icon: Icon(Icons.checklist_outlined),
                selectedIcon: Icon(Icons.checklist),
                label: 'To Do'),
            NavigationDestination(
                icon: Icon(Icons.plus_one_outlined),
                selectedIcon: Icon(Icons.plus_one),
                label: 'Daily +'),
            NavigationDestination(
                icon: Icon(Icons.exposure_minus_1_outlined),
                selectedIcon: Icon(Icons.exposure_minus_1),
                label: 'Daily -'),
            NavigationDestination(
                icon: Icon(Icons.summarize_outlined),
                selectedIcon: Icon(Icons.summarize),
                label: 'Report'),
          ],
        ),
      ),
    );
  }
}

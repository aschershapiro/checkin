import 'package:checkin/views/dailyminuspage.dart';
import 'package:checkin/views/dailypluspage.dart';
import 'package:checkin/views/moodtrackerpage.dart';
import 'package:checkin/views/reportpage.dart';
import 'package:checkin/views/signuppage.dart';
import 'package:checkin/views/todolistpage.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> appRoutes = [
  GetPage(
    name: '/todolist',
    page: () => TodoListPage(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: '/dailyplus',
    page: () => const DailyPlusPage(),
    middlewares: [MyMiddelware()],
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: '/dailyminus',
    page: () => const DailyMinusPage(),
    middlewares: [MyMiddelware()],
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: '/mood',
    page: () => MoodTrackerPage(),
    middlewares: [MyMiddelware()],
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: '/report',
    page: () => ReportPage(),
    middlewares: [MyMiddelware()],
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: '/signup',
    page: () => const SignupPage(),
    middlewares: [MyMiddelware()],
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 200),
  ),
];

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    print(page?.name);
    return super.onPageCalled(page);
  }
}

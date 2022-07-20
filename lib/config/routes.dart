import 'package:flutter/material.dart';
import 'package:fox_fit/screens/additional/error.dart';
import 'package:fox_fit/screens/additional/update.dart';
import 'package:fox_fit/screens/auth/auth.dart';
import 'package:fox_fit/screens/home/general.dart';
import 'package:fox_fit/screens/more/pages/change_password/change_password.dart';
import 'package:fox_fit/screens/more/pages/coordinator/coordinator.dart';
import 'package:fox_fit/screens/more/pages/sale/sales.dart';
import 'package:fox_fit/screens/more/pages/sale/services.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/schedule.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/select_client/search_client.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/select_client/select_client.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/select_service.dart';
import 'package:fox_fit/screens/more/pages/schedule/pages/sign_up_training_session.dart';
import 'package:fox_fit/screens/more/pages/sleeping_customers/sleeping_customers.dart';
import 'package:fox_fit/screens/more/pages/trainer_stats/trainer_stats.dart';
import 'package:fox_fit/screens/more/pages/training/training.dart';
import 'package:fox_fit/screens/notifications/notifications.dart';
import 'package:fox_fit/screens/splash/splash_screen.dart';
import 'package:fox_fit/screens/trainer_choosing/trainer_choosing.dart';
import 'package:get/get.dart';

class Routes {
  static const String splash = '/splash_screen';
  static const String auth = '/auth';
  static const String general = '/general';
  static const String customerInformation = '/customer_information';
  static const String confirmation = '/confirmation';
  static const String trainerStats = '/trainerStats';
  static const String coordinator = '/coordinator';
  static const String trainerChoosing = '/trainer_choosing';
  static const String changePassword = '/change_password';
  static const String notifications = '/notifications';
  static const String sleepingCustomers = '/inactive_customers';
  static const String schedule = '/schedule';
  static const String signUpTrainingSession = '/sign_up_training_session';
  static const String selectClient = '/select_client';
  static const String searchClient = '/search_client';
  static const String selectService = '/select_service';
  static const String saleServices = '/sale_services';
  static const String sale = '/sale';
  static const String error = '/error';
  static const String update = '/update';
  static const String training = '/training';

  static List<GetPage<dynamic>> get getRoutes {
    return [
      _getPage(Routes.splash, () => const SpalshScreen()),
      _getPage(Routes.auth, () => const AuthPage()),
      _getPage(Routes.general, () => const General()),
      _getPage(
        Routes.trainerStats,
        () => const TrainerStatsPage(),
        transition: Transition.rightToLeft,
      ),
      _getPage(Routes.trainerChoosing, () => const TrainerChoosingPage()),
      _getPage(
        Routes.coordinator,
        () => const CoordinatorPage(),
        transition: Transition.rightToLeft,
      ),
      _getPage(
        Routes.changePassword,
        () => const ChangePasswordPage(),
        transition: Transition.rightToLeft,
      ),
      _getPage(Routes.notifications, () => const NotificationsPage()),
      _getPage(
        Routes.sleepingCustomers,
        () => const SleepingCustomersPage(),
        transition: Transition.rightToLeft,
      ),
      _getPage(
        Routes.schedule,
        () => const SchedulePage(),
        transition: Transition.rightToLeft,
      ),
      _getPage(Routes.selectClient, () => const SelectClientPage()),
      _getPage(Routes.searchClient, () => const SearchClient()),
      _getPage(Routes.selectService, () => const SelectServicePage()),
      _getPage(Routes.saleServices, () => const ServicesPage()),
      _getPage(
        Routes.sale,
        () => const CreateSalePage(),
        transition: Transition.rightToLeft,
      ),
      _getPage(Routes.error, () => const ErrorPage()),
      _getPage(Routes.update, () => const UpdatePage()),
      _getPage(Routes.training, () => const TrainingPage()),
      _getPage(Routes.signUpTrainingSession,
          () => const SignUpTrainingSessionPage()),
    ];
  }

  static GetPage<dynamic> _getPage(
    String routeName,
    Widget Function() page, {
    Transition transition = Transition.fadeIn,
  }) {
    return GetPage(
      name: routeName,
      transition: transition,
      curve: Curves.easeInOut,
      page: page,
    );
  }
}

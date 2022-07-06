import 'package:get_it/get_it.dart';
import 'package:push_service/push_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => PushService());
}

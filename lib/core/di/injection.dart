import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:to_do_list/core/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureInjection() async {
  await getIt.init();
}

import 'package:get_it/get_it.dart';
import 'package:tjw1/services/appconfig_service.dart';
import 'package:tjw1/services/navigator_service.dart';
import 'package:tjw1/services/network_service.dart';
import 'package:tjw1/services/token_manager.dart';

GetIt locator = GetIt.instance;

// PreferenceService get preferenceService => locator<PreferenceService>();
NavigationService get navigationService => locator<NavigationService>();

TokenManager get tokenService => locator<TokenManager>();
// AppConfigService get appConfigService => locator<AppConfigService>();
// DialogService get dialogService => locator<DialogService>();
// RememberPreference get rememberService => locator<RememberPreference>();
//
// EventBusService get eventBusService => locator<EventBusService>();

void setupLocator() {
  // locator.registerLazySingleton(() => FirebaseRemoteHelper());

  // locator.registerLazySingleton(() => PreferenceService());
  locator.registerLazySingleton(() => NetworkService());
  locator.registerLazySingleton<AppConfigService>(() => AppConfigService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => TokenManager());

  // locator.registerLazySingleton(() => PageStorageService());
  // locator.registerLazySingleton(() => PushNotificationService());
  // locator.registerLazySingleton(() => RememberPreference());
  // locator.registerLazySingleton(() => PermissionService());
  // locator.registerLazySingleton(() => UpdateChecker());
  // locator.registerLazySingleton(() => EventBusService());
  // locator.registerLazySingleton(() => AnalyticsService());
}

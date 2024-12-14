import 'features/authentication/blocs/password_reset_cubit/password_reset_cubit.dart';
import 'features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'features/pin_leagues/blocs/pinned_leagues_cubit/pinned_leagues_bloc.dart';
import 'features/authentication/repositories/authentication_repository.dart';
import 'presentation/screens/authentication/authentication_screen.dart';
import 'features/pin_leagues/repositories/pin_leagues_repository.dart';
import 'features/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'features/football_api/blocs/leagues_cubit/leagues_cubit.dart';
import 'features/football_api/repositories/fixtures_repository.dart';
import 'features/football_api/repositories/leagues_repository.dart';
import 'features/football_api/repositories/players_repository.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/notification/onesignal_notifications.dart';
import 'features/tips/repositories/tips_repository.dart';
import 'features/pin_leagues/models/pinned_league.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'presentation/screens/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/ads/ads_manager.dart';
import '_package_info/app_info.dart';
import 'package:nested/nested.dart';
import 'constants/constants.dart';
import 'constants/themes.dart';
import 'extensions/enums.dart';
import 'firebase_options.dart';
import 'dart:ui';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //Preserve splash screen until app is loaded
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Initialize OneSignal Notifications
  OneSignalNotification.initializeOneSignal();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  //Initialize ads
  await AdsManager.instance.initializeAds();

  await AppInfo.getPackageInfo();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  await Hive.initFlutter();
  Hive.registerAdapter(PinnedLeagueAdapter());
  await Hive.openBox<PinnedLeague>(Constants.pinnedLeaguesBox);

  //Remove splash screen when app is loaded
  FlutterNativeSplash.remove();

  runApp(
    MyApp(
      savedThemeMode: savedThemeMode,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseAnalytics analytics;
  late final NavigatorObserver observer;

  @override
  void initState() {
    super.initState();
    analytics = FirebaseAnalytics.instance;
    analytics.setAnalyticsCollectionEnabled(true);
    observer = FirebaseAnalyticsObserver(analytics: analytics);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: _repositoryProviders(),
      child: MultiBlocProvider(
        providers: _blocProviders(),
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          child: AdaptiveTheme(
            light: AppThemes.lightTheme,
            dark: AppThemes.darkTheme,
            initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
            debugShowFloatingThemeButton: false,
            builder: (theme, darkTheme) {
              return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, authState) {
                  final bool authenticated = authState.status == AuthenticationStatus.authenticated;

                  return MaterialApp(
                    navigatorObservers: [observer],
                    debugShowCheckedModeBanner: false,
                    title: AppInfo.name,
                    theme: theme,
                    darkTheme: darkTheme,
                    home: authenticated ? const HomeScreen() : const AuthenticationScreen(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

List<SingleChildWidget> _repositoryProviders() {
  return [
    RepositoryProvider(create: (context) => AuthenticationRepository()),
    RepositoryProvider(create: (context) => FixturesRepository()),
    RepositoryProvider(create: (context) => LeaguesRepository()),
    RepositoryProvider(create: (context) => PinLeaguesRepository()),
    RepositoryProvider(create: (context) => PlayersRepository()),
    RepositoryProvider(create: (context) => TipsRepository()),
  ];
}

List<SingleChildWidget> _blocProviders() {
  return [
    BlocProvider(
      create: (context) => AuthenticationBloc(
        context.read<AuthenticationRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => SignInBloc(
        context.read<AuthenticationRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => PasswordResetCubit(
        context.read<AuthenticationRepository>(),
      ),
    ),
    BlocProvider(
      lazy: false,
      create: (context) => LeaguesCubit(
        context.read<LeaguesRepository>(),
      )..getLeagues(),
    ),
    BlocProvider(
      lazy: false,
      create: (context) => PinnedLeaguesBloc(
        context.read<PinLeaguesRepository>(),
      ),
    )
  ];
}
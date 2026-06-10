import 'package:dar_plus_app/controller/local_provider.dart';
import 'package:dar_plus_app/controller/shared_prefs.dart';
import 'package:dar_plus_app/core/notifications/notification_service.dart';
import 'package:dar_plus_app/firebase_options.dart';
import 'package:dar_plus_app/screens/auth/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dar_plus_app/features/l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize SharedPreferences before anything that depends on it
  await SharedPerfManager().init();

  await NotificationService.initialize();

  runApp(ProviderScope(child: const MyApp()));
}

late AppLocalizations tr;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          builder: EasyLoading.init(
            builder: (context, child) {
              final isArabic = Directionality.of(context) == TextDirection.rtl;
              final baseTheme = ThemeData(
                scaffoldBackgroundColor: Colors.white,
              );
              final theme = baseTheme.copyWith(
                textTheme: isArabic
                    ? baseTheme.textTheme.apply(fontFamily: 'GESSSTwo')
                    : GoogleFonts.montserratTextTheme(baseTheme.textTheme),
              );
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                ),
                child: Theme(data: theme, child: child!),
              );
            },
          ),

          home: const SplashScreen(),
          onGenerateTitle: (context) {
            EasyLoading.instance
              ..indicatorWidget = const CircularProgressIndicator()
              ..backgroundColor = Colors.white
              ..loadingStyle = EasyLoadingStyle.dark
              ..indicatorColor = Colors.black;

            tr = AppLocalizations.of(context);

            // nav = NavigationManager(appRouter);
            return tr.hi;
          },
        );
      },
    );
  }
}

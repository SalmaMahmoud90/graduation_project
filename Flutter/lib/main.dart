
import 'package:a_tareqaak/presentation/cubit/profile/driver_profile_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:a_tareqaak/core/constants/app_theme.dart';
import 'package:a_tareqaak/core/helper/local_storage_helper.dart';
import 'package:a_tareqaak/core/l10n/app_localizations.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/routes/app_routes.dart';
import 'package:a_tareqaak/core/services/app_lifecycle_tracker.dart';
import 'package:a_tareqaak/core/services/app_services.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/core/utils/connection_network_service.dart';

import 'package:a_tareqaak/presentation/cubit/bottom_bar/bottom_bar_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/language/language_cubit.dart';


// مفتاح للتنقل من أي مكان بالتطبيق
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

// مفتاح لإظهار SnackBars ورسائل عامة
final GlobalKey<ScaffoldMessengerState>
    rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();


// ============================================
// Main
// ============================================
/* Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(
      initialLocale: Locale('ar'),
    ),
  );
}
 */
 Future<void> main() async {
  // تهيئة Flutter قبل أي await
  WidgetsFlutterBinding.ensureInitialized();

  // إجبار التطبيق على الوضع العمودي فقط
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  // تهيئة الخدمات (Hive - Firebase - DI ...)
  await AppServices.init();

  // تحميل اللغة المحفوظة مسبقاً
  final initialLocale = await _loadInitialLocale();

  // تشغيل التطبيق
  runApp(
    MyApp(
      initialLocale: initialLocale,
    ),
  );

  // مراقبة حالة الإنترنت
  ConnectionService().initialize(
    navigatorKey,
  );
}

 
// ============================================
// Root Widget
// ============================================

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.initialLocale,
  });

  // اللغة المحفوظة
  final Locale initialLocale;

  @override
  State<MyApp> createState() => _MyAppState();
}


// ============================================
// App State
// ============================================

class _MyAppState extends State<MyApp> {

  // Go Router
  late final GoRouter _router = GoRouter(
    routes: $appRoutes,
    navigatorKey: navigatorKey,
    debugLogDiagnostics: kDebugMode,

    // أول شاشة بالتطبيق
    initialLocation: SplashRoute().location,
  );

  @override
  void initState() {
    super.initState();

    // مراقبة دخول وخروج التطبيق للخلفية
    AppLifecycleTracker.instance.start();
  }

  @override
  void dispose() {
    // إلغاء المراقبة
    AppLifecycleTracker.instance.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        // ======================
        // Bottom Navigation Cubit
        // ======================
        BlocProvider<BottomBarCubit>(
          create: (_) => BottomBarCubit(),
          
        ),

        // ======================
        // Language Cubit
        // ======================
        BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit(
            initialLocale: widget.initialLocale,
          ),
        ),
   
       // ======================
        // Driver Profile Cubit
        // ======================
          BlocProvider<DriverProfileCubit>(
          create: (_) =>DriverProfileCubit(),
        ), 

      ],

      child: ScreenUtilInit(
        // المقاس المعتمد بالتصميم
        designSize: const Size(
          428,
          926,
        ),

        // دعم تقسيم الشاشة
        splitScreenMode: true,

        // تحسين النصوص
        minTextAdapt: true,

        // التأكد من معرفة أبعاد الشاشة
        ensureScreenSize: true,

        useInheritedMediaQuery: true,

        child: BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {

            return MaterialApp.router(

              // إزالة شعار Debug
              debugShowCheckedModeBanner: false,

              // مفتاح الرسائل العامة
              scaffoldMessengerKey:
                  rootScaffoldMessengerKey,

              // الوضع الافتراضي
              themeMode: ThemeMode.light,

              // الثيم الفاتح
              theme: AppTheme.lightTheme(
                locale.languageCode,
              ),

              // الثيم الداكن
              darkTheme: AppTheme.darkTheme(
                locale.languageCode,
              ),

              // اللغة الحالية
              locale: locale,

              // اللغات المدعومة
              supportedLocales:
                  AppLocalizations.supportedLocales,

              // ملفات الترجمة
              localizationsDelegates:
                  AppLocalizations.localizationsDelegates,

              // إعدادات التنقل
              routerConfig: _router,

              // Wrapper عام لكل الشاشات
              builder: (
                context,
                child,
              ) {
                return Container(
                  color: AppColors.backGround,
                  child: SafeArea(
                    top: false,
                    child: child!,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


// ============================================
// Load Saved Language
// ============================================

Future<Locale> _loadInitialLocale() async {

  // اللغة الافتراضية
  const fallback = Locale('ar');

  // Local Storage
  final storage =
      locator<LocalStorageHelper>();

  // قراءة اللغة المحفوظة
  final response = await storage.getValue(
    LanguageCubit.boxName,
    LanguageCubit.localeKey,
  );

  return response.fold(
    (_) => fallback,
    (value) {

      final code = value?.toString();

      if (
          code != null &&
          LanguageCubit.supportedLocales
              .contains(code)
      ) {
        return Locale(code);
      }

      return fallback;
    },
  );
}


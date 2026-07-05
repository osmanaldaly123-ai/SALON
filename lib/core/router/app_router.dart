import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/booking/presentation/pages/booking_success_page.dart';
import '../../features/booking/domain/entities/booking.dart';
import '../../features/deals/presentation/pages/deals_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/appointments_page.dart';
import '../../features/profile/presentation/pages/booking_history_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/reviews/presentation/pages/reviews_page.dart';
import '../../features/salons/presentation/pages/salon_detail_page.dart';
import '../../features/salons/presentation/pages/salons_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../di/injection.dart';
import '../services/guest_session_service.dart';
import 'page_transitions.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splash,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: const ForgotPasswordPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.salons,
        builder: (context, state) => SalonsPage(
          initialQuery: state.uri.queryParameters['q'],
        ),
      ),
      GoRoute(
        path: RouteNames.salonDetail,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return slidePage(
            key: state.pageKey,
            child: SalonDetailPage(salonId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.services,
        pageBuilder: (context, state) => slidePage(
          key: state.pageKey,
          child: ServicesPage(
            salonId: state.uri.queryParameters['salonId'],
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.deals,
        builder: (context, state) => DealsPage(
          salonId: state.uri.queryParameters['salonId'],
        ),
      ),
      GoRoute(
        path: RouteNames.booking,
        pageBuilder: (context, state) => slidePage(
          key: state.pageKey,
          child: BookingPage(
            salonId: state.uri.queryParameters['salonId'],
            serviceId: state.uri.queryParameters['serviceId'],
            salonName: state.uri.queryParameters['salonName'],
            serviceName: state.uri.queryParameters['serviceName'],
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.bookingSuccess,
        pageBuilder: (context, state) {
          final booking = state.extra as Booking?;
          return slidePage(
            key: state.pageKey,
            child: booking == null
                ? const BookingPage()
                : BookingSuccessPage(booking: booking),
          );
        },
      ),
      GoRoute(
        path: RouteNames.reviews,
        pageBuilder: (context, state) => slidePage(
          key: state.pageKey,
          child: ReviewsPage(
            salonId: state.uri.queryParameters['salonId'] ?? '',
            salonName: state.uri.queryParameters['salonName'],
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        pageBuilder: (context, state) {
          final user = state.extra as User?;
          return slidePage(
            key: state.pageKey,
            child: user == null
                ? const ProfilePage()
                : BlocProvider.value(
                    value: sl<ProfileCubit>(),
                    child: EditProfilePage(user: user),
                  ),
          );
        },
      ),
      GoRoute(
        path: RouteNames.appointments,
        builder: (context, state) => const AppointmentsPage(),
      ),
      GoRoute(
        path: RouteNames.bookingHistory,
        pageBuilder: (context, state) => slidePage(
          key: state.pageKey,
          child: const BookingHistoryPage(showBackButton: true),
        ),
      ),
      GoRoute(
        path: RouteNames.settings,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: const SettingsPage(),
        ),
      ),
    ],
  );
}

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final location = state.matchedLocation;
  final isAuthRoute = location == RouteNames.login ||
      location == RouteNames.register ||
      location == RouteNames.forgotPassword;
  final isSplash = location == RouteNames.splash;

  if (isSplash) return null;

  final isLoggedIn = await sl<AuthRepository>().isLoggedIn();
  final isGuest = sl<GuestSessionService>().isGuest;

  if (!isLoggedIn && !isGuest && !isAuthRoute) {
    return RouteNames.login;
  }

  if (isLoggedIn && isAuthRoute) {
    return RouteNames.home;
  }

  return null;
}

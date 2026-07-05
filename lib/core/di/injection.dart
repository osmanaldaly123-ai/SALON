import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/env.dart';
import '../firebase/firebase_auth_client.dart';
import '../firebase/firebase_initializer.dart';
import '../firebase/realtime_database_client.dart';
import '../network/api_client.dart';
import '../services/guest_session_service.dart';
import '../services/locale_service.dart';
import '../services/session_expired_handler.dart';
import '../../features/auth/data/datasources/auth_firebase_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/booking/data/datasources/booking_firebase_datasource.dart';
import '../../features/booking/data/datasources/booking_remote_datasource.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/deals/data/datasources/deals_firebase_datasource.dart';
import '../../features/deals/data/datasources/deals_remote_datasource.dart';
import '../../features/deals/data/repositories/deals_repository_impl.dart';
import '../../features/deals/domain/repositories/deals_repository.dart';
import '../../features/profile/data/datasources/profile_firebase_datasource.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/reviews/data/datasources/reviews_remote_datasource.dart';
import '../../features/reviews/data/repositories/reviews_repository_impl.dart';
import '../../features/reviews/domain/repositories/reviews_repository.dart';
import '../../features/salons/data/datasources/salons_firebase_datasource.dart';
import '../../features/salons/data/datasources/salons_remote_datasource.dart';
import '../../features/salons/data/repositories/salons_repository_impl.dart';
import '../../features/salons/domain/repositories/salons_repository.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/salons/presentation/bloc/salons_bloc.dart';
import '../../features/salons/presentation/cubit/salon_detail_cubit.dart';
import '../../features/services/presentation/cubit/services_cubit.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/cubit/booking_history_cubit.dart';
import '../../features/reviews/presentation/cubit/reviews_cubit.dart';
import '../../features/booking/presentation/cubit/booking_flow_cubit.dart';
import '../../features/deals/presentation/cubit/deals_cubit.dart';
import '../../features/services/data/datasources/services_firebase_datasource.dart';
import '../../features/services/data/datasources/services_remote_datasource.dart';
import '../../features/services/data/repositories/services_repository_impl.dart';
import '../../features/services/domain/repositories/services_repository.dart';
import '../../features/notifications/data/datasources/notification_remote_datasource.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/services/notification_service.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<GuestSessionService>(
    () => GuestSessionService(sharedPreferences),
  );
  await sl<GuestSessionService>().init();
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient(storage: sl()));

  if (Env.isFirebaseBackend) {
    await FirebaseInitializer.ensureInitialized();
    sl.registerLazySingleton<FirebaseAuthClient>(FirebaseAuthClient.new);
    sl.registerLazySingleton<RealtimeDatabaseClient>(
      RealtimeDatabaseClient.new,
    );
    sl.registerLazySingleton<SalonsFirebaseDataSource>(
      () => SalonsFirebaseDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<DealsFirebaseDataSource>(
      () => DealsFirebaseDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<ServicesFirebaseDataSource>(
      () => ServicesFirebaseDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthFirebaseDataSource(sl(), sl()),
    );
    sl.registerLazySingleton<BookingRemoteDataSource>(
      () => BookingFirebaseDataSource(sl(), sl()),
    );
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileFirebaseDataSource(sl(), sl()),
    );
  } else {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<BookingRemoteDataSource>(
      () => BookingRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl()),
    );
  }

  sl.registerLazySingleton<LocaleService>(() => LocaleService(sl()));

  // Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl(),
      sl(),
      sl.isRegistered<FirebaseAuthClient>() ? sl() : null,
    ),
  );
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl()));

  // Salons
  sl.registerLazySingleton<SalonsRemoteDataSource>(
    () => SalonsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SalonsRepository>(
    () => SalonsRepositoryImpl(
      sl(),
      sl.isRegistered<SalonsFirebaseDataSource>() ? sl() : null,
      sl(),
    ),
  );

  // Services
  sl.registerLazySingleton<ServicesRemoteDataSource>(
    () => ServicesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ServicesRepository>(
    () => ServicesRepositoryImpl(
      sl(),
      sl.isRegistered<ServicesFirebaseDataSource>() ? sl() : null,
      sl(),
    ),
  );

  // Deals
  sl.registerLazySingleton<DealsRemoteDataSource>(
    () => DealsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DealsRepository>(
    () => DealsRepositoryImpl(
      sl(),
      sl.isRegistered<DealsFirebaseDataSource>() ? sl() : null,
      sl(),
    ),
  );

  // Booking
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl()),
  );

  // Reviews
  sl.registerLazySingleton<ReviewsRemoteDataSource>(
    () => ReviewsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepositoryImpl(sl(), sl()),
  );

  // Profile
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  // Notifications
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(sl(), sl(), sl()),
  );

  // Presentation (Phase 3)
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(sl(), sl()),
  );
  sl.registerFactory<SalonsBloc>(() => SalonsBloc(sl()));
  sl.registerFactory<SalonDetailCubit>(
    () => SalonDetailCubit(sl(), sl(), sl()),
  );
  sl.registerFactory<ServicesCubit>(() => ServicesCubit(sl()));
  sl.registerFactory<DealsCubit>(() => DealsCubit(sl()));
  sl.registerFactory<BookingFlowCubit>(
    () => BookingFlowCubit(sl(), sl(), sl()),
  );
  sl.registerFactory<ReviewsCubit>(() => ReviewsCubit(sl()));
  sl.registerLazySingleton<ProfileCubit>(() => ProfileCubit(sl()));
  sl.registerFactory<BookingHistoryCubit>(
    () => BookingHistoryCubit(sl(), sl()),
  );

  sl.registerLazySingleton<SessionExpiredHandler>(
    () => SessionExpiredHandler(sl()),
  );
  sl<ApiClient>().onSessionExpired = () => sl<SessionExpiredHandler>().handle();
}

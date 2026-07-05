class ApiConstants {
  ApiConstants._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';

  // Salons
  static const String salons = '/salons';
  static String salonById(String id) => '/salons/$id';

  // Services
  static const String services = '/services';
  static String salonServices(String salonId) => '/salons/$salonId/services';

  // Deals
  static const String deals = '/deals';
  static String salonDeals(String salonId) => '/salons/$salonId/deals';

  // Bookings
  static const String bookings = '/bookings';
  static String bookingById(String id) => '/bookings/$id';

  // Reviews
  static const String reviews = '/reviews';
  static String salonReviews(String salonId) => '/salons/$salonId/reviews';

  // Profile
  static const String profile = '/user/profile';
  static const String bookingHistory = '/user/bookings';

  // Notifications
  static const String fcmToken = '/user/fcm-token';
}

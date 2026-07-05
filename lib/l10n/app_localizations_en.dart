// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Salon';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get home => 'Home';

  @override
  String get salons => 'Salons';

  @override
  String get services => 'Services';

  @override
  String get deals => 'Deals';

  @override
  String get booking => 'Book Appointment';

  @override
  String get reviews => 'Reviews';

  @override
  String get profile => 'Profile';

  @override
  String get bookingHistory => 'Booking History';

  @override
  String get logout => 'Logout';

  @override
  String get retry => 'Retry';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get noData => 'No data available';

  @override
  String get language => 'Language';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get welcomeSubtitle => 'Sign in to book your next appointment';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountSubtitle => 'Join us and discover the best salons';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get loginFailed => 'Login failed. Please check your credentials.';

  @override
  String get registerFailed => 'Registration failed. Please try again.';

  @override
  String get networkError =>
      'Could not reach the server. Check your internet or API URL.';

  @override
  String get invalidCredentials => 'Invalid email or password.';

  @override
  String get emailAlreadyExists => 'This email is already registered.';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get guestModeTitle => 'Guest mode';

  @override
  String get guestModeSubtitle =>
      'Browse only. Create an account to book and review.';

  @override
  String get guestActionBlocked => 'Account required';

  @override
  String get signInToContinue =>
      'Sign in or create an account to use this feature.';

  @override
  String get exitGuestMode => 'Exit guest mode';

  @override
  String get cancel => 'Cancel';

  @override
  String get phoneOptional => 'Phone (optional)';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get homeGreeting => 'Discover top salons';

  @override
  String get homeSubtitle => 'Book beauty services near you';

  @override
  String get searchSalons => 'Search salons...';

  @override
  String get featuredSalons => 'Featured Salons';

  @override
  String get hotDeals => 'Hot Deals';

  @override
  String get seeAll => 'See all';

  @override
  String get noSalons => 'No salons found';

  @override
  String get noServices => 'No services available';

  @override
  String get noDeals => 'No deals available';

  @override
  String get bookNow => 'Book Now';

  @override
  String get loadFailed => 'Failed to load data. Please try again.';

  @override
  String get selectService => 'Select a service';

  @override
  String get selectDateTime => 'Choose date and time';

  @override
  String get selectDate => 'Select date';

  @override
  String get availableSlots => 'Available time slots';

  @override
  String get noSlotsAvailable => 'No slots available for this date';

  @override
  String get bookingSummary => 'Booking summary';

  @override
  String get confirmBooking => 'Confirm booking';

  @override
  String get bookingConfirmed => 'Booking confirmed!';

  @override
  String get bookingConfirmedSubtitle =>
      'Your appointment has been scheduled successfully';

  @override
  String get backToHome => 'Back to home';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get notesHint => 'Any special requests...';

  @override
  String get price => 'Price';

  @override
  String get dateTime => 'Date & time';

  @override
  String get loading => 'Loading...';

  @override
  String get confirmingBooking => 'Confirming your booking...';

  @override
  String get selectSalonFirst => 'Please select a salon first';

  @override
  String get browseSalons => 'Browse salons';

  @override
  String get bookingFailed => 'Booking failed. Please try again.';

  @override
  String get noReviews => 'No reviews yet';

  @override
  String get writeReview => 'Write a review';

  @override
  String get yourRating => 'Your rating';

  @override
  String get reviewComment => 'Comment';

  @override
  String get reviewCommentHint => 'Share your experience...';

  @override
  String get submitReview => 'Submit review';

  @override
  String get reviewSubmitted => 'Thank you! Your review has been submitted.';

  @override
  String get submittingReview => 'Submitting your review...';

  @override
  String get reviewFailed => 'Failed to submit review. Please try again.';

  @override
  String reviewCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
      zero: 'No reviews',
    );
    return '$_temp0';
  }

  @override
  String get editProfile => 'Edit profile';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get updateFailed => 'Failed to update profile. Please try again.';

  @override
  String get upcomingBookings => 'Upcoming';

  @override
  String get pastBookings => 'Past';

  @override
  String get noUpcomingBookings => 'No upcoming appointments';

  @override
  String get noPastBookings => 'No past appointments';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String get cancelBookingConfirm =>
      'Are you sure you want to cancel this booking?';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancelFailed => 'Failed to cancel booking. Please try again.';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get settings => 'Settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAccount => 'Account';

  @override
  String get appVersion => 'App version';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and we\'ll send you a reset link';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get passwordResetSent => 'Reset link sent';

  @override
  String get passwordResetSentSubtitle =>
      'Check your email to reset your password';

  @override
  String get forgotPasswordFailed =>
      'Failed to send reset link. Please try again.';

  @override
  String get guestBannerTitle => 'You\'re browsing as a guest';

  @override
  String get guestBannerMessage =>
      'Sign in to book appointments and write reviews';

  @override
  String get sessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get apiNotConfiguredTitle => 'API not configured';

  @override
  String get apiNotConfiguredMessage =>
      'No backend URL is set yet. Use «Continue as guest» to browse, or ask your developer to set API_BASE_URL.';

  @override
  String get myAppointments => 'Appointments';

  @override
  String get bookNowShort => 'Book';

  @override
  String get account => 'Account';

  @override
  String get defaultCity => 'Riyadh';

  @override
  String get appointmentsGuestTitle => 'Sign in to view your appointments';

  @override
  String get appointmentsGuestSubtitle =>
      'Create an account or sign in to track upcoming and past bookings';

  @override
  String get searchExtended => 'Search salon, service, or location...';

  @override
  String get orDivider => 'or';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get passwordHint => '••••••••';

  @override
  String get createNewAccount => 'Create new account';
}

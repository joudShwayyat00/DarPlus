class ApiConstants {
  static const String baseUrl = "https://darplus.moneymaker-app.com/";
  static const String register = "api/register";
  static const String login = "api/login";
  static const String profile = '/api/profile';
  static const String logout = '/api/logout';
  static const String forgotPassword = "/api/forgot_password";
  static const String editProfile = "/api/edit_profile";
  static const String updatePassword = "/api/update_password";
  static const String uploadImage = '/api/user/upload_image';

  // Sliders endpoint (language suffix is provided as path param)
  static const String sliders = "api/sliders";
  // Categories endpoint (language suffix is provided as path param)
  static const String categories = "api/categories/all";
  // Assets endpoint (language suffix is provided as path param)
  static const String assets = "api/the_assets";
  // Top-rated assets endpoint (requires auth)
  static const String topRatedAssets = "api/asset/top_rated";
  // Single asset detail endpoint ({id}/{lang})
  static const String assetDetail = "api/the_asset";
  // Popular searches endpoint
  static const String popularSearches = "api/popular_searches";
  // Recent searches endpoint
  static const String recentSearches = "api/recent_searches";
  // Asset search endpoint (POST multipart, field: search)
  static const String search = "api/search";

  // Amenities endpoint (language suffix is provided as path param)
  static const String amenities = "api/amenities/all";
  // Add asset endpoint
  static const String addAsset = "api/the_assets/add";
  // Update / delete asset endpoints (owner, requires auth)
  static const String updateAsset = "api/the_assets/update";
  static const String deleteAsset = "api/the_assets/delete";
  // Book asset endpoint
  static const String bookAsset = "api/assets/book";
  // Asset availability calendar ({assetId})
  static const String assetCalendar = "api/calendar";
  // Block / unblock calendar dates (owner, multipart)
  static const String calendarBlock = "api/calendar/block";
  // My bookings (requires auth, filter by status)
  static const String myBookings = "api/my_bookings";
  // Add appointment endpoint
  static const String addAppointment = "api/appointments/add";
  // My requested appointments (requires auth)
  static const String myAppointments = "api/my_appointments";
  // Edit / delete appointment (pending only, requires auth)
  static const String editAppointment = "api/appointment/edit";
  static const String deleteAppointment = "api/appointment/delete";
  // Owner appointments with status filter (requires auth)
  static const String ownerAppointments = "api/owner/appointments";
  // Terms & conditions
  static const String termsAndConditions = "api/terms_and_conditions";
  // Privacy policy
  static const String privacyPolicy = "api/privacy_policy";
  // My assets (owner, requires auth)
  static const String myAssets = "api/my_assets";
  // Location
  static const String countries = "api/countries";
  static const String cities = "api/cities";
  static const String regions = "api/regions";
  // About us
  static const String aboutUs = "api/about_us";
  // Contact data
  static const String contactData = "api/contact_data";
  static const String contactUs = "api/contact_us";
  // Subscription packages
  static const String packages = "api/packages";
  // Notifications (language suffix is provided as path param)
  static const String notifications = "api/notifications";
  // FCM device token
  static const String updateDeviceToken = "api/fcm/update_device_token";
  // Rate asset
  static const String rateAsset = "api/rate";
  // Rate owner
  static const String rateOwner = "api/rating";
  // Filter endpoint (language suffix is provided as path param)
  static const String filter = "api/filter";
  // Owners list
  static const String owners = "api/owners/get";
  // Single owner profile ({id})
  static const String ownerDetail = "api/owners";

  static const String contentType = "application/json";
  static const String accept = "application/json";
}

class ApiHeaders {
  static const String contentTypeHeader = "Content-Type";
  static const String acceptHeader = "Accept";
  static const String authHeader = "Authorization";
}

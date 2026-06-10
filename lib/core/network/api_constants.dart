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
  // Book asset endpoint
  static const String bookAsset = "api/assets/book";
  // Add appointment endpoint
  static const String addAppointment = "api/appointments/add";
  // Terms & conditions
  static const String termsAndConditions = "api/terms_and_conditions";
  // Privacy policy
  static const String privacyPolicy = "api/privacy_policy";
  // My assets (owner, requires auth)
  static const String myAssets = "api/my_assets";

  static const String contentType = "application/json";
  static const String accept = "application/json";
}

class ApiHeaders {
  static const String contentTypeHeader = "Content-Type";
  static const String acceptHeader = "Accept";
  static const String authHeader = "Authorization";
}

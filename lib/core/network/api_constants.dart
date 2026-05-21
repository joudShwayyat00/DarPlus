class ApiConstants {
  static const String baseUrl = "https://darplus.moneymaker-app.com/";
  static const String register = "api/register";
  static const String login = "api/login";
  static const String profile = '/api/profile';
  static const String logout = '/api/logout';
  static const String forgotPassword = "/api/forgot_password";
  static const String editProfile = "/api/edit_profile";
  static const String updatePassword = "/api/update_password";

  // Sliders endpoint (language suffix is provided as path param)
  static const String sliders = "api/sliders";
  // Popular searches endpoint
  static const String popularSearches = "api/popular_searches";
  // Recent searches endpoint
  static const String recentSearches = "api/recent_searches";

  static const String contentType = "application/json";
  static const String accept = "application/json";
}

class ApiHeaders {
  static const String contentTypeHeader = "Content-Type";
  static const String acceptHeader = "Accept";
  static const String authHeader = "Authorization";
}

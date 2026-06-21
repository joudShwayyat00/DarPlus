import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get error_occurred;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get hi;

  /// No description provided for @where_real_estate_meets_elegance.
  ///
  /// In en, this message translates to:
  /// **'Where Real Estate Meets Elegance'**
  String get where_real_estate_meets_elegance;

  /// No description provided for @discover_manage_and_elevate_premium_properties.
  ///
  /// In en, this message translates to:
  /// **'Discover, manage, and elevate premium properties '**
  String get discover_manage_and_elevate_premium_properties;

  /// No description provided for @with_a_seamless_digital_experience.
  ///
  /// In en, this message translates to:
  /// **'with a seamless digital experience.'**
  String get with_a_seamless_digital_experience;

  /// No description provided for @showcase.
  ///
  /// In en, this message translates to:
  /// **'Showcase'**
  String get showcase;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// No description provided for @growth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get growth;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @continue_as_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continue_as_guest;

  /// No description provided for @premium_real_estate.
  ///
  /// In en, this message translates to:
  /// **'Premium Real Estate'**
  String get premium_real_estate;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcome_back;

  /// No description provided for @sign_in_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get sign_in_to_continue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get email_required;

  /// No description provided for @enter_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enter_valid_email;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @password_min_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get password_min_length;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @by_continuing_you_agree_to_our_terms_and_privacy.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms & Privacy.'**
  String get by_continuing_you_agree_to_our_terms_and_privacy;

  /// No description provided for @sign_up_to_get_started.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get sign_up_to_get_started;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @name_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get name_required;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get password_required;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @confirm_password_required.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirm_password_required;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @already_have_account_login.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get already_have_account_login;

  /// No description provided for @phone_is_required.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phone_is_required;

  /// No description provided for @digits_only.
  ///
  /// In en, this message translates to:
  /// **'Digits only'**
  String get digits_only;

  /// No description provided for @enter_valid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enter_valid_phone_number;

  /// No description provided for @browse_by_category.
  ///
  /// In en, this message translates to:
  /// **'Browse by Category'**
  String get browse_by_category;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @both.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get both;

  /// No description provided for @what_are_you_interested_in.
  ///
  /// In en, this message translates to:
  /// **'What are you interested in?'**
  String get what_are_you_interested_in;

  /// No description provided for @top_rated_owners.
  ///
  /// In en, this message translates to:
  /// **'Top Rated Owners'**
  String get top_rated_owners;

  /// No description provided for @all_owners.
  ///
  /// In en, this message translates to:
  /// **'All Owners'**
  String get all_owners;

  /// No description provided for @no_owners_found.
  ///
  /// In en, this message translates to:
  /// **'No owners found'**
  String get no_owners_found;

  /// No description provided for @owner_properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get owner_properties;

  /// No description provided for @owner_properties_count.
  ///
  /// In en, this message translates to:
  /// **'{count} properties'**
  String owner_properties_count(int count);

  /// No description provided for @no_owner_properties.
  ///
  /// In en, this message translates to:
  /// **'This owner has no listed properties yet'**
  String get no_owner_properties;

  /// No description provided for @top_rated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get top_rated;

  /// No description provided for @book_now.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get book_now;

  /// No description provided for @request_appointment.
  ///
  /// In en, this message translates to:
  /// **'Request Appointment'**
  String get request_appointment;

  /// No description provided for @see_all.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get see_all;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logout_confirm_message;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get change_language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @premium_member.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premium_member;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @password_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get password_updated_successfully;

  /// No description provided for @my_reservations.
  ///
  /// In en, this message translates to:
  /// **'My Reservations'**
  String get my_reservations;

  /// No description provided for @my_assets.
  ///
  /// In en, this message translates to:
  /// **'My Assets'**
  String get my_assets;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @get_help.
  ///
  /// In en, this message translates to:
  /// **'Get Help'**
  String get get_help;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get terms_and_conditions;

  /// No description provided for @i_agree_to_the.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get i_agree_to_the;

  /// No description provided for @and_the.
  ///
  /// In en, this message translates to:
  /// **' and the '**
  String get and_the;

  /// No description provided for @please_agree_to_terms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms and Conditions and Privacy Policy'**
  String get please_agree_to_terms;

  /// No description provided for @role_owner_or_agent.
  ///
  /// In en, this message translates to:
  /// **'Real Estate Owner / Agent'**
  String get role_owner_or_agent;

  /// No description provided for @role_user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get role_user;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @how_can_we_help_you.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get how_can_we_help_you;

  /// No description provided for @send_us_a_message.
  ///
  /// In en, this message translates to:
  /// **'Send us a message and we\'ll get back to you within 24 hours'**
  String get send_us_a_message;

  /// No description provided for @enter_your_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enter_your_name;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @enter_subject.
  ///
  /// In en, this message translates to:
  /// **'Enter subject'**
  String get enter_subject;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @describe_issue.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue or question...'**
  String get describe_issue;

  /// No description provided for @subject_is_required.
  ///
  /// In en, this message translates to:
  /// **'Subject is required'**
  String get subject_is_required;

  /// No description provided for @message_is_required.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get message_is_required;

  /// No description provided for @message_min_chars.
  ///
  /// In en, this message translates to:
  /// **'Message must be at least 10 characters'**
  String get message_min_chars;

  /// No description provided for @message_sent_successfully.
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully!'**
  String get message_sent_successfully;

  /// No description provided for @send_message.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get send_message;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @connect_with_us.
  ///
  /// In en, this message translates to:
  /// **'Connect With Us'**
  String get connect_with_us;

  /// No description provided for @follow_us_on_social_media.
  ///
  /// In en, this message translates to:
  /// **'Follow us on social media'**
  String get follow_us_on_social_media;

  /// No description provided for @our_story.
  ///
  /// In en, this message translates to:
  /// **'Our Story'**
  String get our_story;

  /// No description provided for @our_mission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get our_mission;

  /// No description provided for @our_vision.
  ///
  /// In en, this message translates to:
  /// **'Our Vision'**
  String get our_vision;

  /// No description provided for @our_values.
  ///
  /// In en, this message translates to:
  /// **'Our Values'**
  String get our_values;

  /// No description provided for @properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get properties;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @cities.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get cities;

  /// No description provided for @mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get mark_all_read;

  /// No description provided for @no_notifications_yet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get no_notifications_yet;

  /// No description provided for @will_notify_when_something_arrives.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you when something arrives'**
  String get will_notify_when_something_arrives;

  /// No description provided for @current_plan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get current_plan;

  /// No description provided for @choose_your_plan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get choose_your_plan;

  /// No description provided for @package_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get package_duration;

  /// No description provided for @package_days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get package_days;

  /// No description provided for @package_sale_listings.
  ///
  /// In en, this message translates to:
  /// **'Sale listings'**
  String get package_sale_listings;

  /// No description provided for @package_rent_listings.
  ///
  /// In en, this message translates to:
  /// **'Rent listings'**
  String get package_rent_listings;

  /// No description provided for @upgrade_plan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get upgrade_plan;

  /// No description provided for @cancel_subscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancel_subscription;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @elite.
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get elite;

  /// No description provided for @my_bookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get my_bookings;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @no_upcoming_reservations.
  ///
  /// In en, this message translates to:
  /// **'No upcoming reservations'**
  String get no_upcoming_reservations;

  /// No description provided for @no_past_reservations.
  ///
  /// In en, this message translates to:
  /// **'No past reservations'**
  String get no_past_reservations;

  /// No description provided for @no_bookings_found.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get no_bookings_found;

  /// No description provided for @no_bookings_for_status.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any {status} bookings yet'**
  String no_bookings_for_status(Object status);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search properties, locations...'**
  String get search_hint;

  /// No description provided for @recent_searches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recent_searches;

  /// No description provided for @popular_searches.
  ///
  /// In en, this message translates to:
  /// **'Popular Searches'**
  String get popular_searches;

  /// No description provided for @featured_properties.
  ///
  /// In en, this message translates to:
  /// **'Featured Properties'**
  String get featured_properties;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get highlights;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @contact_and_social.
  ///
  /// In en, this message translates to:
  /// **'Contact & Social'**
  String get contact_and_social;

  /// No description provided for @pool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get pool;

  /// No description provided for @bbq.
  ///
  /// In en, this message translates to:
  /// **'BBQ'**
  String get bbq;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get wifi;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @bedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get bedrooms;

  /// No description provided for @bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get bathrooms;

  /// No description provided for @price_label.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price_label;

  /// No description provided for @your_stay.
  ///
  /// In en, this message translates to:
  /// **'Your stay'**
  String get your_stay;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @price_summary.
  ///
  /// In en, this message translates to:
  /// **'Price summary'**
  String get price_summary;

  /// No description provided for @please_select_checkin_date.
  ///
  /// In en, this message translates to:
  /// **'Please select check-in date.'**
  String get please_select_checkin_date;

  /// No description provided for @max_rental_months_exceeded.
  ///
  /// In en, this message translates to:
  /// **'You can book up to {count} months for this property.'**
  String max_rental_months_exceeded(int count);

  /// No description provided for @max_rental_months_hint.
  ///
  /// In en, this message translates to:
  /// **'Maximum stay: {count} months (28–29 days each).'**
  String max_rental_months_hint(int count);

  /// No description provided for @please_accept_booking_policy.
  ///
  /// In en, this message translates to:
  /// **'Please accept the booking policy.'**
  String get please_accept_booking_policy;

  /// No description provided for @hotel_apartments.
  ///
  /// In en, this message translates to:
  /// **'Hotel Apartments'**
  String get hotel_apartments;

  /// No description provided for @family_apartments.
  ///
  /// In en, this message translates to:
  /// **'Family Apartments'**
  String get family_apartments;

  /// No description provided for @chalets.
  ///
  /// In en, this message translates to:
  /// **'Chalets'**
  String get chalets;

  /// No description provided for @farms.
  ///
  /// In en, this message translates to:
  /// **'Farms'**
  String get farms;

  /// No description provided for @luxury_living.
  ///
  /// In en, this message translates to:
  /// **'Luxury Living'**
  String get luxury_living;

  /// No description provided for @discover_premium_villas.
  ///
  /// In en, this message translates to:
  /// **'Discover premium villas & apartments'**
  String get discover_premium_villas;

  /// No description provided for @modern_apartments.
  ///
  /// In en, this message translates to:
  /// **'Modern Apartments'**
  String get modern_apartments;

  /// No description provided for @comfort_elegance.
  ///
  /// In en, this message translates to:
  /// **'Comfort & elegance in one place'**
  String get comfort_elegance;

  /// No description provided for @find_your_space.
  ///
  /// In en, this message translates to:
  /// **'Find Your Space'**
  String get find_your_space;

  /// No description provided for @homes_match_lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Homes that match your lifestyle'**
  String get homes_match_lifestyle;

  /// No description provided for @sample_sea_view_chalet.
  ///
  /// In en, this message translates to:
  /// **'Sea View Chalet'**
  String get sample_sea_view_chalet;

  /// No description provided for @sample_dead_sea.
  ///
  /// In en, this message translates to:
  /// **'Dead Sea'**
  String get sample_dead_sea;

  /// No description provided for @sample_family_apartments.
  ///
  /// In en, this message translates to:
  /// **'Family Apartments'**
  String get sample_family_apartments;

  /// No description provided for @near_beach.
  ///
  /// In en, this message translates to:
  /// **'Near Beach'**
  String get near_beach;

  /// No description provided for @youtube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get youtube;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @snapchat.
  ///
  /// In en, this message translates to:
  /// **'Snapchat'**
  String get snapchat;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @tiktok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get tiktok;

  /// No description provided for @not_provided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get not_provided;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get not_available;

  /// No description provided for @confirm_booking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirm_booking;

  /// No description provided for @booking_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get booking_confirmed;

  /// No description provided for @reservation_submitted.
  ///
  /// In en, this message translates to:
  /// **'Your reservation has been successfully submitted. You will receive a confirmation soon.'**
  String get reservation_submitted;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @check_in_date.
  ///
  /// In en, this message translates to:
  /// **'Check-in date'**
  String get check_in_date;

  /// No description provided for @select_date.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get select_date;

  /// No description provided for @check_out.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get check_out;

  /// No description provided for @nights.
  ///
  /// In en, this message translates to:
  /// **'Nights'**
  String get nights;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @one_night_tip.
  ///
  /// In en, this message translates to:
  /// **'Tip: One night = 1 ✅ (No need to pick time)'**
  String get one_night_tip;

  /// No description provided for @number_of_guests.
  ///
  /// In en, this message translates to:
  /// **'Number of guests'**
  String get number_of_guests;

  /// No description provided for @cash_on_arrival.
  ///
  /// In en, this message translates to:
  /// **'Cash on arrival'**
  String get cash_on_arrival;

  /// No description provided for @pay_when_checkin.
  ///
  /// In en, this message translates to:
  /// **'Pay when you check-in'**
  String get pay_when_checkin;

  /// No description provided for @credit_debit_card.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get credit_debit_card;

  /// No description provided for @pay_securely_online.
  ///
  /// In en, this message translates to:
  /// **'Pay securely online'**
  String get pay_securely_online;

  /// No description provided for @any_special_requests.
  ///
  /// In en, this message translates to:
  /// **'Any special requests?'**
  String get any_special_requests;

  /// No description provided for @example_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: Late check-in, extra towels...'**
  String get example_hint;

  /// No description provided for @nightly_price.
  ///
  /// In en, this message translates to:
  /// **'Nightly price'**
  String get nightly_price;

  /// No description provided for @currency_jod.
  ///
  /// In en, this message translates to:
  /// **'JOD'**
  String get currency_jod;

  /// No description provided for @per_night.
  ///
  /// In en, this message translates to:
  /// **' / night'**
  String get per_night;

  /// No description provided for @per_day.
  ///
  /// In en, this message translates to:
  /// **' / day'**
  String get per_day;

  /// No description provided for @per_month.
  ///
  /// In en, this message translates to:
  /// **' / month'**
  String get per_month;

  /// No description provided for @per_year.
  ///
  /// In en, this message translates to:
  /// **' / year'**
  String get per_year;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @service_fee.
  ///
  /// In en, this message translates to:
  /// **'Service fee'**
  String get service_fee;

  /// No description provided for @total_label.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total_label;

  /// No description provided for @booking_policy_consent.
  ///
  /// In en, this message translates to:
  /// **'I agree to the booking policy and cancellation terms.'**
  String get booking_policy_consent;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted. Are you sure you want to continue?'**
  String get delete_confirm_message;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @features_browse_properties.
  ///
  /// In en, this message translates to:
  /// **'Browse properties'**
  String get features_browse_properties;

  /// No description provided for @features_save_favorites.
  ///
  /// In en, this message translates to:
  /// **'Save favorites'**
  String get features_save_favorites;

  /// No description provided for @features_basic_search_filters.
  ///
  /// In en, this message translates to:
  /// **'Basic search filters'**
  String get features_basic_search_filters;

  /// No description provided for @all_basic_features.
  ///
  /// In en, this message translates to:
  /// **'All Basic features'**
  String get all_basic_features;

  /// No description provided for @priority_booking.
  ///
  /// In en, this message translates to:
  /// **'Priority booking'**
  String get priority_booking;

  /// No description provided for @exclusive_deals.
  ///
  /// In en, this message translates to:
  /// **'Exclusive deals'**
  String get exclusive_deals;

  /// No description provided for @no_ads.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get no_ads;

  /// No description provided for @renews_on.
  ///
  /// In en, this message translates to:
  /// **'Renews on'**
  String get renews_on;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @personal_concierge.
  ///
  /// In en, this message translates to:
  /// **'Personal concierge'**
  String get personal_concierge;

  /// No description provided for @vip_property_access.
  ///
  /// In en, this message translates to:
  /// **'VIP property access'**
  String get vip_property_access;

  /// No description provided for @cashback_rewards.
  ///
  /// In en, this message translates to:
  /// **'Cashback rewards'**
  String get cashback_rewards;

  /// No description provided for @free_cancellation.
  ///
  /// In en, this message translates to:
  /// **'Free cancellation'**
  String get free_cancellation;

  /// No description provided for @luxury_perks.
  ///
  /// In en, this message translates to:
  /// **'Luxury perks'**
  String get luxury_perks;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @check_in.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get check_in;

  /// No description provided for @check_out_label.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get check_out_label;

  /// No description provided for @notification_booking_confirmed_title.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed'**
  String get notification_booking_confirmed_title;

  /// No description provided for @notification_booking_confirmed_message.
  ///
  /// In en, this message translates to:
  /// **'Your booking for Luxury Villa Marina has been confirmed.'**
  String get notification_booking_confirmed_message;

  /// No description provided for @special_offer_title.
  ///
  /// In en, this message translates to:
  /// **'Special Offer'**
  String get special_offer_title;

  /// No description provided for @special_offer_message.
  ///
  /// In en, this message translates to:
  /// **'Get 20% off on your next booking! Limited time offer.'**
  String get special_offer_message;

  /// No description provided for @payment_received_title.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get payment_received_title;

  /// No description provided for @payment_received_message.
  ///
  /// In en, this message translates to:
  /// **'We\'ve received your payment of \$1,250 for your reservation.'**
  String get payment_received_message;

  /// No description provided for @review_request_title.
  ///
  /// In en, this message translates to:
  /// **'Review Request'**
  String get review_request_title;

  /// No description provided for @review_request_message.
  ///
  /// In en, this message translates to:
  /// **'How was your stay at Beach Resort Apartment? Leave a review!'**
  String get review_request_message;

  /// No description provided for @new_property_alert_title.
  ///
  /// In en, this message translates to:
  /// **'New Property Alert'**
  String get new_property_alert_title;

  /// No description provided for @new_property_alert_message.
  ///
  /// In en, this message translates to:
  /// **'A new luxury property matching your preferences is now available.'**
  String get new_property_alert_message;

  /// No description provided for @sample_cozy_nature_chalet.
  ///
  /// In en, this message translates to:
  /// **'Cozy Nature Chalet'**
  String get sample_cozy_nature_chalet;

  /// No description provided for @sample_family_chalet_with_pool.
  ///
  /// In en, this message translates to:
  /// **'Family Chalet with Pool'**
  String get sample_family_chalet_with_pool;

  /// No description provided for @sample_jerash.
  ///
  /// In en, this message translates to:
  /// **'Jerash'**
  String get sample_jerash;

  /// No description provided for @sample_aqaba.
  ///
  /// In en, this message translates to:
  /// **'Aqaba'**
  String get sample_aqaba;

  /// No description provided for @sample_sea_view_chalet_description.
  ///
  /// In en, this message translates to:
  /// **'Luxury sea view chalet located at the Dead Sea. Perfect for families and couples looking for relaxation, featuring a private pool and stunning sunset views.'**
  String get sample_sea_view_chalet_description;

  /// No description provided for @sample_cozy_nature_chalet_description.
  ///
  /// In en, this message translates to:
  /// **'A peaceful chalet surrounded by nature and forests. Ideal for weekend getaways, fresh air lovers, and small families.'**
  String get sample_cozy_nature_chalet_description;

  /// No description provided for @sample_family_chalet_description.
  ///
  /// In en, this message translates to:
  /// **'Spacious family chalet in Aqaba with a private pool and garden. Close to the beach and perfect for large families and gatherings.'**
  String get sample_family_chalet_description;

  /// No description provided for @our_story_body.
  ///
  /// In en, this message translates to:
  /// **'Dar Plus was founded with a vision to revolutionize the real estate experience. We believe that finding your perfect property should be an exciting journey, not a stressful task.\n\nOur platform connects you with premium properties across the region, offering a seamless booking experience with transparent pricing and exceptional service.'**
  String get our_story_body;

  /// No description provided for @our_mission_body.
  ///
  /// In en, this message translates to:
  /// **'To provide exceptional real estate services with integrity and innovation.'**
  String get our_mission_body;

  /// No description provided for @our_vision_body.
  ///
  /// In en, this message translates to:
  /// **'To be the leading real estate platform in the region.'**
  String get our_vision_body;

  /// No description provided for @value_trust_title.
  ///
  /// In en, this message translates to:
  /// **'Trust & Transparency'**
  String get value_trust_title;

  /// No description provided for @value_trust_desc.
  ///
  /// In en, this message translates to:
  /// **'We maintain honesty in all our dealings'**
  String get value_trust_desc;

  /// No description provided for @value_excellence_title.
  ///
  /// In en, this message translates to:
  /// **'Excellence'**
  String get value_excellence_title;

  /// No description provided for @value_excellence_desc.
  ///
  /// In en, this message translates to:
  /// **'We strive to exceed expectations'**
  String get value_excellence_desc;

  /// No description provided for @value_customer_title.
  ///
  /// In en, this message translates to:
  /// **'Customer First'**
  String get value_customer_title;

  /// No description provided for @value_customer_desc.
  ///
  /// In en, this message translates to:
  /// **'Your satisfaction is our priority'**
  String get value_customer_desc;

  /// No description provided for @value_innovation_title.
  ///
  /// In en, this message translates to:
  /// **'Innovation'**
  String get value_innovation_title;

  /// No description provided for @value_innovation_desc.
  ///
  /// In en, this message translates to:
  /// **'We embrace technology for better service'**
  String get value_innovation_desc;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Dar Plus. All rights reserved.'**
  String get copyright;

  /// No description provided for @terms_effective_date.
  ///
  /// In en, this message translates to:
  /// **'Effective Date: January 1, 2026'**
  String get terms_effective_date;

  /// No description provided for @terms_intro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Dar Plus. By accessing or using our application, you agree to be bound by these Terms and Conditions. Please read them carefully before using our services.'**
  String get terms_intro;

  /// No description provided for @terms_section_1_title.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get terms_section_1_title;

  /// No description provided for @terms_section_1_content.
  ///
  /// In en, this message translates to:
  /// **'By creating an account or using Dar Plus, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions and our Privacy Policy. If you do not agree to these terms, please do not use our services.\n\nThese terms apply to all users, including guests, registered users, and property owners.'**
  String get terms_section_1_content;

  /// No description provided for @terms_section_2_title.
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get terms_section_2_title;

  /// No description provided for @terms_section_2_content.
  ///
  /// In en, this message translates to:
  /// **'To use Dar Plus, you must:\n\n• Be at least 18 years of age\n• Have the legal capacity to enter into contracts\n• Provide accurate and complete registration information\n• Maintain the security of your account credentials\n\nWe reserve the right to refuse service to anyone for any reason at any time.'**
  String get terms_section_2_content;

  /// No description provided for @terms_section_3_title.
  ///
  /// In en, this message translates to:
  /// **'User Accounts'**
  String get terms_section_3_title;

  /// No description provided for @terms_section_3_content.
  ///
  /// In en, this message translates to:
  /// **'When you create an account:\n\n• You are responsible for maintaining account confidentiality\n• You must notify us of any unauthorized access\n• You are responsible for all activities under your account\n• You may not share your account with others\n• We may suspend or terminate accounts that violate our terms\n\nOne person may only maintain one account.'**
  String get terms_section_3_content;

  /// No description provided for @terms_section_4_title.
  ///
  /// In en, this message translates to:
  /// **'Booking and Reservations'**
  String get terms_section_4_title;

  /// No description provided for @terms_section_4_content.
  ///
  /// In en, this message translates to:
  /// **'When making a booking:\n\n• All bookings are subject to availability and confirmation\n• Prices are displayed in the local currency and may change\n• You agree to pay all charges at the prices in effect\n• Booking confirmations will be sent via email\n• You must review all booking details before confirming\n\nBookings are binding contracts between you and the property owner.'**
  String get terms_section_4_content;

  /// No description provided for @terms_section_5_title.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Policy'**
  String get terms_section_5_title;

  /// No description provided for @terms_section_5_content.
  ///
  /// In en, this message translates to:
  /// **'Cancellation terms vary by property:\n\n• Free cancellation may be available up to a specified time\n• Late cancellations may incur fees\n• No-shows may be charged the full booking amount\n• Refunds are processed within 5-10 business days\n• Force majeure events are handled case by case\n\nAlways review the specific cancellation policy before booking.'**
  String get terms_section_5_content;

  /// No description provided for @terms_section_6_title.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get terms_section_6_title;

  /// No description provided for @terms_section_6_content.
  ///
  /// In en, this message translates to:
  /// **'Payment terms:\n\n• We accept major credit cards and digital payment methods\n• Payment is required to confirm your booking\n• All transactions are processed securely\n• Prices include applicable taxes unless stated otherwise\n• Currency conversion fees may apply for international payments\n\nWe do not store complete credit card information on our servers.'**
  String get terms_section_6_content;

  /// No description provided for @terms_section_7_title.
  ///
  /// In en, this message translates to:
  /// **'User Conduct'**
  String get terms_section_7_title;

  /// No description provided for @terms_section_7_content.
  ///
  /// In en, this message translates to:
  /// **'You agree not to:\n\n• Use the service for any illegal purpose\n• Violate any applicable laws or regulations\n• Infringe on intellectual property rights\n• Post false, misleading, or defamatory content\n• Harass, abuse, or harm other users\n• Attempt to gain unauthorized access\n• Use automated systems to access the service\n• Interfere with the proper functioning of the service'**
  String get terms_section_7_content;

  /// No description provided for @terms_section_8_title.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property'**
  String get terms_section_8_title;

  /// No description provided for @terms_section_8_content.
  ///
  /// In en, this message translates to:
  /// **'All content on Dar Plus, including but not limited to text, graphics, logos, images, and software, is the property of Dar Plus or its content suppliers and is protected by intellectual property laws.\n\nYou may not reproduce, distribute, modify, or create derivative works without our express written permission.'**
  String get terms_section_8_content;

  /// No description provided for @terms_section_9_title.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get terms_section_9_title;

  /// No description provided for @terms_section_9_content.
  ///
  /// In en, this message translates to:
  /// **'Dar Plus provides the platform as-is without warranties of any kind. We are not liable for:\n\n• Actions or conduct of property owners or guests\n• Property conditions or amenities\n• Service interruptions or errors\n• Loss of data or unauthorized access\n• Any indirect, incidental, or consequential damages\n\nOur maximum liability shall not exceed the amount paid for the booking.'**
  String get terms_section_9_content;

  /// No description provided for @terms_section_10_title.
  ///
  /// In en, this message translates to:
  /// **'Dispute Resolution'**
  String get terms_section_10_title;

  /// No description provided for @terms_section_10_content.
  ///
  /// In en, this message translates to:
  /// **'In case of disputes:\n\n• First attempt to resolve through our customer service\n• Mediation may be offered for unresolved issues\n• Arbitration may be required for certain disputes\n• Legal proceedings shall be in courts of Jordan\n• These terms are governed by Jordanian law\n\nWe encourage open communication to resolve issues amicably.'**
  String get terms_section_10_content;

  /// No description provided for @terms_section_11_title.
  ///
  /// In en, this message translates to:
  /// **'Modifications'**
  String get terms_section_11_title;

  /// No description provided for @terms_section_11_content.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify these Terms and Conditions at any time. Changes will be effective upon posting to the application. Your continued use of the service after changes constitutes acceptance of the modified terms.\n\nWe will notify users of significant changes via email or in-app notification.'**
  String get terms_section_11_content;

  /// No description provided for @terms_section_12_title.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get terms_section_12_title;

  /// No description provided for @terms_section_12_content.
  ///
  /// In en, this message translates to:
  /// **'For questions about these Terms and Conditions:\n\nEmail: legal@darplus.com\nPhone: +962 7 9999 9999\nAddress: Amman, Jordan\n\nOur customer service team is available 24/7 to assist you.'**
  String get terms_section_12_content;

  /// No description provided for @terms_agreement_statement.
  ///
  /// In en, this message translates to:
  /// **'By using Dar Plus, you acknowledge that you have read and agree to these Terms and Conditions.'**
  String get terms_agreement_statement;

  /// No description provided for @privacy_last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: January 1, 2026'**
  String get privacy_last_updated;

  /// No description provided for @privacy_intro.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important to us. This Privacy Policy explains how Dar Plus collects, uses, discloses, and safeguards your information.'**
  String get privacy_intro;

  /// No description provided for @privacy_section_1_title.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get privacy_section_1_title;

  /// No description provided for @privacy_section_1_content.
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide directly to us, such as:\n\n• Personal Information: Name, email address, phone number, and profile picture.\n• Account Information: Username, password, and account preferences.\n• Payment Information: Credit card details and billing address (processed securely through our payment providers).\n• Property Preferences: Search history, saved properties, and booking preferences.\n• Communications: Messages, feedback, and support requests.'**
  String get privacy_section_1_content;

  /// No description provided for @privacy_section_2_title.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get privacy_section_2_title;

  /// No description provided for @privacy_section_2_content.
  ///
  /// In en, this message translates to:
  /// **'We use the information we collect to:\n\n• Provide, maintain, and improve our services\n• Process transactions and send related information\n• Send promotional communications (with your consent)\n• Respond to your comments, questions, and requests\n• Monitor and analyze trends, usage, and activities\n• Detect, investigate, and prevent fraudulent transactions\n• Personalize and improve your experience'**
  String get privacy_section_2_content;

  /// No description provided for @privacy_section_3_title.
  ///
  /// In en, this message translates to:
  /// **'Information Sharing'**
  String get privacy_section_3_title;

  /// No description provided for @privacy_section_3_content.
  ///
  /// In en, this message translates to:
  /// **'We may share your information with:\n\n• Property Owners: To facilitate bookings and communication\n• Service Providers: Who assist in our operations\n• Legal Authorities: When required by law or to protect rights\n• Business Partners: With your consent for joint offerings\n\nWe do not sell your personal information to third parties.'**
  String get privacy_section_3_content;

  /// No description provided for @privacy_section_4_title.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get privacy_section_4_title;

  /// No description provided for @privacy_section_4_content.
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate security measures to protect your information:\n\n• SSL encryption for data transmission\n• Secure servers and databases\n• Regular security audits\n• Limited access to personal information\n• Two-factor authentication options\n\nHowever, no method of transmission over the Internet is 100% secure.'**
  String get privacy_section_4_content;

  /// No description provided for @privacy_section_5_title.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get privacy_section_5_title;

  /// No description provided for @privacy_section_5_content.
  ///
  /// In en, this message translates to:
  /// **'You have the right to:\n\n• Access your personal information\n• Correct inaccurate data\n• Delete your account and data\n• Opt-out of marketing communications\n• Export your data\n• Restrict processing of your data\n\nTo exercise these rights, contact us at privacy@darplus.com'**
  String get privacy_section_5_content;

  /// No description provided for @privacy_section_6_title.
  ///
  /// In en, this message translates to:
  /// **'Cookies and Tracking'**
  String get privacy_section_6_title;

  /// No description provided for @privacy_section_6_content.
  ///
  /// In en, this message translates to:
  /// **'We use cookies and similar technologies to:\n\n• Remember your preferences\n• Analyze site traffic\n• Personalize content\n• Improve our services\n\nYou can control cookies through your browser settings.'**
  String get privacy_section_6_content;

  /// No description provided for @privacy_section_7_title.
  ///
  /// In en, this message translates to:
  /// **'Children\'s Privacy'**
  String get privacy_section_7_title;

  /// No description provided for @privacy_section_7_content.
  ///
  /// In en, this message translates to:
  /// **'Our services are not intended for children under 18. We do not knowingly collect personal information from children. If you believe we have collected information from a child, please contact us immediately.'**
  String get privacy_section_7_content;

  /// No description provided for @privacy_section_8_title.
  ///
  /// In en, this message translates to:
  /// **'Changes to This Policy'**
  String get privacy_section_8_title;

  /// No description provided for @privacy_section_8_content.
  ///
  /// In en, this message translates to:
  /// **'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the Last Updated date. Your continued use of our services after changes indicates acceptance of the updated policy.'**
  String get privacy_section_8_content;

  /// No description provided for @privacy_section_9_title.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get privacy_section_9_title;

  /// No description provided for @privacy_section_9_content.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about this Privacy Policy, please contact us:\n\nEmail: privacy@darplus.com\nPhone: +962 7 9999 9999\nAddress: Amman, Jordan'**
  String get privacy_section_9_content;

  /// No description provided for @sample_luxury_villa_marina.
  ///
  /// In en, this message translates to:
  /// **'Luxury Villa Marina'**
  String get sample_luxury_villa_marina;

  /// No description provided for @sample_penthouse_suite.
  ///
  /// In en, this message translates to:
  /// **'Penthouse Suite'**
  String get sample_penthouse_suite;

  /// No description provided for @sample_beach_resort_apartment.
  ///
  /// In en, this message translates to:
  /// **'Beach Resort Apartment'**
  String get sample_beach_resort_apartment;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get nav_explore;

  /// No description provided for @nav_bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get nav_bookings;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @filter_title.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filter_title;

  /// No description provided for @filter_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filter_reset;

  /// No description provided for @filter_apply_filters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get filter_apply_filters;

  /// No description provided for @filter_looking_to.
  ///
  /// In en, this message translates to:
  /// **'Looking To'**
  String get filter_looking_to;

  /// No description provided for @filter_owner_type.
  ///
  /// In en, this message translates to:
  /// **'Owner Type'**
  String get filter_owner_type;

  /// No description provided for @filter_individual_owner.
  ///
  /// In en, this message translates to:
  /// **'Individual Owner'**
  String get filter_individual_owner;

  /// No description provided for @filter_agency.
  ///
  /// In en, this message translates to:
  /// **'Agency'**
  String get filter_agency;

  /// No description provided for @filter_property_type.
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get filter_property_type;

  /// No description provided for @filter_house.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get filter_house;

  /// No description provided for @filter_villa.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get filter_villa;

  /// No description provided for @filter_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get filter_location;

  /// No description provided for @filter_select_country.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get filter_select_country;

  /// No description provided for @filter_select_city.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get filter_select_city;

  /// No description provided for @filter_select_area.
  ///
  /// In en, this message translates to:
  /// **'Select Area'**
  String get filter_select_area;

  /// No description provided for @filter_rental_period.
  ///
  /// In en, this message translates to:
  /// **'Rental Period'**
  String get filter_rental_period;

  /// No description provided for @for_sale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get for_sale;

  /// No description provided for @for_rent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get for_rent;

  /// No description provided for @all_assets.
  ///
  /// In en, this message translates to:
  /// **'All Properties'**
  String get all_assets;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get try_again;

  /// No description provided for @attributes.
  ///
  /// In en, this message translates to:
  /// **'Attributes'**
  String get attributes;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get no_results_found;

  /// No description provided for @no_more_results.
  ///
  /// In en, this message translates to:
  /// **'No more results'**
  String get no_more_results;

  /// No description provided for @check_out_date.
  ///
  /// In en, this message translates to:
  /// **'Check-out Date'**
  String get check_out_date;

  /// No description provided for @price_per_period.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price_per_period;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @upload_photo.
  ///
  /// In en, this message translates to:
  /// **'Photo uploaded successfully'**
  String get upload_photo;

  /// No description provided for @change_photo.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get change_photo;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get camera;

  /// No description provided for @add_new_asset.
  ///
  /// In en, this message translates to:
  /// **'Add New Asset'**
  String get add_new_asset;

  /// No description provided for @basic_information.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basic_information;

  /// No description provided for @name_english.
  ///
  /// In en, this message translates to:
  /// **'Name (English)'**
  String get name_english;

  /// No description provided for @name_arabic.
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic)'**
  String get name_arabic;

  /// No description provided for @description_english.
  ///
  /// In en, this message translates to:
  /// **'Description (English)'**
  String get description_english;

  /// No description provided for @description_arabic.
  ///
  /// In en, this message translates to:
  /// **'Description (Arabic)'**
  String get description_arabic;

  /// No description provided for @category_and_type.
  ///
  /// In en, this message translates to:
  /// **'Category & Type'**
  String get category_and_type;

  /// No description provided for @pricing_section.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing_section;

  /// No description provided for @rent_price.
  ///
  /// In en, this message translates to:
  /// **'Rent Price'**
  String get rent_price;

  /// No description provided for @rent_price_per_day.
  ///
  /// In en, this message translates to:
  /// **'Rent price per day'**
  String get rent_price_per_day;

  /// No description provided for @rent_price_per_month.
  ///
  /// In en, this message translates to:
  /// **'Rent price per month'**
  String get rent_price_per_month;

  /// No description provided for @rent_price_per_year.
  ///
  /// In en, this message translates to:
  /// **'Rent price per year'**
  String get rent_price_per_year;

  /// No description provided for @day_price.
  ///
  /// In en, this message translates to:
  /// **'Day price'**
  String get day_price;

  /// No description provided for @months_count.
  ///
  /// In en, this message translates to:
  /// **'Months Count'**
  String get months_count;

  /// No description provided for @years_count.
  ///
  /// In en, this message translates to:
  /// **'Years Count'**
  String get years_count;

  /// No description provided for @days_count.
  ///
  /// In en, this message translates to:
  /// **'Days Count'**
  String get days_count;

  /// No description provided for @location_section.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location_section;

  /// No description provided for @location_address_hint.
  ///
  /// In en, this message translates to:
  /// **'Location (address / area)'**
  String get location_address_hint;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @select_location.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get select_location;

  /// No description provided for @contact_section.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact_section;

  /// No description provided for @media_section.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media_section;

  /// No description provided for @video_url_optional.
  ///
  /// In en, this message translates to:
  /// **'Video URL (optional)'**
  String get video_url_optional;

  /// No description provided for @publish_asset.
  ///
  /// In en, this message translates to:
  /// **'Publish Asset'**
  String get publish_asset;

  /// No description provided for @select_category.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get select_category;

  /// No description provided for @please_select_category.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get please_select_category;

  /// No description provided for @please_select_image.
  ///
  /// In en, this message translates to:
  /// **'Please select an image'**
  String get please_select_image;

  /// No description provided for @please_select_country.
  ///
  /// In en, this message translates to:
  /// **'Please select a country'**
  String get please_select_country;

  /// No description provided for @please_select_city.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get please_select_city;

  /// No description provided for @please_select_region.
  ///
  /// In en, this message translates to:
  /// **'Please select a region'**
  String get please_select_region;

  /// No description provided for @field_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get field_required;

  /// No description provided for @valid_latitude.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid latitude (−90 to 90)'**
  String get valid_latitude;

  /// No description provided for @valid_longitude.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid longitude (−180 to 180)'**
  String get valid_longitude;

  /// No description provided for @asset_added_successfully.
  ///
  /// In en, this message translates to:
  /// **'Asset added successfully!'**
  String get asset_added_successfully;

  /// No description provided for @edit_asset.
  ///
  /// In en, this message translates to:
  /// **'Edit Asset'**
  String get edit_asset;

  /// No description provided for @update_asset.
  ///
  /// In en, this message translates to:
  /// **'Update Asset'**
  String get update_asset;

  /// No description provided for @asset_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Asset updated successfully!'**
  String get asset_updated_successfully;

  /// No description provided for @delete_asset.
  ///
  /// In en, this message translates to:
  /// **'Delete Asset'**
  String get delete_asset;

  /// No description provided for @delete_asset_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this asset? This action cannot be undone.'**
  String get delete_asset_confirm;

  /// No description provided for @asset_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Asset deleted successfully!'**
  String get asset_deleted_successfully;

  /// No description provided for @keep_image_hint.
  ///
  /// In en, this message translates to:
  /// **'Current image will be kept unless you choose a new one'**
  String get keep_image_hint;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @tap_add_property_image.
  ///
  /// In en, this message translates to:
  /// **'Tap to add property image'**
  String get tap_add_property_image;

  /// No description provided for @image_format_hint.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG — high quality'**
  String get image_format_hint;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @could_not_load_amenities.
  ///
  /// In en, this message translates to:
  /// **'Could not load amenities'**
  String get could_not_load_amenities;

  /// No description provided for @rate_asset.
  ///
  /// In en, this message translates to:
  /// **'Rate Property'**
  String get rate_asset;

  /// No description provided for @your_rating.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get your_rating;

  /// No description provided for @comment_optional.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get comment_optional;

  /// No description provided for @comment_hint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience...'**
  String get comment_hint;

  /// No description provided for @submit_rating.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get submit_rating;

  /// No description provided for @rating_saved.
  ///
  /// In en, this message translates to:
  /// **'Rating saved successfully'**
  String get rating_saved;

  /// No description provided for @please_select_rating.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get please_select_rating;

  /// No description provided for @login_to_rate.
  ///
  /// In en, this message translates to:
  /// **'Please log in to rate this property'**
  String get login_to_rate;

  /// No description provided for @tap_to_rate.
  ///
  /// In en, this message translates to:
  /// **'Tap to rate'**
  String get tap_to_rate;

  /// No description provided for @rate_your_stay.
  ///
  /// In en, this message translates to:
  /// **'Rate your stay'**
  String get rate_your_stay;

  /// No description provided for @how_was_your_experience.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get how_was_your_experience;

  /// No description provided for @rating_label_poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get rating_label_poor;

  /// No description provided for @rating_label_fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get rating_label_fair;

  /// No description provided for @rating_label_good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get rating_label_good;

  /// No description provided for @rating_label_great.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get rating_label_great;

  /// No description provided for @rating_label_excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get rating_label_excellent;

  /// No description provided for @rate_owner.
  ///
  /// In en, this message translates to:
  /// **'Rate Owner'**
  String get rate_owner;

  /// No description provided for @rate_this_owner.
  ///
  /// In en, this message translates to:
  /// **'Rate this owner'**
  String get rate_this_owner;

  /// No description provided for @login_to_rate_owner.
  ///
  /// In en, this message translates to:
  /// **'Please log in to rate this owner'**
  String get login_to_rate_owner;

  /// No description provided for @rating_score.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating_score;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

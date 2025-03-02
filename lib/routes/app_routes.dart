import 'package:blood_line_mobile/pages/FAQ_page.dart';
import 'package:blood_line_mobile/pages/appointment_page.dart';
import 'package:blood_line_mobile/pages/book_appointment_page.dart';
import 'package:blood_line_mobile/pages/contactUs_page.dart';
import 'package:blood_line_mobile/pages/donation_details.dart';
import 'package:blood_line_mobile/pages/donation_history_page.dart';
import 'package:blood_line_mobile/pages/event_details.dart';
import 'package:blood_line_mobile/pages/forgot_password.dart';
import 'package:blood_line_mobile/pages/home_page.dart';
import 'package:blood_line_mobile/pages/login_page.dart';
import 'package:blood_line_mobile/pages/logo_page.dart';
import 'package:blood_line_mobile/pages/main_screen.dart';
import 'package:blood_line_mobile/pages/map_page.dart';
import 'package:blood_line_mobile/pages/notification_page.dart';
import 'package:blood_line_mobile/pages/profile_page.dart';
import 'package:blood_line_mobile/pages/signup_page.dart';
import 'package:blood_line_mobile/pages/test.dart';
import 'package:blood_line_mobile/pages/volunteer_page.dart';
import 'package:blood_line_mobile/pages/welcome_page.dart';
import 'package:flutter/material.dart';

class AppRoutes{
  static String test = "/test";
  static String logoPage = "/logoPage";
  static String welcomePage = "/welcomePage";
  static String signUpPage = "/signUpPage";
  static String loginPage = "/loginPage";
  static String mainScreen = "/mainScreen";
  static String homePage = "/homePage";
  static String mapPage = "/mapPage";
  static String profilePage = "/profilePage";
  static String appointmentsPage = "/appointmentsPage";
  static String forgotpasswordPage="/forgotpasswordPage";
  static String notificationPage = "/notificationpage";
  static String event_detailsPage = "/event_detailsPage";
  static String volunteerPage = "/volunteerPage";
  static String bookAppointmentPage = "/BookAppointmentPage";
  static String faqPage = "/faqPage";
  static String contactusPage = "/contactusPage";
  static String donationDetails = "/donationDetails";
  static String donationHistoryPage = "/donationHistoryPage";



  static Map<String, WidgetBuilder> routes = {
    test: (context) => const Test(),
    logoPage: (context) => const LogoPage(),
    welcomePage: (context) => const WelcomePage(),
    signUpPage: (context) => const SignUpPage(),
    homePage: (context) => const HomePage(),
    mainScreen: (context) => const MainScreen(initialIndex: 0,),
    loginPage: (context) =>  const LoginPage(),
    mapPage: (context) => const MapPage(),
    profilePage: (context) => const ProfilePage(),
    appointmentsPage: (context) => const AppointmentPage(),
    forgotpasswordPage:(context) =>const ForgotPassword(),
    notificationPage : (context) =>NotificationPage(),
    event_detailsPage: (context) => const EventDetails(eventTitle: '', description: '', date: '', location: '', type: '',),
    volunteerPage:(context) => VolunteerPage(),
    bookAppointmentPage: (context) => const BookAppointmentPage(bloodBank: {}),
    faqPage: (context) => const FaqPage(),
    contactusPage: (context) => const ContactusPage(),
    donationDetails: (context) => const DonationDetails(),
    donationHistoryPage: (context) => const DonationHistoryPage(),

  };
}
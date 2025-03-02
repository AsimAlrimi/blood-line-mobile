import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/pages/donation_history_page.dart';
import 'package:blood_line_mobile/pages/main_screen.dart';
import 'package:blood_line_mobile/pages/notification_page.dart';
import 'package:blood_line_mobile/pages/volunteer_page.dart';
import 'package:blood_line_mobile/routes/app_routes.dart';
import 'package:blood_line_mobile/services/login_logic.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/Custom_Button_Home_page.dart';
import 'package:blood_line_mobile/widgets/custom_app_bar_home_page.dart';
import 'package:blood_line_mobile/widgets/faq_contactus_card.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String userName = 'User';

  @override
  void initState() {
    super.initState();
    _fetchDonorName();
   }

    Future<void> _fetchDonorName() async {
      final name = await LoginLogic.getDonorName(context);
      if (name != null) {
        setState(() {
          userName = name;
        });
      }
    }
  
  @override
  Widget build(BuildContext context) {
    
    //final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    return Scaffold(
      appBar:const CustomAppBarHomePage() ,
      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 60,
              width: screenWidth,
              color: AppTheme.lightgrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/ProfileImage.png"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Welcome,",style: AppTheme.instruction_14(color: AppTheme.black).copyWith(fontWeight: FontWeight.bold),),
                      Text(userName,style: AppTheme.instruction_14(color: AppTheme.black).copyWith(fontWeight: FontWeight.bold),)
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Event button
                      CustomButtonHomePage(
                        text: "Events",
                        image: "assets/images/Blood donation-pana.png",
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationPage(),)
                          );
                        },

                      ),
                      // Appointment button
                      CustomButtonHomePage(
                        onTap: () { 
                          Navigator.push( 
                            context, 
                            MaterialPageRoute( 
                              builder: (context) => const MainScreen(initialIndex: 1) // Pass the index for the Map page
                            ) 
                          ); 
                        },
                        text: "Appointment",
                        image: "assets/images/508867 1.png",
                      ),
                    ],
                  ),
                ),
                //Image.asset("assets/images/vecteezy_happy-people-holding-hands-isolated-on-white_16265580.jpg",),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // History Button
                      CustomButtonHomePage(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DonationHistoryPage(),
                            ),
                          );
                        },
                        text: "History",
                        image: "assets/images/png-transparent-computer-icons-web-browser-web-browsing-history-world-wide-web-text-desktop-wallpaper-internet-thumbnail-removebg-preview.png",
                        // image: "assets/images/png-transparent-computer-icons-user-story-computer-software-history-text-service-logo-thumbnail-removebg-preview.png",
                      ),
                      //Volunteer Button
                      CustomButtonHomePage(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VolunteerPage(),
                            ),
                          );
                        },
                        text: "Volunteer",
                        image: "assets/images/Team work-bro.png",
                      ),
                    ],
                  ),
                ),

                Image.asset("assets/images/vecteezy_happy-people-holding-hands-isolated-on-white_16265580.jpg",),
                
                FAQContactCard(onFAQTap: (){
                  Navigator.pushNamed(context, AppRoutes.faqPage);
                }, onContactUsTap: (){
                   Navigator.pushNamed(context, AppRoutes.contactusPage);
                }),

              ],
            )
          ],
        ),
      ),
    );
  }
}
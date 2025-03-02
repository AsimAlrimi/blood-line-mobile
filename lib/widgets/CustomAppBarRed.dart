import 'package:blood_line_mobile/main.dart';
import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget {
  final String viewType;
  final String? SecondLine ;
  final String Content ;
  final bool? NavBar;

   CustomAppBar({
    this.viewType = 'multiLine', // other than that either image or oneLine
    this.SecondLine ,
    required this.Content,
     this.NavBar,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (viewType!='multiLine'&&viewType!='oneLine')? 250 : 195 /*170*/,
      width: screenWidth,
      child: Stack(
        children: [
          Positioned(
            top: 60,
            child: Container(
                height: 130,
                width: screenWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppTheme.red
                ),
                padding: EdgeInsets.only(top: 38,left: 7),
                child: (viewType=='multiLine')? SizedBox(
                  width: screenWidth,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Content, style: AppTheme.instruction_24(color: AppTheme.white), ),
                        Text(SecondLine?? 'error input!',style: AppTheme.instruction_14(color: AppTheme.white),)
                      ],
                    ),
                  ),
                ) : (viewType=='oneLine')?
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 32,left: 7),),
                    Center(child: Text(Content, style: AppTheme.instruction_24(color: AppTheme.white), )),
                  ],
                )
                    : Container(
                )

            ),
          ),
          // the circle in left
          Positioned(
            top: screenWidth*0.13,
            left: -screenWidth*0.08,
            child: Container(
              height: 50,
              width: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xD3C52147) ,
                boxShadow: [BoxShadow(color:Color(0xFFC52147), spreadRadius: 0.5, blurRadius: 1)],
              ),
            ),
          ),
          // back button
          Positioned(
            top: screenWidth*0.13,
            left: screenWidth*0.08,
            child: Visibility(
              visible: (NavBar != true),
              // visible: (viewType!='image'&&viewType!='oneLine'),
              child: InkWell(
                onTap: ()=> Navigator.pop(context),
                child: Container(
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color:AppTheme.grey, spreadRadius: 0.5, blurRadius: 1)],
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.white
                    ),
                    child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 25,)
                ),
              ),
            ),
          ),

          // the circle in right
          Positioned(
            top: screenWidth*0.22,
            right: screenWidth*0.01,
            child: Container(
              height: 30,
              width: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFD34B6A) ,
                // boxShadow: [BoxShadow(color:AppTheme.grey, spreadRadius: 0.02, blurRadius: 0.5)],
                boxShadow: [BoxShadow(color:Color(0xFFD34B6A), spreadRadius: 0.5, blurRadius: 1)],
              ),
            ),
          ),

          // center circle
          Positioned(
            top: screenWidth*0.25,
            right: screenWidth*0.21,
            child: Container(
              height: 40,
              width: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xBFD34B6A) ,
                // boxShadow: [BoxShadow(color:AppTheme.grey, spreadRadius: 0.02, blurRadius: 0.5)],
                boxShadow: [BoxShadow(color:Color(0xBED34B6A), spreadRadius: 0.5, blurRadius: 1)],
              ),
            ),
          ),
          // top circle
          Positioned(
            top: screenWidth*0.15,
            right: screenWidth*0.13,
            child: Container(
              height: 30,
              width: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xE6922D45) ,
                // boxShadow: [BoxShadow(color:AppTheme.grey, spreadRadius: 0.02, blurRadius: 0.5)],
                boxShadow: [BoxShadow(color:Color(0xE6922D45), spreadRadius: 0.5, blurRadius: 1)],
              ),
            ),
          ),
          // Image Profile
          Positioned(
              top: 75,
              left: (screenWidth/2)-(170/2),
              child:Stack(
                children:[
                  Center(
                    child: Visibility(
                      visible: (viewType!='oneLine' && viewType!='multiLine'),
                      child: Container(
                        height: 150,
                        width: 168,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.red ,
                        ),
                      ),
                    ),
                  ),
                  Center(
                  child: Visibility(
                    visible: (viewType!='oneLine' && viewType!='multiLine'),
                    child: Image.asset("assets/images/ProfileImage.png",width: 170,),
                  ),
                ),
                ],
              ),
          ),
        ],
      ),
    );
  }
}

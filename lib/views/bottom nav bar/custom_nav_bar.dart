import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_icons.dart';
import 'package:qping/views/Message/message%20request/message_request_screen.dart';
import 'package:qping/views/Message/message_tab_bar_screen.dart';
import 'package:qping/views/discover/discover_screen.dart';
import 'package:qping/views/event/event_screen.dart';
import 'package:qping/views/notification/notification.dart';
import 'package:qping/views/profile/profile_screen.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => CustomNavBarState();
}

class CustomNavBarState extends State<CustomNavBar> {


  // List of screens for navigation
  final List<Widget> _screens = [
    const MessageTabBarScreen(),
    const DiscoverScreen(),
    const EventScreen(),
    const ProfileScreen(),
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Get.put(this);
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
          child: AppLogo(height:40.h),
        ),
        actions: [
          IconButton(onPressed: (){
            Get.to(()=>MessageRequestScreen());
          }, icon: Icon(Icons.message_outlined,size: 22.h,)),
          IconButton(onPressed: (){
            Get.to(()=> const NotificationScreen());
          }, icon: Icon(Icons.notifications_none_outlined,size: 22.h,))
        ],
      ),
      body: Center(
        child: _screens[_selectedIndex], // Display the selected screen
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.buttonSecondColor, // Light blue background color
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: onItemTapped,
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedLabelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
          items: [
            _buildNavItem(
              index: 0,
              icon: AppIcons.msg,
              selectedIcon: AppIcons.msgFill,
            ),
            _buildNavItem(
              index: 1,
              icon: AppIcons.discover,
              selectedIcon: AppIcons.discoverFill,
            ),
            _buildNavItem(
              index: 2,
              icon: AppIcons.event,
              selectedIcon: AppIcons.eventFill,
            ),
            _buildNavItem(
              index: 3,
              icon: AppIcons.person,
              selectedIcon: AppIcons.personFill,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required int index,
    required String icon,
    required String selectedIcon,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Image.asset(
            _selectedIndex == index ? selectedIcon : icon,
            height: 20.h,
          ),

          SizedBox(height: 8.h,),
          // Divider bar under the icon when selected

          if (_selectedIndex == index)
            Container(
              width: 35.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
      label: '', // Empty string as label
    );
  }
}

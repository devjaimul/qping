import 'package:flutter/material.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/views/event/event_screen.dart';
import 'package:qping/views/event/joined_event.dart';
import 'package:qping/views/event/my_events.dart';

class EventTabBarScreen extends StatelessWidget {
  const EventTabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.primaryColor,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: AppColors.primaryColor, // Active tab background color
                  borderRadius: BorderRadius.circular(20),
                ),
                tabs: [
                  // Messages Tab
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor, // Unselected tab border color
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text('Events',style: TextStyle(fontFamily: "Outfit"),),
                      ),
                    ),
                  ),
                  //Group Messages Tab
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor, // Unselected tab border color
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text('My Events',style: TextStyle(fontFamily: "Outfit"),),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor, // Unselected tab border color
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text('Joined',style: TextStyle(fontFamily: "Outfit"),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded TabBarView
            Expanded(
              child: TabBarView(
                children: [
              EventScreen(),
                  MyEvents(),
                  JoinEventScreen()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/views/Message/message_screen.dart';

class MessageTabBarScreen extends StatelessWidget {
  const MessageTabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                        child: Text('Messages',style: TextStyle(fontFamily: "Outfit"),),
                      ),
                    ),
                  ),
                  // Message Requests Tab
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor, // Unselected tab border color
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text('Message Requests',style: TextStyle(fontFamily: "Outfit")),
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
                  MessageScreen(),
                  MessageScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

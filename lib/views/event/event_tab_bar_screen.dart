import 'package:flutter/material.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/views/event/event_screen.dart';
import 'package:qping/views/event/joined_event.dart';
import 'package:qping/views/event/my_events.dart';

class EventTabBarScreen extends StatefulWidget {
  const EventTabBarScreen({super.key});

  @override
  _EventTabBarScreenState createState() => _EventTabBarScreenState();
}

class _EventTabBarScreenState extends State<EventTabBarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.primaryColor,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: AppColors.primaryColor, // Active tab background color
                  borderRadius: BorderRadius.circular(20),
                ),
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor, // Unselected tab border color
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text('Events',style: TextStyle(fontFamily: "Outfit")),
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
                        child: Text('My Events',style: TextStyle(fontFamily: "Outfit")),
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
                        child: Text('Joined',style: TextStyle(fontFamily: "Outfit")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  EventScreen(), // Show Events data
                  MyEvents(),    // Show My Events data
                  JoinEventScreen(), // Show Joined events data
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


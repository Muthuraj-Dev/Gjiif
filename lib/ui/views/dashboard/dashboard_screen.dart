import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/model/tjw/banner_event_response.dart';
import '../../../core/res/colors.dart';
import '../company/company_screen.dart';
import '../ebadge/ebadge_screen.dart';
import '../event_detail/event_detail_screen.dart';
import '../home/home_controller.dart';
import '../home/home_screen.dart';
import '../notification/notification_screen.dart';
import '../setting/setting_screen.dart';
import '../visitor/visitor_screen.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  // Initialize the controller
  final DashboardController controller = Get.put(DashboardController());

  final HomeController homeController = Get.find<HomeController>();

  // Define your screens for each tab here
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const VisitorScreen(),
    EbadgeScreen(eventTitle: "GJIIF"),
    const CompanyScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 130,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset('assets/GJIIF_Logo.png', height: 60, width: 60),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                Icons.notifications_none_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Get.to(() => NotificationScreen());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white, size: 30),
              onPressed: () {
                Get.to(() => SettingScreen());
              },
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Obx(() {
        return _widgetOptions.elementAt(controller.selectedIndex.value);
      }),
      floatingActionButton: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            useSafeArea: true,
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => SafeArea (
              child: DashboardBottomSheet(
                events: homeController.eventList,
              ),
            ),
          );
        },
        child: Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: ClipOval(child: Image.asset("assets/gjiif.gif")),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class DashboardBottomSheet extends StatelessWidget {
  DashboardBottomSheet({
    super.key,
    required this.events,
  });

  final List<EventsList> events;
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Upcoming Event",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.to(
                          () => EventDetailScreen(),
                      arguments: event.eventID,
                    );
                  },
                  child:  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColor.primary,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 1,
                          offset: const Offset(-2, 0),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 1,
                          offset: const Offset(-2, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    controller.getMonth(
                                      event.eventStartOn,
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w500,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                  Text(
                                    controller.getDay(
                                      event.eventStartOn,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight:
                                      FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    controller.getYear(
                                      event.eventStartOn,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w500,
                                      color: Color(0xff5C5C5C),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              const SizedBox(
                                height: 80,
                                child: VerticalDivider(),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColor.primary
                                              .withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 6),
                                        child: Text(
                                          event.editionNumber ??
                                              '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                            FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Text(
                                      event.eventName ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      event.editionTag ?? '',
                                      style: const TextStyle(
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Color(0xff5C5C5C),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons
                                              .location_on_outlined,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${event.venue!}, ${event.city}",
                                            overflow:
                                            TextOverflow
                                                .ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(Icons.arrow_forward_ios,size: 20,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavBar extends GetView<DashboardController> {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomAppBar(
        color: const Color(0xffF7D67A),
        elevation: 12,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: _item(
                  index: 0,
                  title: "Home",
                  icon: "assets/home_inactive.png",
                ),
              ),

              Expanded(
                child: _item(
                  index: 1,
                  title: "Employee",
                  icon: "assets/visitor_inactive.png",
                ),
              ),

              const SizedBox(width: 70),

              Expanded(
                child: _item(
                  index: 2,
                  title: "Registered",
                  icon: "assets/registered_inactive.png",
                ),
              ),

              Expanded(
                child: _item(
                  index: 3,
                  title: "Company",
                  icon: "assets/company_inactive.png",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({
    required int index,
    required String title,
    required String icon,
  }) {
    final selected = controller.selectedIndex.value == index;

    return InkWell(
      onTap: () => controller.onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 28,
            height: 28,
            color: selected ? AppColor.primary : Colors.black,
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? AppColor.primary : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

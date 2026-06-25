import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../core/data/default_event_details.dart';
import '../../../core/model/default_event_details.dart';
import '../../../core/res/colors.dart';
import '../ebadge/ebadge_screen.dart';

class RegisteredScreen extends StatefulWidget {
  const RegisteredScreen({super.key});

  @override
  State<RegisteredScreen> createState() => _RegisteredScreenState();
}

class _RegisteredScreenState extends State<RegisteredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Event",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),
              ListView.separated(
                itemCount: eventList.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  DefaultEventDetails data = eventList[index];
                  return InkWell (
                    onTap: (){
                      Get.to(() => EbadgeScreen(eventTitle: data.title,));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColor.tertiary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 120,
                              decoration: BoxDecoration(
                                color: AppColor.primary, // Background color
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                child: Image.asset(
                                  data.logo!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                data.title!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                softWrap: true,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.keyboard_arrow_right, size: 30),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10);
                },
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

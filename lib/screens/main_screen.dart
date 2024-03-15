import 'package:chat_app/components/custom_textfield.dart';
import 'package:chat_app/data/users_list.dart';
import 'package:chat_app/screens/user_a_screen.dart';
import 'package:chat_app/screens/user_b_screen.dart';
import 'package:chat_app/services/conversation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  void bottomSheet(BuildContext context, int currentIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24.w,
            24.h,
            24.w,
            (MediaQuery.of(context).viewInsets.bottom + 24.h),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create New Conversation',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Start new conversation with your friend',
                style: TextStyle(
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                hintText: 'Please enter conversation name',
                controller: controller,
              ),
              SizedBox(height: 24.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: TextButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      ConversationService.create(
                        controller.text,
                        listUsers[currentIndex].id,
                        listUsers[1 - currentIndex].id,
                      );
                      controller.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Create',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CHAT APP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      // screen content
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          UserAScreen(
            tabController: tabController,
          ),
          UserBScreen(
            tabController: tabController,
          ),
        ],
      ),

      // Navigation between user A & B
      bottomNavigationBar: AnimatedBuilder(
          animation: tabController,
          builder: (context, _) {
            return BottomNavigationBar(
              currentIndex: tabController.index,
              onTap: (index) {
                tabController.animateTo(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: listUsers[0].name,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: listUsers[1].name,
                ),
              ],
            );
          }),

      // Floating action button to start new conversation
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bottomSheet(context, tabController.index);
        },
        child: const Icon(
          Icons.add_rounded,
          size: 32,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/views/screens/student/read_assignment_slip.dart';
import 'package:trungtamgiasu/views/screens/student/read_receipt_form_screen.dart';

class AssignmentAndReceipt extends StatefulWidget {
  const AssignmentAndReceipt({super.key});

  @override
  State<AssignmentAndReceipt> createState() => _AssignmentAndReceiptState();
}

class _AssignmentAndReceiptState extends State<AssignmentAndReceipt>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  String? uid;
  void initState() {
    uid = loggedInUser.uid;
    super.initState();
    fetchData();
    _tabController = TabController(length: 2, vsync: this);
  }

  UserModel loggedInUser = UserModel();
  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Phiếu tiếp nhận & giao việc',
          style: Style.homeTitleStyle,
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          TabBar(
            unselectedLabelStyle: Style.homesubtitleStyle,
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                text: 'Phiếu tiếp nhận',
              ),
              Tab(
                text: 'Phiếu giao việc',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                ReadReceiptFormScreen(),
                ReadAssignmentSlip(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

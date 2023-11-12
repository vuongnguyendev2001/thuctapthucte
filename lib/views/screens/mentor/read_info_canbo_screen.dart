// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';

class ReadInformationCanBoScreen extends StatefulWidget {
  const ReadInformationCanBoScreen({super.key});

  @override
  State<ReadInformationCanBoScreen> createState() =>
      _ReadInformationCanBoScreenState();
}

class _ReadInformationCanBoScreenState
    extends State<ReadInformationCanBoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Xem thông tin cá nhân',
          style: Style.homeTitleStyle,
        ),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<UserModel>(
        future: getUserInfo(loggedInUser),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return Column(
              children: [
                const SizedBox(height: 5),
                Infor_Button(title: 'Gmail', information: user.email!),
                const Divider(),
                Infor_Button(title: 'Họ tên', information: user.userName!),
                const Divider(),
                Infor_Button(
                    title: 'Số điện thoại',
                    information: user.phoneNumberCanBo!),
                const Divider(),
              ],
            );
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }
}

class Infor_Button extends StatelessWidget {
  String title;
  String information;
  Infor_Button({
    Key? key,
    required this.title,
    required this.information,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              child: Text(
                title,
                style: Style.titlegreyStyle,
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: SizedBox(
                child: Text(
                  information,
                  style: Style.statusProductStyle,
                ),
              ))
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user/user_model.dart';

// Xác định trạng thái đăng nhập
UserModel loggedInUser = UserModel();
User? user = FirebaseAuth.instance.currentUser;

Future<UserModel> getUserInfo(UserModel currentUser) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("user").doc(user.uid).get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null) {
        final updatedUser = UserModel.fromMap(data);
        print(updatedUser.email);
        print(updatedUser.uid);
        return updatedUser;
      }
    }
  }
  // Trong trường hợp không tìm thấy thông tin người dùng hoặc có lỗi, bạn có thể xử lý tùy ý ở đây.
  // Không cần trả về giá trị ở đây.
  return currentUser;
}

// UserModel someFunction() async {
//   // Lấy thông tin người dùng và đợi cho dữ liệu được tải xuống
//   UserModel loggedInUser = await getUserInfo();

//   return loggedInUser;
// }

// Lấy thông tin người dùng
Future<UserModel> getUserInformation(String idUser) async {
  // TODO: implement initState
  FirebaseFirestore.instance.collection("user").doc(idUser).get().then((value) {
    loggedInUser = UserModel.fromMap(value.data());
  });
  return loggedInUser;
}

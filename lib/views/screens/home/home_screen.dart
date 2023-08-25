import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_image/flutter_svg_image.dart';
import 'package:get/get.dart';

import '../../../constants/color.dart';
import '../../../constants/currency_formatter.dart';
import '../../../constants/style.dart';
import '../../../controllers/route_manager.dart';
import '../../../services/login_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      // drawer: Column(children: []),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: background,
        title: Text(
          'Trang chủ',
          style: Style.homeStyle.copyWith(),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  await LoginService().handleGoogleSignOut();
                  await LoginService().handleSignOut();
                  await Get.offAllNamed(RouteManager.loginScreen);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 37,
                    width: 37,
                    color: cardsLite,
                    child: Image(
                      image: SvgImage.asset(
                        'assets/icon_svg/Buy.svg',
                        currentColor: blackColor,
                      ),
                      height: 18,
                      width: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 37,
                  width: 37,
                  color: cardsLite,
                  child: Image(
                    image: SvgImage.asset(
                      'assets/icon_svg/Notification.svg',
                      currentColor: blackColor,
                    ),
                    height: 18,
                    width: 18,
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phổ biến nhất',
                      style: Style.hometitleStyle,
                    ),
                    Image(
                      image: SvgImage.asset(
                        'assets/icon_svg/Vector.svg',
                        currentColor: blackColor,
                      ),
                      height: 18,
                      width: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 315,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        // height: 336,
                        width: 186,
                        color: cardsLite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              width: 186,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://trunghao.com/wp-content/uploads/2021/06/full-red-guppy.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Full Red',
                                    style: Style.titleStyle,
                                  ),
                                  const SizedBox(height: 7),
                                  Image(
                                    image: SvgImage.asset(
                                        'assets/icon_svg/Group 1.svg'),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    CurrencyFormatter.convertPrice(
                                      price: 100000,
                                    ),
                                    style: Style.priceStyle,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Tình trạng: Còn hàng',
                                    style: Style.statusProductStyle,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 20,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bán chạy nhất',
                      style: Style.hometitleStyle,
                    ),
                    Image(
                      image: SvgImage.asset(
                        'assets/icon_svg/Vector.svg',
                        currentColor: blackColor,
                      ),
                      height: 18,
                      width: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 315,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: 186,
                        color: cardsLite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              width: 186,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://trunghao.com/wp-content/uploads/2021/06/full-red-guppy.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Full Red',
                                    style: Style.titleStyle,
                                  ),
                                  const SizedBox(height: 7),
                                  Image(
                                    image: SvgImage.asset(
                                        'assets/icon_svg/Group 1.svg'),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    CurrencyFormatter.convertPrice(
                                      price: 100000,
                                    ),
                                    style: Style.priceStyle,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Tình trạng: Còn hàng',
                                    style: Style.statusProductStyle,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 20,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

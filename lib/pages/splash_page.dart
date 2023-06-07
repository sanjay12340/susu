import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:im_stepper/stepper.dart';
import 'package:susu/pages/home_page.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/mycontant.dart';
import 'package:susu/utils/storage_constant.dart';

import '../lab_pages/lab_home_page.dart';
import 'Login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  var box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    buildPage(
                      'assets/images/logo.png',
                      '',
                      '',
                    ),
                    buildPage(
                      '',
                      'Eat Well',
                      "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun'",
                    ),
                    buildPage('', 'Lab Verified Results',
                        "Don't worry, here at SuSu labs, We can help you determine and track your goals which are lab verified too"),
                    buildPage(
                      '',
                      'Improve Sleep Quality',
                      "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(4, (int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? myPrimaryColor
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ),
                if (_currentPage == 3)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 80.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.symmetric(horizontal: 32.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_currentPage == 3) {
                              box.write(StorageConstant.firstTimeUser, false);
                              Get.offAll(screenRoute());
                            }
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            ;
                          });
                        },
                        child: Text(_currentPage == 3 ? 'Get Started' : 'Next'),
                      ),
                    ),
                  ),
                if (_currentPage < 3)
                  Positioned(
                    right: 15,
                    bottom: 10.0,
                    child: CircleAvatar(
                      backgroundColor: myPrimaryColor,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_currentPage == 3) {
                                box.write(StorageConstant.firstTimeUser, false);
                                Get.offAll(screenRoute());
                              }
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              ;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: myWhite,
                          )),
                    ),
                  ),
                if (_currentPage != 0)
                  Positioned(
                    left: 15,
                    bottom: 10.0,
                    child: CircleAvatar(
                      backgroundColor: myPrimaryColor,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              ;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: myWhite,
                          )),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget screenRoute() {
    return (box.read(StorageConstant.isLoggedIn) == null ||
            !box.read(StorageConstant.isLoggedIn))
        ? LoginPage()
        : (box.read(StorageConstant.lab) != null &&
                box.read(StorageConstant.lab))
            ? LabHomePage()
            : HomePage();
  }

  Widget buildPage(String imageAsset, String title, String content) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageAsset.isNotEmpty)
            Image.asset(
              imageAsset,
              width: 200,
              height: 200,
            ),
          if (title.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (content.isNotEmpty)
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }
}

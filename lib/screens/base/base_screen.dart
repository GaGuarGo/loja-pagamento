import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/helpers/loading_widget.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/admin_orders/admin_orders_screen.dart';
import 'package:loja_virtual/screens/admin_users/admin_users_screen.dart';
import 'package:loja_virtual/screens/home/home_screen.dart';
import 'package:loja_virtual/screens/orders/orders_screen.dart';
import 'package:loja_virtual/screens/products/products_screen.dart';
import 'package:loja_virtual/screens/stores/store_screen.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors

Future<void> onBackgroundMessage(RemoteMessage message) async {
  print(message.notification!.title.toString());
}

class BaseScreen extends StatefulWidget {
  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    configFCM();
  }

  void configFCM() {
    final fcm = FirebaseMessaging.instance;

    fcm.requestPermission(provisional: true);

    FirebaseMessaging.onMessage.listen((notification) {
      showNotification(notification.notification!.title!,
          notification.notification?.body ?? "");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }

  void showNotification(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      titleColor: Theme.of(context).primaryColor,
      messageColor: Theme.of(context).primaryColor,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Colors.white,
      duration: Duration(seconds: 5),
      icon: Icon(
        Icons.shopping_cart_rounded,
        color: Theme.of(context).primaryColor,
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (BuildContext context) => PageManager(_pageController),
      child: Consumer<UserManager>(builder: (_, userManager, __) {
        return PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: userManager.loading
              ? [const LoadingWidget()]
              : [
                  const HomeScreen(),
                  const ProductsScreen(),
                  OrdersScreen(),
                  StoresScreen(),
                  if (userManager.adminEnabled) ...[
                    const AdminUsersScreen(),
                    AdminOrdersScreen(),
                  ]
                ],
        );
      }),
    );
  }
}

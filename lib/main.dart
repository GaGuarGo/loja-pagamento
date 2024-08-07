import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:loja_virtual/models/admin_users_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/orders_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/stores_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/models/user_order.dart';
import 'package:loja_virtual/screens/address/address_screen.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/checkout/checkout_screen.dart';
import 'package:loja_virtual/screens/confirmation/confirmation_screen.dart';
import 'package:loja_virtual/screens/edit_product/edit_product_screen.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';
import 'package:loja_virtual/screens/select_product/select_product_screen.dart';
import 'package:loja_virtual/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

import 'common/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

  // final response = await FirebaseFunctions.instance.httpsCallable('getUserData').call();
  // print(response.data);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => StoresManager(),
          lazy: true,
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (BuildContext context, userManager,
                  OrdersManager? orderManager) =>
              orderManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update:
              (BuildContext context, userManager, CartManager? cartManager) =>
                  cartManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, AdminUsersManager? adminUsersManager) =>
              adminUsersManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, AdminOrdersManager? adminOrdersManager) =>
              adminOrdersManager!..updateAdmin(userManager.adminEnabled),
        )
      ],
      child: MaterialApp(
        title: 'Loja do Gabriel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0.0,
            backgroundColor: Color.fromARGB(255, 4, 125, 141),
          ),
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (context) => LoginScreen());
            case '/signup':
              return MaterialPageRoute(builder: (context) => SignUpScreen());
            case '/cart':
              return MaterialPageRoute(
                builder: (context) => const CartScreen(),
                settings: settings,
              );
            case '/address':
              return MaterialPageRoute(
                  builder: (context) => const AddressScreen());
            case '/edit_product':
              return MaterialPageRoute(
                  builder: (context) =>
                      EditProductScreen(settings.arguments as Product?));
            case '/select_product':
              return MaterialPageRoute(
                  builder: (context) => SelectProductScreen());
            case '/product':
              return MaterialPageRoute(
                  builder: (context) => ProductScreen(
                        product: settings.arguments as Product,
                      ));
            case '/checkout':
              return MaterialPageRoute(builder: (context) => CheckoutScreen());
            case '/confirmation':
              return MaterialPageRoute(
                  builder: (context) => ConfirmationScreen(
                        order: settings.arguments as UserOrder,
                      ));
            case '/base':
            default:
              return MaterialPageRoute(
                builder: (context) => BaseScreen(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}

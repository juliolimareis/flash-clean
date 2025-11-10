import 'package:get/get.dart';
import 'package:flash_clean/pages/init.page.dart';
import 'package:flash_clean/pages/home/home.page.dart';
import 'package:flash_clean/pages/login/login.page.dart';

final routes = [
  GetPage(name: '/', page: () => InitPage()),
  GetPage(name: '/login', page: () => LoginPage()),
  GetPage(name: '/home', page: () => HomePage()),
  // Rota de exemplo com parâmetro
  // GetPage(name: '/profile/:user', page: () => Scaffold()),
];

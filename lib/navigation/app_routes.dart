import 'package:calculators/calculators/basic_calc/screens/calculator_screen.dart';
import 'package:calculators/calculators/health/bmi/screens/bmi_screen.dart';
import 'package:calculators/calculators/ip/IPv4/screens/ipv4_address_screen.dart';
import 'package:flutter/widgets.dart';

abstract final class AppRoutes {
  static const String home = '/';
  static const String bmi = '/bmi';
  static const String ipv4Address = '/ip/ipv4/address';

  static const String initialRoute = home;

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const CalculatorScreen(),
    bmi: (context) => const BmiScreen(),
    ipv4Address: (context) => const Ipv4AddressScreen(),
  };
}


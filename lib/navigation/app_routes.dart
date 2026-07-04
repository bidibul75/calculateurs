import 'package:calculators/calculators/basic_calc/screens/calculator_screen.dart';
import 'package:calculators/calculators/health/bmi/screens/bmi_screen.dart';
import 'package:calculators/calculators/conversions/temperature/screens/temperature_screen.dart';
import 'package:calculators/calculators/ip/IPv4/screens/ipv4_address_screen.dart';
import 'package:calculators/calculators/ip/IPv4/screens/ipv4_supernet_screen.dart';
import 'package:calculators/calculators/ip/IPv6/screens/ipv6_address_screen.dart';
import 'package:calculators/calculators/ip/IPv6/screens/ipv6_supernet_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class AppRoutes {
  static const String home = '/';
  static const String bmi = '/bmi';
  static const String temperature = '/temperature';
  static const String ipv4Address = '/ip/ipv4/address';
  static const String ipv4Supernet = '/ip/ipv4/supernet';
  static const String ipv6Address = '/ip/ipv6/address';
  static const String ipv6Supernet = '/ip/ipv6/supernet';

  static const String initialRoute = home;
  static const String _lastRoutePreferenceKey = 'navigation.lastRoute';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const CalculatorScreen(),
    bmi: (context) => const BmiScreen(),
    temperature: (context) => const TemperatureScreen(),
    ipv4Address: (context) => const Ipv4AddressScreen(),
    ipv4Supernet: (context) => const Ipv4SupernetScreen(),
    ipv6Address: (context) => const Ipv6AddressScreen(),
    ipv6Supernet: (context) => const Ipv6SupernetScreen(),
  };

  static Future<String> resolveInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRoute = prefs.getString(_lastRoutePreferenceKey);
    return routes.containsKey(savedRoute) ? savedRoute! : initialRoute;
  }

  static Future<void> saveLastRoute(String routeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRoutePreferenceKey, routeName);
  }
}

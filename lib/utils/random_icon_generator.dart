import 'package:flutter/material.dart';
import 'dart:math';

class RandomIcon extends StatefulWidget {
  @override
  _RandomIconState createState() => _RandomIconState();
}

class _RandomIconState extends State<RandomIcon> {
  final List<IconData> allIcons = [
    Icons.ac_unit_outlined,
    Icons.access_alarm_outlined,
    Icons.access_time_outlined,
    Icons.account_balance_outlined,
    Icons.ad_units_outlined,
    Icons.add_a_photo_outlined,
    Icons.airplanemode_active_outlined,
    Icons.battery_alert_outlined,
    Icons.beach_access_outlined,
    Icons.business_center_outlined,
    Icons.cake_outlined,
    Icons.call_outlined,
    Icons.camera_outlined,
    Icons.dangerous_outlined,
    Icons.dark_mode_outlined,
    Icons.directions_bike_outlined,
    Icons.eco_outlined,
    Icons.face_outlined,
    Icons.favorite_outline,
    Icons.g_translate_outlined,
    Icons.handyman_outlined,
    Icons.holiday_village_outlined,
    Icons.image_outlined,
    Icons.kayaking_outlined,
    Icons.light_mode_outlined,
    Icons.mail_outline,
    Icons.map_outlined,
    Icons.network_wifi_outlined,
    Icons.outdoor_grill_outlined,
    Icons.palette_outlined,
    Icons.party_mode_outlined,
    Icons.quiz_outlined,
    Icons.radio_outlined,
    Icons.sailing_outlined,
    Icons.train_outlined,
    Icons.usb_outlined,
    Icons.vaccines_outlined,
    Icons.wallpaper_outlined,
    Icons.yard_outlined,
    Icons.zoom_in_outlined,
    Icons.zoom_out_outlined,
  ];

  late IconData randomIcon;
  late Color randomColor;

  @override
  void initState() {
    super.initState();
    generateRandomIcon();
  }

  void generateRandomIcon() {
    final random = Random();
    setState(() {
      randomIcon = allIcons[random.nextInt(allIcons.length)];
      randomColor = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      randomIcon,
      size: 40,
      color: randomColor,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> transactionsData = [
  {
    'icon': const FaIcon(FontAwesomeIcons.burger, color: Colors.white,),
    'color': Colors.yellow[700],
    'name': 'Food',
    'totalAmount': '-\$45.00',
    'date': 'Today',
  },
  {
    'icon': const FaIcon(FontAwesomeIcons.bagShopping, color: Colors.white,),
    'color': Colors.purple[700],
    'name': 'Shopping',
    'totalAmount': '-\$245.00',
    'date': 'Today',
  },
  {
    'icon': const FaIcon(FontAwesomeIcons.heartCircleCheck, color: Colors.white,),
    'color': Colors.green[700],
    'name': 'Health',
    'totalAmount': '-\$145.00',
    'date': 'Yesterday',
  },
  {
    'icon': const FaIcon(FontAwesomeIcons.plane, color: Colors.white,),
    'color': Colors.blue[700],
    'name': 'Travel',
    'totalAmount': '-\$1245.00',
    'date': 'Today',
  },
  {
    'icon': const FaIcon(FontAwesomeIcons.star, color: Colors.white,),
    'color': Colors.orange[700],
    'name': 'Others',
    'totalAmount': '-\$1245.00',
    'date': 'Today',
  },
  
];

import 'package:flutter/material.dart';

List<({Color color, String colorName})> colorsRecord =const [
  (color: Colors.red, colorName: 'Red'),
  (color: Colors.blue, colorName: 'Blue'),
  (color: Colors.brown, colorName: 'Brown'),
  (color: Colors.black, colorName: 'Black'),
  (color: Colors.grey, colorName: 'Grey'),
  (color:  Color.fromARGB(255, 223, 223, 223), colorName: 'White'),
  (color: Colors.yellow, colorName: 'Yellow'),
  (color: Colors.pink, colorName: 'Pink'),
  (color: Colors.indigo, colorName: 'Indigo'),
  (color: Colors.purple, colorName: 'Purple'),
  (color: Colors.orange, colorName: 'Orange'),
  (color: Colors.green, colorName: 'Green'),
  (color: Colors.teal, colorName: 'Teal'),
  (color: Colors.deepPurple, colorName: 'Deep purple'),
];

({Color color, String colorName}) getColors(String colorName){

switch (colorName) {
  case 'Red':
    return const (color: Colors.red, colorName: 'Red');
    case 'Blue':
    return const (color: Colors.blue, colorName: 'Blue');
    case 'Brown':
    return const (color: Colors.brown, colorName: 'Brown');
    case 'Black':
    return const (color: Colors.black, colorName: 'Black');
    case 'White':
    return const (color:  Color.fromARGB(255, 223, 223, 223), colorName: 'White');
    case 'Pink':
    return const (color: Colors.pink, colorName: 'Pink');
    case 'Yellow':
    return const (color: Colors.yellow, colorName: 'Yellow');
    case 'Indigo':
    return const (color: Colors.indigo, colorName: 'Indigo');
    case 'Purple':
    return const (color: Colors.purple, colorName: 'Purple');
    case 'Orange':
    return const (color: Colors.orange, colorName: 'Orange');
    case 'Green':
    return const (color: Colors.green, colorName: 'Green');
    case 'Teal':
    return const (color: Colors.teal, colorName: 'Teal');
    case 'Deep purple':
    return const (color: Colors.deepPurple, colorName: 'Deep purple');
    default:
    return const (color: Colors.grey, colorName: 'Grey');
}

}
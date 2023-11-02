import 'package:flutter/material.dart';
import 'package:todo_app_with_getx/app/core/values/colors.dart';

const personIcon = 0xe491;
const worklcon = 0xe11c;
const movieIcon = 0xe40f;
const sporticon = 0xe4dc;
const travelIcon = 0xe071;
const shoplcon = 0xe59c;

List<Icon> getIcons() {
  return const [
    Icon(
      IconData(personIcon, fontFamily: 'MaterialIcons'),
      color: purple,
    ),
    Icon(
      IconData(worklcon, fontFamily: 'MaterialIcons'),
      color: green,
    ),
    Icon(
      IconData(movieIcon, fontFamily: 'MaterialIcons'),
      color: pick,
    ),
    Icon(
      IconData(sporticon, fontFamily: 'MaterialIcons'),
      color: yellow,
    ),
    Icon(
      IconData(travelIcon, fontFamily: 'MaterialIcons'),
      color: lightBlue,
    ),
    Icon(
      IconData(shoplcon, fontFamily: 'MaterialIcons'),
      color: deepPink,
    ),
  ];
}

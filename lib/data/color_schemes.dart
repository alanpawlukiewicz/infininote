import 'package:flutter/material.dart';

final colorSchemes = {
  "Default": ColorScheme.fromSeed(
    seedColor: Colors.blueAccent,
    primary: Color.fromARGB(255, 0, 119, 255),
  ),
  "Grey": ColorScheme.fromSeed(seedColor: Colors.grey, primary: Colors.grey),
  "Orange": ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 251, 165, 24),
    primary: Colors.orange,
  ),
  "Yellow": ColorScheme.fromSeed(
    seedColor: Colors.yellow,
    primary: const Color.fromARGB(255, 255, 198, 28),
  ),
  "Indigo": ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    primary: Colors.indigoAccent,
  ),
  "Red": ColorScheme.fromSeed(
    seedColor: Colors.red,
    primary: const Color.fromARGB(255, 138, 3, 3),
  ),
};

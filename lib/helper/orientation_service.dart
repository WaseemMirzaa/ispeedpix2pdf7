import 'package:flutter/material.dart';

class OrientationService {
  // Singleton pattern
  static final OrientationService _instance = OrientationService._internal();
  factory OrientationService() => _instance;
  OrientationService._internal();
  
  // Store the selected orientation index globally
  static int selectedOrientationIndex = 0;
  
  // Notifier to broadcast changes
  static final ValueNotifier<int> orientationIndexNotifier = ValueNotifier<int>(0);
  
  // Update the selected orientation index
  static void updateSelectedIndex(int index) {
    selectedOrientationIndex = index;
    orientationIndexNotifier.value = index;
  }
}
import 'package:flutter/material.dart';

class DirectionalityWrapper extends StatelessWidget {
  final Widget child;
  
  const DirectionalityWrapper({Key? key, required this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }
}
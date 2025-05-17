// import 'package:flutter/material.dart';
// import 'package:ispeedpix2pdf7/widgets/language_selection_screen.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class AboutScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    
//     return Directionality(
//       textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(l10n.about),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: [
//             // App info section
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       l10n.appTitle,
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8),
//                     Text(l10n.aboutAppDescription ?? 'Convert images to PDF quickly and easily'),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
            
//             // Language selection card
//             Card(
//               child: InkWell(
//                 onTap: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
//                   );
                  
//                   // If language was changed, rebuild the screen
//                   if (result == true) {
//                     // The app will rebuild automatically due to locale change
//                   }
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         l10n.language ?? 'Language',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       Icon(Icons.arrow_forward_ios),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
            
//             // Other about sections...
//             SizedBox(height: 16),
//             _buildSection(context, l10n.privacyPolicy ?? 'Privacy Policy', 
//                 l10n.privacyPoint1 ?? 'We do not collect any personal data.'),
            
//             SizedBox(height: 16),
//             _buildSection(context, l10n.howTo ?? 'How to Use', 
//                 l10n.howToUsePointOne ?? 'Instructions on how to use the app...'),
                
//             // Version info
//             SizedBox(height: 24),
//             Center(
//               child: Text(
//                 'Version 1.0.0',
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
  
//   Widget _buildSection(BuildContext context, String title, String content) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(content),
//           ],
//         ),
//       ),
//     );
//   }
// }
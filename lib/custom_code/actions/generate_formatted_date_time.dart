// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> generateFormattedDateTime() async {
  // Get the current date and time
  final DateTime now = DateTime.now();

  // Format date as MM.DD.YY
  final String formattedDate =
      '${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}.${(now.year % 100).toString().padLeft(2, '0')}';

  // Format time as h.mmAM/PM
  final int hour = now.hour == 0 || now.hour == 12 ? 12 : now.hour % 12;
  final String formattedTime =
      '$hour.${now.minute.toString().padLeft(2, '0')}${now.hour >= 12 ? 'PM' : 'AM'}';

  // Combine to the desired format with proper interpolation
  final String result = 'iSpeedPix2PDF_${formattedDate}_${formattedTime}';

  // Return the formatted string
  return result;
}

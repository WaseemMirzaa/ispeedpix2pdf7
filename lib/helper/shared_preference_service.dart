import 'package:ispeedpix2pdf7/helper/log_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static const _firstOpenDateKey = 'first_open_date';
  static const _pdfCreatedCountKey = 'pdf_created_count';

  // Save the current date as the first open date
  Future<void> saveFirstOpenDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String formattedDate = now.toIso8601String(); // You can customize the format
    await prefs.setString(_firstOpenDateKey, formattedDate);
  }

  void checkAndSaveDate() async {
    var date = await getFirstOpenDate();

    if (date == null) {
      saveFirstOpenDate();
    }
  }

  // Retrieve the saved first open date or return null if not set
  Future<String?> getFirstOpenDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firstOpenDateKey);
  }

  // Check if it's the first time the app is opened
  Future<bool> isFirstOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firstOpenDateKey) == null;
  }

  // Check if the saved first open date is older than 7 days
  Future<bool> isFirstOpenDateOlderThan7Days() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString(_firstOpenDateKey);

    if (savedDate == null) {
      return false; // No saved date, so it's not older than 7 days
    }

    // Parse the saved date from ISO8601 string
    DateTime firstOpenDate = DateTime.parse(savedDate);
    DateTime currentDate = DateTime.now();

    // Calculate the difference between the current date and the saved date
    Duration difference = currentDate.difference(firstOpenDate);

    // Check if the difference is greater than 7 days
    return difference.inDays > 7;
  }

  // Increment and return the PDF created count
  Future<int> incrementAndReturnPdfCreatedCount() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    int currentCount = prefs.getInt(_pdfCreatedCountKey) ?? 0;
    int newCount = currentCount + 1;


    LogHelper.logMessage('New Count', newCount);
    LogHelper.logMessage('currentCount', currentCount);
    await prefs.setInt(_pdfCreatedCountKey, newCount);

    return newCount;
  }


  // Fetch the PDF created count
  Future<int> getPdfCreatedCount() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var olderThan7Days = await isFirstOpenDateOlderThan7Days();

    if(!olderThan7Days) {

      await prefs.setInt(_pdfCreatedCountKey, 0);

    }

    return prefs.getInt(_pdfCreatedCountKey) ?? 0;
  }

  // Reset the PDF created count after 7 days
  Future<void> resetPdfCreatedCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? firstOpenDate = prefs.getString(_firstOpenDateKey);

    if (firstOpenDate != null) {
      DateTime firstOpenDateTime = DateTime.parse(firstOpenDate);
      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(firstOpenDateTime);

      if (difference.inDays % 7 == 0) {
        await prefs.setInt(_pdfCreatedCountKey, 0);
      }
    }
  }
}
import 'package:ispeedpix2pdf7/helper/log_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static const _firstOpenDateKey = 'first_open_date';
  static const _pdfCreatedCountKey = 'pdf_created_count';
  static const _isFirstTimeAppOpenedKey = 'is_first_time_app_opened';
  // Keys for time-based usage tracking
  static const _usageTimeKey = 'monthly_usage_time';
  static const _usageMonthKey = 'usage_month';
  static const _trialEndDateKey = 'trial_end_date';

  // Check if this is the first time the app is opened
  Future<bool> isFirstTimeAppOpened() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // If the key doesn't exist, it's the first time (returns true)
    // Otherwise, return the stored value (should be false after first open)
    return prefs.getBool(_isFirstTimeAppOpenedKey) ?? true;
  }

  // Set the first-time app opened flag
  Future<void> setFirstTimeAppOpened(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstTimeAppOpenedKey, value);
    LogHelper.logMessage('First Time App Open Flag', 'Set to $value');
  }

  // Save the current date as the first open date
  Future<void> saveFirstOpenDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String formattedDate =
        now.toIso8601String(); // You can customize the format
    await prefs.setString(_firstOpenDateKey, formattedDate);
  }

  void checkAndSaveDate() async {
    var date = await getFirstOpenDate();

    if (date == null) {
      saveFirstOpenDate();

      // If we're saving the first open date, also check the first-time app opened flag
      bool isFirstTime = await isFirstTimeAppOpened();
      if (isFirstTime) {
        // This is redundant but ensures consistency
        await setFirstTimeAppOpened(true);
      }
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

    if (!olderThan7Days) {
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

  // Get the trial end date
  Future<DateTime?> getTrialEndDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dateStr = prefs.getString(_trialEndDateKey);
    if (dateStr == null) return null;
    return DateTime.parse(dateStr);
  }

  // Set the trial end date (7 days from first open)
  Future<void> setTrialEndDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_trialEndDateKey) != null) return; // Already set

    DateTime now = DateTime.now();
    DateTime trialEndDate = now.add(Duration(days: 7));
    await prefs.setString(_trialEndDateKey, trialEndDate.toIso8601String());
    LogHelper.logMessage(
        'Trial End Date', 'Set to ${trialEndDate.toIso8601String()}');
  }

  // Check if trial period has ended
  Future<bool> hasTrialEnded() async {
    DateTime? trialEndDate = await getTrialEndDate();
    if (trialEndDate == null) {
      await setTrialEndDate(); // Set it if not already set
      return false; // Trial just started
    }

    return DateTime.now().isAfter(trialEndDate);
  }

  // Get remaining usage time in seconds for current month
  Future<int> getRemainingUsageTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if we need to reset for a new month
    int currentMonth = DateTime.now().month;
    int storedMonth = prefs.getInt(_usageMonthKey) ?? 0;

    if (currentMonth != storedMonth) {
      // New month, reset usage time
      await prefs.setInt(_usageMonthKey, currentMonth);
      await prefs.setInt(_usageTimeKey, 0);
      LogHelper.logMessage('Usage Time', 'Reset for new month: $currentMonth');
    }

    // Get current usage time
    int usedTime = prefs.getInt(_usageTimeKey) ?? 0;

    // 3 minutes = 180 seconds
    int maxUsageTime = 180;

    // Return remaining time (or 0 if exceeded)
    return (usedTime >= maxUsageTime) ? 0 : maxUsageTime - usedTime;
  }

  // Record usage time
  Future<void> recordUsageTime(int seconds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get current usage time
    int currentUsage = prefs.getInt(_usageTimeKey) ?? 0;
    int newUsage = currentUsage + seconds;

    // Save new usage time
    await prefs.setInt(_usageTimeKey, newUsage);
    LogHelper.logMessage('Usage Time', 'Updated to $newUsage seconds');
  }

  // Check if user has remaining usage time
  Future<bool> hasRemainingUsageTime() async {
    int remainingTime = await getRemainingUsageTime();
    return remainingTime > 0;
  }
}

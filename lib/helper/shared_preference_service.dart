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
  static const _pauseStartDateKey = 'pause_start_date';
  static const _isPausedKey = 'is_paused';
  static const _remainingTimeKey = 'remaining_time';
  static const _lastTrialLimitDialogDateKey = 'last_trial_limit_dialog_date';
  static const _lastDay2DialogDateKey = 'last_day2_dialog_date';
  static const _lastDay4DialogDateKey = 'last_day4_dialog_date';

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

    // Check if usage is paused (30-day cooldown)
    bool isPaused = await isUsagePaused();
    if (isPaused) {
      LogHelper.logMessage('Usage Time', 'Usage is paused, returning 0');
      return 0;
    }

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

  // Manual reset of usage time (for testing purposes)
  Future<void> resetUsageTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_usageTimeKey, 0);
    await prefs.setInt(_usageMonthKey, DateTime.now().month);
    LogHelper.logMessage('Usage Time', 'Manually reset to 0 seconds');
  }

  // Get current used time (for debugging)
  Future<int> getUsedTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_usageTimeKey) ?? 0;
  }

  // Check if usage is currently paused (30-day cooldown)
  Future<bool> isUsagePaused() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isPaused = prefs.getBool(_isPausedKey) ?? false;
    if (!isPaused) return false;

    String? pauseStartDateStr = prefs.getString(_pauseStartDateKey);
    if (pauseStartDateStr == null) return false;

    DateTime pauseStartDate = DateTime.parse(pauseStartDateStr);
    DateTime now = DateTime.now();

    // Check if 30 days have passed since pause started
    int daysSincePause = now.difference(pauseStartDate).inDays;

    if (daysSincePause >= 30) {
      // 30 days have passed, reset the pause
      await _resetPause();
      LogHelper.logMessage('Usage Pause', '30 days completed, resetting pause');
      return false;
    }

    LogHelper.logMessage(
        'Usage Pause', 'Still paused, $daysSincePause days since pause');
    return true;
  }

  // Start the 30-day pause when usage limit is reached
  Future<void> startUsagePause() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DateTime now = DateTime.now();
    await prefs.setBool(_isPausedKey, true);
    await prefs.setString(_pauseStartDateKey, now.toIso8601String());

    LogHelper.logMessage(
        'Usage Pause', 'Started 30-day pause at ${now.toIso8601String()}');
  }

  // Reset the pause (called after 30 days or manually)
  Future<void> _resetPause() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isPausedKey, false);
    await prefs.remove(_pauseStartDateKey);
    await prefs.setInt(_usageTimeKey, 0); // Reset usage time

    LogHelper.logMessage('Usage Pause', 'Pause reset, usage time cleared');
  }

  // Get remaining days in pause period
  Future<int> getRemainingPauseDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isPaused = prefs.getBool(_isPausedKey) ?? false;
    if (!isPaused) return 0;

    String? pauseStartDateStr = prefs.getString(_pauseStartDateKey);
    if (pauseStartDateStr == null) return 0;

    DateTime pauseStartDate = DateTime.parse(pauseStartDateStr);
    DateTime now = DateTime.now();

    int daysSincePause = now.difference(pauseStartDate).inDays;
    int remainingDays = 30 - daysSincePause;

    return remainingDays > 0 ? remainingDays : 0;
  }

  // Manual reset of pause (for testing)
  Future<void> resetPause() async {
    await _resetPause();
  }

  // Check if trial limit dialog can be shown today
  Future<bool> canShowTrialLimitDialogToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? lastShownDateStr = prefs.getString(_lastTrialLimitDialogDateKey);
    if (lastShownDateStr == null) return true; // Never shown before

    DateTime lastShownDate = DateTime.parse(lastShownDateStr);
    DateTime today = DateTime.now();

    // Check if it's a different day
    bool isDifferentDay = lastShownDate.year != today.year ||
        lastShownDate.month != today.month ||
        lastShownDate.day != today.day;

    LogHelper.logMessage('Trial Limit Dialog',
        'Last shown: ${lastShownDate.toIso8601String()}, Can show today: $isDifferentDay');

    return isDifferentDay;
  }

  // Mark trial limit dialog as shown today
  Future<void> markTrialLimitDialogShownToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    await prefs.setString(_lastTrialLimitDialogDateKey, now.toIso8601String());
    LogHelper.logMessage('Trial Limit Dialog',
        'Marked as shown today: ${now.toIso8601String()}');
  }

  // Check if Day 2 dialog can be shown today
  Future<bool> canShowDay2DialogToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? lastShownDateStr = prefs.getString(_lastDay2DialogDateKey);
    if (lastShownDateStr == null) return true; // Never shown before

    DateTime lastShownDate = DateTime.parse(lastShownDateStr);
    DateTime today = DateTime.now();

    // Check if it's a different day
    bool isDifferentDay = lastShownDate.year != today.year ||
        lastShownDate.month != today.month ||
        lastShownDate.day != today.day;

    LogHelper.logMessage('Day 2 Dialog',
        'Last shown: ${lastShownDate.toIso8601String()}, Can show today: $isDifferentDay');

    return isDifferentDay;
  }

  // Mark Day 2 dialog as shown today
  Future<void> markDay2DialogShownToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    await prefs.setString(_lastDay2DialogDateKey, now.toIso8601String());
    LogHelper.logMessage(
        'Day 2 Dialog', 'Marked as shown today: ${now.toIso8601String()}');
  }

  // Check if Day 4 dialog can be shown today
  Future<bool> canShowDay4DialogToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? lastShownDateStr = prefs.getString(_lastDay4DialogDateKey);
    if (lastShownDateStr == null) return true; // Never shown before

    DateTime lastShownDate = DateTime.parse(lastShownDateStr);
    DateTime today = DateTime.now();

    // Check if it's a different day
    bool isDifferentDay = lastShownDate.year != today.year ||
        lastShownDate.month != today.month ||
        lastShownDate.day != today.day;

    LogHelper.logMessage('Day 4 Dialog',
        'Last shown: ${lastShownDate.toIso8601String()}, Can show today: $isDifferentDay');

    return isDifferentDay;
  }

  // Mark Day 4 dialog as shown today
  Future<void> markDay4DialogShownToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    await prefs.setString(_lastDay4DialogDateKey, now.toIso8601String());
    LogHelper.logMessage(
        'Day 4 Dialog', 'Marked as shown today: ${now.toIso8601String()}');
  }

  // Store remaining time in preferences
  Future<void> setRemainingTime(int remainingTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_remainingTimeKey, remainingTime);
    LogHelper.logMessage('Remaining Time', 'Set to $remainingTime seconds');
  }

  // Get stored remaining time from preferences
  Future<int> getStoredRemainingTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedTime =
        prefs.getInt(_remainingTimeKey) ?? 180; // Default to 180 seconds
    LogHelper.logMessage(
        'Remaining Time', 'Retrieved $storedTime seconds from storage');
    return storedTime;
  }

  // Check if remaining time is expired (≤ 0)
  Future<bool> isRemainingTimeExpired() async {
    int remainingTime = await getStoredRemainingTime();
    bool isExpired = remainingTime <= 0;
    LogHelper.logMessage(
        'Remaining Time', 'Expired check: $isExpired (time: $remainingTime)');
    return isExpired;
  }
}

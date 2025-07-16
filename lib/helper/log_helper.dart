class LogHelper {
  static logSuccessMessage(String? logTitle, dynamic message) {
    print('🟢🟢🟢🟢🟢 SUCCESS ${logTitle ?? ''} : $message');
  }

  static logErrorMessage(String? logTitle, dynamic message) {
    print('🔴🔴🔴🔴🔴 ERROR ${logTitle ?? ''} : $message');
  }

  static logMessage(String? logTitle, dynamic message) {
    // print('🟡🟡🟡🟡🟡 MESSAGE ${logTitle ?? ''} : $message');
  }
}

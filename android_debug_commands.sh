# Run these commands in your terminal to debug Firebase Analytics on Android

# Connect to your device
adb shell

# Enable analytics debug mode
setprop debug.firebase.analytics.app com.mycompany.ispeedpix2pdf7

# View analytics logs
adb logcat -v time | grep -E 'FA|FirebaseAnalytics'

# To clear logs first
adb logcat -c
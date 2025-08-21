# Rating Dialog Conditions Documentation

## 📱 When the Rating Dialog Appears

### ✅ Primary Conditions (ALL must be met)

1. **User has NOT rated the app yet**
   - `has_rated` preference is `false` or doesn't exist
   - Once user rates (any star rating), this becomes `true` and dialog never shows again

2. **App usage criteria (ONE of these must be met):**
   - **Option A**: 3+ days since first launch AND 5+ app launches
   - **Option B**: 7+ days since first launch (regardless of launch count)

3. **Reminder cooldown period**
   - If user clicked "No Thanks" or "Maybe Later", dialog won't show again for 7 days
   - Tracked via `last_reminder_date` preference

### 📊 Tracking Preferences

| Preference Key | Type | Purpose |
|---|---|---|
| `first_launch_date` | String (ISO8601) | Records when app was first opened |
| `launch_count` | Integer | Increments each time app starts |
| `has_rated` | Boolean | Prevents dialog from showing again after rating |
| `last_reminder_date` | String (ISO8601) | Cooldown period for "No Thanks"/"Maybe Later" |

### 🎯 User Actions & Outcomes

#### ⭐ Star Rating Actions:
- **5 Stars**: Opens native review dialog or Play Store/App Store
- **4 Stars**: Opens native review dialog or Play Store/App Store  
- **3 Stars**: Shows "Thanks for feedback!" and marks as rated
- **1-2 Stars**: Shows "We'd love to improve!" and marks as rated

#### 🔘 Button Actions:
- **"Rate" Button**: Only appears after selecting stars
- **"No Thanks"**: Sets 7-day reminder cooldown, doesn't mark as rated
- **"Maybe Later"**: Sets 7-day reminder cooldown, doesn't mark as rated

### 🔄 Dialog Flow Examples

#### Example 1: New User (Immediate Show)
```
Day 1: App installed, launch_count = 1
Day 3: launch_count = 5
✅ SHOW DIALOG (3+ days AND 5+ launches)
```

#### Example 2: Casual User (Delayed Show)
```
Day 1: App installed, launch_count = 1
Day 7: launch_count = 3
✅ SHOW DIALOG (7+ days regardless of launches)
```

#### Example 3: "Maybe Later" User
```
Day 3: User clicks "Maybe Later"
Day 5: Conditions met but within 7-day cooldown
❌ DON'T SHOW
Day 10: Cooldown expired
✅ SHOW DIALOG AGAIN
```

### 🛠️ Debug Testing

#### Debug Buttons Available (Debug Mode Only):
1. **"Test Rating Dialog"**: Manually triggers dialog
2. **"Reset Rating Preferences"**: Clears all rating-related preferences

#### Manual Testing Steps:
1. Install app fresh OR use "Reset Rating Preferences"
2. Wait for conditions OR use "Test Rating Dialog"
3. Test different star ratings and button combinations

### 📱 Platform-Specific Behavior

#### Android:
- **Native Review**: Uses Google Play In-App Review API
- **Fallback**: Opens Play Store app page
- **URL**: `https://play.google.com/store/apps/details?id=com.mycompany.ispeedpix2pdf7`

#### iOS:
- **Native Review**: Uses iOS StoreKit RequestReview API  
- **Fallback**: Opens App Store app page
- **URL**: `https://apps.apple.com/app/id6667115897`

### 🔧 Implementation Details

#### Rating Logic Flow:
```
1. Check conditions → Show custom dialog
2. User selects stars → Enable "Rate" button
3. User clicks "Rate":
   - If 4-5 stars → Try native review → Fallback to store
   - If 1-3 stars → Show thank you → Mark as rated
4. User clicks "No Thanks"/"Maybe Later" → Set cooldown
```

#### Error Handling:
- If `in_app_review` plugin fails → Use `url_launcher` fallback
- If `url_launcher` fails → Show error message
- All errors logged to console for debugging

### 📈 Analytics Tracking

The following events are tracked:
- Dialog shown
- Star rating selected
- Button clicked ("Rate", "No Thanks", "Maybe Later")
- Native review success/failure
- Store page opened

### 🎨 UI/UX Features

- **Responsive Design**: Adapts to screen size (max 85% width, 400px max)
- **5-Star Rating Bar**: Interactive star selection with visual feedback
- **Dynamic Feedback**: Text changes based on star rating
- **Attractive Styling**: Gradient background, rounded corners, shadows
- **App Icon Display**: Shows actual app launcher icon
- **Pixel-Perfect Layout**: No overflow issues, proper button alignment

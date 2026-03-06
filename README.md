# ZenFit – Smart Gym Plan Registration (Flutter Front-end)

This project implements the exam topic: **Smart Gym Plan Registration & Management system "ZenFit"**.

## Requirements checklist

- **Platforms**: Windows Desktop, Web, Android
- **State management**: Provider (`ChangeNotifier`)
- **No backend**
- **Presentation language**: English
- **Assets**:
  - `assets/student_info.json` (name, student_id, email)
  - `assets/ai_prompt_history.json` (AI prompt history list)

## Screen flow (8 screens)

### Splash (Screen 0)
- Loads `assets/student_info.json` and displays: name, student_id, email + a logo.
- Waits exactly **5 seconds**, then navigates to **Profile Setup**.

### Screen 1 – Profile Setup
- Inputs: Full name, Date of birth, Gender, Weight (kg), Height (cm)
- Validation: weight/height must be **positive**
- Auto-calculates and shows **BMI** when both weight and height are valid
- Button **`Tiếp tục`** → Screen 2

### Screen 2 – Plan Selection
- Plans: Basic (500k), Premium (1tr), VIP (2tr)
- Rule: if **BMI > 30**, show health warning and recommend Premium/VIP.
  - If user selects **Basic**, **`Tiếp tục`** is disabled with an explanation.
- Button **`Tiếp tục`** → Screen 3

### Screen 3 – Payment & Promo
- Promo input
- Rules:
  - `GIAM50` works only if total price **> 1.5M**
  - `TANTHU` works only if user age **< 22** (from DOB)
- Button **`Tiếp tục`** → Screen 4

### Screen 4 – Review & Confirm
- Shows summary of all data from Screen 1, 2, 3
- Allows editing by going back to previous screens
- Requirement: if editing height changes BMI, then Screen 2 & 3 logic updates automatically.
  - Implemented by central Provider state (`ZenFitState`).
- Confirm → Screen 5

### Screen 5 – Dashboard
- Shows a virtual membership card with registered info
- Button **`Hết bài làm`** → Screen 6

### Screen 6 – AI Prompt History
- Loads `assets/ai_prompt_history.json`
- Shows ListView items with:
  - time (date + time)
  - short title of question (from prompt)
- Tap item → Screen 7

### Screen 7 – AI Response Detail
- Shows full response text for the selected item
- Back returns to Screen 6

## State management

Central state lives in `lib/state/zenfit_state.dart` and is provided at app root (`lib/main.dart`).

It stores:
- profile data (name, dob, gender, weight, height)
- derived values: BMI, age, obesity flag
- selected plan
- promo code + applied discount rules
- computed totals (subtotal, discount, final)

Because all screens read/write the same `ZenFitState`, changes in Screen 1 automatically affect rules in Screen 2/3/4.

## How to run

From project root:

```bash
flutter pub get
```

### Windows Desktop

```bash
flutter run -d windows
```

### Web (Chrome)

```bash
flutter run -d chrome
```

### Android
- Start an emulator or connect a device

```bash
flutter run -d android
```

## Before submitting (clean)

In Android Studio:
- `Tools > Flutter > Flutter clean`

Or terminal:

```bash
flutter clean
```

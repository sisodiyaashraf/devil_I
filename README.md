<p align="center">
  <img src="assets/icons/devilicon.png" width="120" alt="Devil_I Logo"/>
</p>

<h1 align="center">Devil_I</h1>

<p align="center">
  <b>A Psychological Habit Tracker & Focus Ritual Room</b><br/>
  <i>"Your discipline is being watched. Every second."</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.10+-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-black?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Theme-AMOLED%20Dark-000000?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/License-MIT-red?style=for-the-badge"/>
</p>

---

## 🩸 What is Devil_I?

**Devil_I** is not your typical habit tracker. It's a **strict, psychologically-driven discipline engine** wrapped in a dark, cinematic aesthetic. The app treats habit-building as a supernatural pact — you sign a **Contract of Discipline**, and the Devil watches your every move. Complete your vows and earn **Virtues**. Break them, and **Sins** accumulate on your soul.

The entire UI is built around an AMOLED-optimized void theme with glassmorphism cards, atmospheric video backgrounds, haptic feedback, and a dynamic **Soul Score** system that shifts the app's entire atmosphere between **Heaven**, **Hell**, and the **Void**.

---

## ✨ Features

### 🔥 The Ledger (Home Screen)
- **The All-Seeing Eye** — An animated video eye (`devileye_shutter.mp4`) that blinks at random intervals (50–60s) and on tap, with a pulsing glow effect tied to the current Soul Realm
- **Active Habit List** — Glassmorphic cards displaying your sealed vows with swipe actions to earn Virtues or commit Sins
- **Dynamic Devil Messages** — Contextual taunts from the Voice Bank based on your actions
- **Animated Video Background** — Atmospheric looping video (`hell_bg.mp4`) rendered behind a vignette gradient
- **Soul Ledger History** — A dedicated page to review all past soul score entries

### 📜 The Contract System (Onboarding & Habit Creation)
- **Contract of Discipline** — First-time onboarding screen styled as a physical parchment document with a wax seal icon
- **Signature Pad** — Real handwriting signature capture using the `signature` package
- **Blood Oath vs Standard Vow** — Two tiers of commitment. Blood Oaths carry **5x sin penalties** and **cannot be broken**
- **Punishment Threats** — Custom consequences displayed during Focus sessions
- **Reminder Scheduling** — Set a daily reminder time with a configurable pre-deadline warning (the "2-Minute Warning")

### ⏱️ The Focus Ritual Room
- **Immersive Timer** — Full-screen countdown with the Devil's Eye at the center
- **Geometric Orbit Animation** — 12-point rotating arc geometry that tightens as the timer progresses, rendered via `CustomPainter`
- **Peripheral Void** — A radial gradient that expands as focus deepens
- **Chromatic Drift** — The accent color intensifies from 30% to 100% opacity as you approach completion
- **Escalating Haptic Heartbeat** — Light pulses at 10% milestones → Medium pulses in the final 15% → Heavy pulses every second in the last 10 seconds
- **Anti-Cheat System** — Minimizing the app during a Focus session is an **instant failure**. The timer detects app backgrounding and auto-commits a Sin
- **Hold-to-Break Button** — A deliberate long-press action to surrender, triggering punishment feedback
- **Ritual Success Screen** — On completion, a generated "Artifact Name" (e.g., `DIVINE RESOLVE`, `CELESTIAL PULSE`) is awarded

### 🪞 The Mirror (Analytics & Reflection)
- **Soul Score Display** — Giant bloom-glow score with realm-dependent accent colors
- **Soul Trend Chart** — Historical line chart of soul score progression using `fl_chart` with gradient fill
- **Individual Ledger** — Per-habit reflective cards showing Virtue/Sin balance with a moral bar visualization
- **Realm-Aware Header** — Displays `DIVINE REFLECTION`, `CORRUPTED IMAGE`, or `NEUTRAL VOID` based on your Soul Score

### 👤 Mortal Record (Profile)
- **Identity Portal** — Displays the Mortal Name from the original contract, contract signing date, current Realm, and Soul Score
- **Reckoning Summary** — 24-hour performance snapshot
- **Reaping Heatmap** — 30-day activity heatmap of your discipline history
- **System Configuration** — Settings and toggles for notification preferences
- **The Graveyard** — Archive of broken/shattered contracts

### ⚖️ The Reckoning (Daily Audit Overlay)
- **Full-Screen Takeover** — A blurred glassmorphic overlay that blocks all interaction until acknowledged
- **Purity Orb** — Large percentage display showing yesterday's completion rate
- **Audit Log** — Displays cycle completion, unfulfilled vows, and soul standing
- **Devil's Taunt** — Contextual message based on performance
- **"I ACCEPT MY FATE"** — Ritual acknowledgment button to dismiss

### 🔔 Notification System
- **4x Daily Ritual Cycle** — Realm-aware messages at 9 AM, 1 PM, 5 PM, and 9 PM with day-of-week contextual content
- **8 PM Daily Reckoning** — Exact alarm notification listing unfulfilled vows
- **Task Deadline Warnings** — Pre-scheduled exact alarm reminders with urgent taunts
- **3 Realms × 7 Days** — 42+ unique notification messages rotating across Heaven, Hell, and Void themes

### 🎭 Sensory Feedback Engine
- **Punishment Audio** — `growl.mp3` at full volume on failure
- **Reward Audio** — `chime.mp3` at 50% volume on success
- **Dynamic Vibration Patterns** — Blood Oath failures trigger violent multi-burst haptics; standard failures use gentler patterns
- **Haptic Pulse Milestones** — Light, Medium, and Heavy impacts during focus sessions

### 🌓 Dynamic Realm System
Your **Soul Score** determines the app's entire atmosphere:

| Realm | Condition | Accent Color | Notification Tone |
|-------|-----------|-------------|-------------------|
| **HEAVEN** | Score ≥ +20 | `Amber / Gold` | Divine Guidance (✧) |
| **VOID** | -15 < Score < +20 | `Grey / Cyan` | Neutral Observation |
| **HELL** | Score ≤ -15 | `Red / Crimson` | Aggressive Taunts (!!) |

---

## 🏗️ Architecture

The project follows a **Clean Architecture** pattern with clear separation of concerns:

```
lib/
├── main.dart                         # App entry point, provider setup, permission requests
│
├── core/                             # Shared infrastructure
│   ├── constants/
│   │   ├── notification_messages.dart  # Realm-aware notification text
│   │   ├── ritual_messages.dart        # 42+ day/realm-specific ritual messages
│   │   └── voice_bank.dart             # Devil's taunt system (trigger-based quotes)
│   └── services/
│       ├── notification_service.dart   # Local notifications, exact alarms, channels
│       ├── sensory_service.dart        # Audio playback, haptic vibration patterns
│       └── widget_sync_service.dart    # Home widget synchronization
│
├── data/                             # Data layer
│   ├── models/
│   │   ├── habit.dart                  # Isar habit model (title, virtues, sins, blood oath, etc.)
│   │   └── soul_entry.dart             # Isar soul score history model
│   ├── services/
│   │   └── database_service.dart       # Isar database initialization & CRUD
│   └── sources/                        # (Future: remote data sources)
│
├── domain/                           # Domain layer
│   ├── entities/                       # (Future: pure business entities)
│   └── repositories/                   # (Future: repository interfaces)
│
└── presentation/                     # UI layer
    ├── providers/
    │   ├── devil_provider.dart         # Core state: habits, soul score, reckoning, realm
    │   └── focus_provider.dart         # Focus timer, anti-cheat, haptic escalation
    └── screens/
        ├── onboarding/
        │   └── contract_screen.dart    # Parchment-style pact with signature pad
        ├── home/
        │   ├── home_screen.dart        # Main scaffold with PageView navigation
        │   └── widgets/
        │       ├── eye_widget.dart      # Animated All-Seeing Eye with video player
        │       ├── habit_list.dart       # Scrollable active habit cards
        │       ├── contract_sheet.dart   # Bottom sheet for creating new vows
        │       ├── glass_card.dart       # Reusable glassmorphism card component
        │       ├── devil_nav_bar.dart    # Custom bottom navigation bar
        │       ├── background_video.dart # Atmospheric looping video background
        │       ├── reckoning_overlay.dart # Daily audit full-screen takeover
        │       ├── timer_display.dart    # Digital HUD countdown display
        │       └── SoulLedgerScreen.dart # Soul score history page
        ├── focus/
        │   ├── focus_screen.dart        # Immersive ritual room with orbit geometry
        │   ├── ritual_success_screen.dart # Completion celebration screen
        │   ├── video_splash_player.dart  # Intro video splash
        │   └── widgets/
        │       └── ritual_result_card.dart # Generated artifact result card
        ├── mirror/
        │   └── mirror_screen.dart       # Analytics: soul chart, habit reflection cards
        └── profile/
            ├── profile_screen.dart      # Mortal Record with heatmap & config
            └── widgets/
                ├── identity_portal.dart   # User identity & rank display
                ├── reaping_heatmap.dart    # 30-day activity heatmap
                ├── reckoning_summary.dart  # 24h performance snapshot
                └── system_config.dart     # Settings toggles
```

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.10+ (Material 3) |
| **State Management** | Provider |
| **Local Database** | Isar (NoSQL, with code generation) |
| **Typography** | Google Fonts (`Cinzel`, `Space Mono`, `Noto Serif`) |
| **Charts** | fl_chart |
| **Notifications** | flutter_local_notifications + timezone |
| **Permissions** | permission_handler |
| **Audio** | audioplayers |
| **Video** | video_player |
| **Haptics** | vibration + Flutter HapticFeedback |
| **Signature** | signature |
| **Home Widget** | home_widget |
| **Persistence** | shared_preferences |

---

## 🎨 Design Language

- **Color Palette**: Pure AMOLED black (`#000000`) base with crimson (`#B71C1C`), amber, and cyan accents
- **Typography**: `Cinzel` for titles and headers (medieval, authoritative), `Space Mono` for body and data (cold, digital), `Noto Serif` for contract text (legal, formal)
- **Glassmorphism**: Backdrop-blurred translucent cards with subtle borders used across all screens
- **Video Backgrounds**: Looping atmospheric MP4 videos with vignette gradient overlays
- **Animations**: Pulsing glow cycles, rotating orbit geometry, chromatic color drift, stamp effect on contract sealing
- **Haptic Design**: Contextual vibration patterns that escalate based on severity and proximity to deadlines

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.10.4 <4.0.0`
- Dart `>=3.10.4`
- Android Studio / VS Code with Flutter extensions
- An Android or iOS device/emulator

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/sisodiyaashraf/devil_I.git

# 2. Navigate to the project
cd devil_I

# 3. Install dependencies
flutter pub get

# 4. Generate Isar database models
dart run build_runner build --delete-conflicting-outputs

# 5. Run the app
flutter run
```

### Generating the App Icon

```bash
dart run flutter_launcher_icons
```

---

## 📂 Assets

```
assets/
├── audio/
│   ├── chime.mp3           # Reward sound (virtue earned)
│   └── growl.mp3           # Punishment sound (sin committed)
├── icons/
│   └── devilicon.png       # App launcher icon
├── images/                 # Static image assets
├── videos/
│   ├── devilcaranime.mp4   # Decorative animation
│   ├── devileye_shutter.mp4 # All-Seeing Eye blink animation
│   └── hell_bg.mp4         # Home screen atmospheric background
└── data/                   # Static data files
```

---

## 🧠 Key Design Decisions

1. **Psychological Pressure as UX** — The app intentionally creates tension through taunts, vibrations, and a punitive scoring system. This is by design — breaking comfort to build discipline.

2. **Anti-Cheat in Focus Mode** — Backgrounding the app during a Focus session is treated as an immediate failure. The `WidgetsBindingObserver` listens for `AppLifecycleState.paused` and auto-commits a Sin.

3. **Blood Oaths are Permanent** — Unlike Standard Vows, Blood Oaths cannot be broken. Attempting to break one adds 5 sins instead of deactivating the habit. This mirrors real commitment.

4. **Midnight Reset** — All `isCompletedToday` flags reset at midnight via date comparison in `SharedPreferences`, ensuring a clean slate each day.

5. **Realm-Driven Notifications** — The notification content and tone shift dynamically based on the user's Soul Realm. If you ascend to Heaven, messages become encouraging. Fall to Hell, and they become aggressive.

---

## 👨‍💻 Author

**Ashraf Sisodiya**

- GitHub: [@sisodiyaashraf](https://github.com/sisodiyaashraf)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<p align="center">
  <i>"The void is watching your silence."</i>
</p>

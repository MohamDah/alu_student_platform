# ALU Student Platform

A professionally structured Flutter application designed to empower students at the African Leadership University (ALU) to manage their academic journey effectively. This platform centralizes assignment tracking, schedule management, and attendance monitoring in a clean, user-centric interface.

## Features

### Dashboard
- **Dynamic Weekly Tracking:** Automatically calculates the current academic week based on the semester start date.
- **Attendance Overview:** Real-time visualization of your overall attendance percentage across all academic sessions.
- **Upcoming Assignments:** Displays a prioritized list of assignments due within the next 7 days.

### Assignment Management
- **Full CRUD Support:** Create, read, update, and delete assignments with ease.
- **Categorization:** Distinguish between **Formative** and **Summative** assignments.
- **Smart Prioritization:** Assign High, Medium, or Low priority levels to stay on top of critical tasks.
- **Status Tracking:** Mark assignments as completed to maintain a clear roadmap of your progress.

### Academic Scheduling & Attendance
- **Session Management:** Add and manage academic sessions, including classes, study groups, and PSL meetings.
- **Attendance Logging:** Mark yourself as present or absent for each session, which dynamically updates your global attendance metric.
- **Detailed View:** Access session descriptions, dates, and times directly from the schedule.

## Architecture

The project follows a modular and clean architecture to ensure scalability and maintainability.

- **[lib/models/](lib/models/):** Contains data models ([assignment_model.dart](lib/models/assignment_model.dart) and [academic_session.dart](lib/models/academic_session.dart)) with serialization logic for local persistence.
- **[lib/screens/](lib/screens/):** Houses main functional areas like the [Dashboard](lib/screens/dashboard_screen.dart), [Assignments](lib/screens/assignments_screen.dart), and [Schedule](lib/screens/schedule_screen.dart).
- **[lib/widgets/](lib/widgets/):** Reusable UI components (e.g., [assignments_list.dart](lib/widgets/assignments_list.dart), [session_card.dart](lib/widgets/session_card.dart)) to minimize code duplication.
- **[lib/helpers/](lib/helpers/):** Business logic layer ([dashboard_helper.dart](lib/helpers/dashboard_helper.dart)) for complex data processing and calculations.
- **[lib/theme/](lib/theme/):** Custom ALU branding through [alu_colors.dart](lib/theme/alu_colors.dart).

## Tech Stack & Dependencies

- **Framework:** Flutter (SDK `^3.10.4`)
- **Persistence:** `shared_preferences` - Local storage for user data.
- **Formatting:** `intl` - Handles date and time localization.
- **Icons:** `cupertino_icons` - iOS-styled typography and icons.

## Setup & Installation

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.10.4 or higher)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter/Dart extensions.

### Installation Steps
1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/alu_student_platform.git
   cd alu_student_platform
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the application:**
   ```bash
   flutter run
   ```

## 💾 Data Persistence

All user data is stored locally on the device using `SharedPreferences`. The models utilize `jsonEncode` and `jsonDecode` to serialize academic records into string format, ensuring that your assignments and schedules are preserved across app restarts without requiring a cloud backend.

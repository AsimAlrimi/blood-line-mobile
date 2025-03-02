# Blood Line

**A Comprehensive Blood Donation Management System**

Blood Line is a platform designed to streamline the blood donation process, enhance communication among stakeholders, and optimize blood bank operations. The system consists of:
- **Mobile App**  
- **[Desktop App](https://github.com/AsimAlrimi/blood-line-desktop.git)**  
- **[Backend](https://github.com/AsimAlrimi/blood-line-backend.git)** 

The mobile app enables donors to easily schedule appointments, track donation history, receive notifications about blood drives, and stay informed about urgent blood supply needs. Meanwhile, hospitals and blood banks utilize the desktop application to manage blood donations and facilitate better communication with donors.

---

## Blood Line Mobile App

### Overview
The Blood Line Mobile App is designed to enhance the donor experience by making the blood donation process more accessible and efficient. Donors can register, book donation appointments, view nearby blood banks, and stay updated on donation events. The app also sends reminders and alerts to encourage timely donations.

### Tech Stack
- **Framework:** Flutter
- **Language:** Dart
- **Backend Communication:** REST API (Flask, Python)
- **Database:** SQLite
- **Mapping Services:** Google Maps API

---

## Features
### **Authentication & Profile Management**
- **Sign Up:** Donors can register with personal details such as name, email, phone number, blood group, etc.
- **Log In:** Secure login using email and password.
- **Password Recovery:** Reset password via email verification.
- **Edit Profile:** Update personal information including weight, phone number, and password.

### **Donation & Tracking**
- **View Map:** Locate nearby blood donation centers with detailed information.
- **Schedule Appointment:** Book, modify, or cancel donation appointments.
- **Track Donation History:** Monitor past donations including type, quantity, and recipient organization.

### **Engagement & Communication**
- **Receive Notifications:** Stay informed about upcoming donation drives and urgent blood needs.
- **View Events and Blood Needs:** Browse information on blood donation campaigns and hospital requests.
- **Access Volunteer Opportunities:** Sign up for volunteer roles in blood donation campaigns.
- **Access FAQ:** Find answers to common blood donation queries.
- **Contact Support:** Reach out to the support team for assistance.

---

## Getting Started

### Prerequisites
Ensure you have the following installed:
- Flutter SDK
- Dart SDK
- Android Studio / Xcode (for iOS development)
- Emulator or Physical Device

### Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/blood-line-mobile.git
   ```
2. Navigate to the project directory:
   ```sh
   cd blood-line-mobile
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```


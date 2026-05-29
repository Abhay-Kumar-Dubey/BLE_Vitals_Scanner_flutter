# BLE Vitals Scanner

A Flutter application built using **flutter_reactive_ble** and **GetX** that scans for BLE devices, connects to peripherals, discovers services and characteristics, and displays real-time data through BLE notifications.

---

## Features

- BLE Device Scanning
- Device Connection & Disconnection
- Service Discovery
- Characteristic Discovery
- Characteristic Read Operations
- Real-time Notification Subscription
- Connection State Tracking
- RSSI Display
- Dynamic Service & Characteristic Explorer

---

## Tech Stack

- Flutter
- GetX
- flutter_reactive_ble
- Dart

---

# Setup Instructions

## Prerequisites

Ensure the following are installed:

- Flutter SDK (Latest Stable)
- Android Studio / VS Code
- Android Device with BLE support
- Python BLE Peripheral (Optional for testing)

---

## Clone Repository

```bash
git clone https://github.com/Abhay-Kumar-Dubey/BLE_Vitals_Scanner_flutter
cd ble_vitals_scanner
```

---

## Install Dependencies

```bash
flutter pub get
```

---

## Run Application

```bash
flutter run
```

---

## Run Python Ble simulator code

```bash
python3 ble_server.py
```

---

# Android Permissions

Add the following permissions in:

```text
android/app/src/main/AndroidManifest.xml
```

```xml
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```

---

# Conclusion

This project demonstrates end-to-end BLE communication using Flutter and `flutter_reactive_ble`. It includes scanning, connecting, service discovery, characteristic reading, and real-time notification handling while following a clean architecture using GetX for state management.
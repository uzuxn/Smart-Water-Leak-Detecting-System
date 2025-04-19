# Smart-Water-Leak-Detecting-System

## 💧 Smart Water Leak Detection & Monitoring System

This project is a real-time smart water leak detection and monitoring system designed to minimize water wastage and damage by detecting pipeline leaks, monitoring water parameters, and enabling remote control via a mobile application.

Built with **ESP32 microcontrollers**, various **IoT sensors**, and a **Flutter mobile app**, the system compares flow sensor data to detect leaks, automatically shuts off the water supply when needed, and notifies users through a clean and user-friendly interface.

### 🔧 Features

- 🔍 **Leak Detection** using dual flow sensors (inlet & outlet comparison)
- 🚿 **Automatic Water Shut-Off** via solenoid valve
- 🌡️ **Water Parameter Monitoring**: temperature, pressure, and tank level
- 🕒 **Time-Based Activation** to avoid false positives
- 📱 **Flutter Mobile App**: Real-time dashboard & manual control
- ☁️ **Firebase Integration**: Real-time database, authentication, and (future) cloud messaging
- 🛠️ **Emergency Panel**: Plumber contact & safety suggestions
- 🔐 Secure access with Firebase Auth
- 💡 Modular design for scalability & low power ESP32 performance

### 📦 Technologies Used

- **ESP32**, Arduino IDE
- **Flutter & Dart** (VS Code)
- **Firebase**: Auth, Realtime DB, Storage
- **Sensors**: Flow, Ultrasonic (water level), Temperature, Pressure
- **Actuators**: Solenoid valves controlled via relays

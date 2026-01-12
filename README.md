# Pick Location

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.5.3+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.5.3+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)

A comprehensive Flutter application for location tracking, real-time mapping, data visualization, and integrated communication features with cross-platform support.

</div>

## 📋 Table of Contents

- [Features](#-features)
- [Demo](#-demo)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Project Structure](#-project-structure)
- [Dependencies](#-dependencies)
- [API Integration](#-api-integration)
- [Platform Specific Setup](#-platform-specific-setup)
- [Building](#-building)
- [Testing](#-testing)
- [Troubleshooting](#-troubleshooting)
- [Performance](#-performance)
- [Contributing](#-contributing)
- [Roadmap](#-roadmap)
- [License](#-license)

## ✨ Features

### 🗺️ Location & Mapping
- **Dual Map Support**: Google Maps and Flutter Map (OpenStreetMap) integration
- **Real-time Location Tracking**: Continuous GPS monitoring with high accuracy
- **Geocoding Services**: Convert addresses to coordinates and vice versa
- **Custom Markers**: Animated markers with custom icons and GIF support
- **Polyline Routing**: Visual route planning with multiple waypoints
- **Interactive Maps**: Pinch to zoom, rotate, and tilt functionality
- **Offline Maps**: Cache tiles for offline usage (Flutter Map)
- **Location Permissions**: Smart permission handling with fallback options

### 📊 Data Visualization
- **Multiple Chart Libraries**:
  - **FL Chart**: Line, bar, pie, and scatter charts
  - **MRX Charts**: Advanced laboratory data visualization
  - **Syncfusion Charts**: Professional-grade charts with 30+ types
  - **Graphic**: Grammar of graphics implementation
- **Real-time Data Updates**: Live chart animations and updates
- **Interactive Charts**: Touch gestures, tooltips, and legends
- **Export Capabilities**: Save charts as images
- **Custom Themes**: Dark/light mode support

### 📞 Communication Features
- **Video Calling**: Jitsi Meet integration with custom UI
- **WebRTC Support**: Peer-to-peer video and audio streaming
- **Real-time Messaging**: Socket.IO powered instant messaging
- **Audio Notifications**: Custom ringtones and alert sounds
- **Call Management**: Incoming call handling with custom UI
- **Screen Sharing**: Share screen during video calls

### 🎨 User Interface
- **Curved Navigation Bar**: Modern bottom navigation with animations
- **Carousel Sliders**: Image and content carousels with auto-play
- **WebView Integration**: Embedded web content with JavaScript bridge
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Material Design 3**: Latest Material Design components
- **Custom Animations**: Smooth transitions and micro-interactions

### 🔧 Additional Features
- **State Management**: Provider pattern for scalable architecture
- **URL Routing**: Go Router for declarative navigation
- **Data Tables**: Advanced sortable and filterable tables
- **File Handling**: Asset management and external file access
- **HTTP Client**: Dio for robust API communication
- **Permission Management**: Runtime permission requests
- **Cross-platform**: Android, iOS, and Web support

## 🎬 Demo

> Add screenshots, GIFs, or video demonstrations here

```
[Screenshot 1: Map View] [Screenshot 2: Charts] [Screenshot 3: Video Call]
```

## 🏗️ Architecture

The application follows a clean architecture pattern with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│          Presentation Layer             │
│  (Screens, Widgets, UI Components)      │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│         Business Logic Layer            │
│     (Providers, State Management)       │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│           Data Layer                    │
│  (Services, Repositories, API Clients)  │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│         External Services               │
│  (Google Maps, Jitsi, Socket.IO, etc)  │
└─────────────────────────────────────────┘
```

### State Management Pattern

```dart
// Example Provider Structure
class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  List<Marker> _markers = [];
  
  Position? get currentPosition => _currentPosition;
  List<Marker> get markers => _markers;
  
  Future<void> getCurrentLocation() async {
    // Implementation
    notifyListeners();
  }
  
  void addMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }
}
```

## 📦 Prerequisites

### Required Software
- **Flutter SDK**: Version 3.5.3 or higher
- **Dart SDK**: Version 3.5.3 or higher (included with Flutter)
- **Android Studio**: 2023.1 or later (for Android development)
- **Xcode**: 15.0 or later (for iOS development, macOS only)
- **VS Code**: Latest version (alternative IDE)
- **Chrome**: Latest version (for web development)

### System Requirements
- **Operating System**: Windows 10+, macOS 12+, or Linux (Ubuntu 20.04+)
- **RAM**: Minimum 8GB (16GB recommended)
- **Storage**: 10GB free space
- **Internet**: Required for initial setup and package downloads

### API Keys & Credentials
- Google Maps API Key (with Maps SDK enabled)
- Google Cloud Platform project (for geocoding services)
- Jitsi Meet server URL (optional, uses public server by default)
- Backend API endpoint (for your custom services)

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/pick_location.git
cd pick_location
```

### 2. Install Flutter Dependencies

```bash
# Clean any existing builds
flutter clean

# Get all packages
flutter pub get

# Verify installation
flutter doctor -v
```

### 3. Resolve Any Issues

```bash
# If you encounter pub dependency issues
flutter pub upgrade

# If you need to fix outdated dependencies
flutter pub outdated
```

## ⚙️ Configuration

### 1. Create Configuration File

Create a file `lib/config/app_config.dart`:

```dart
class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'https://your-api.com/api';
  static const String socketUrl = 'https://your-socket-server.com';
  
  // Google Maps
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  // Jitsi Configuration
  static const String jitsiServerUrl = 'https://meet.jit.si';
  
  // App Settings
  static const int locationUpdateInterval = 5000; // milliseconds
  static const double defaultZoom = 15.0;
  static const int maxMarkersOnMap = 100;
}
```

### 2. Environment Variables (Recommended)

Create `.env` file in project root:

```env
API_BASE_URL=https://your-api.com/api
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
SOCKET_URL=https://your-socket-server.com
JITSI_SERVER=https://meet.jit.si
```

Add to `.gitignore`:
```
.env
lib/config/app_config.dart
```

### 3. Assets Configuration

Ensure all assets are properly placed:

```
assets/
├── imgs/
│   ├── 1.png
│   ├── 2.png
│   ├── 3.png
│   ├── 4.png
│   └── 5.png
├── logo.png
├── aw_logo.png
├── green_marker.png
├── map_pin.png
├── anim_marker.gif
└── sounds/
    ├── ringtone.mp3
    ├── alarm.mp3
    └── incoming_call.mp3
```

## 📖 Usage

### Basic Map Implementation

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text('Pick Location')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: locationProvider.markers,
        polylines: locationProvider.polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => locationProvider.getCurrentLocation(),
        child: Icon(Icons.my_location),
      ),
    );
  }
}
```

### Chart Implementation Example

```dart
import 'package:fl_chart/fl_chart.dart';

class ChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 3),
              FlSpot(1, 1),
              FlSpot(2, 4),
              FlSpot(3, 2),
            ],
            isCurved: true,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
```

### Video Call Integration

```dart
import 'package:jitsi_meet/jitsi_meet.dart';

Future<void> joinVideoCall(String roomName) async {
  var options = JitsiMeetingOptions(room: roomName)
    ..serverURL = "https://meet.jit.si"
    ..subject = "Pick Location Video Call"
    ..userDisplayName = "User Name"
    ..userEmail = "user@example.com"
    ..audioOnly = false
    ..audioMuted = false
    ..videoMuted = false;

  await JitsiMeet.joinMeeting(options);
}
```

### Socket.IO Real-time Updates

```dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  
  void connect() {
    socket = IO.io('https://your-socket-server.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    
    socket.connect();
    
    socket.on('location_update', (data) {
      // Handle location update
      print('Location updated: $data');
    });
  }
  
  void emitLocation(double lat, double lng) {
    socket.emit('update_location', {
      'latitude': lat,
      'longitude': lng,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void disconnect() {
    socket.disconnect();
  }
}
```

## 📁 Project Structure

```
pick_location/
├── android/                      # Android native code
├── ios/                          # iOS native code
├── web/                          # Web specific files
├── assets/                       # Static assets
│   ├── imgs/                     # Images
│   ├── sounds/                   # Audio files
│   └── *.png                     # Icons and markers
├── lib/
│   ├── main.dart                 # App entry point
│   ├── config/                   # Configuration files
│   │   └── app_config.dart
│   ├── models/                   # Data models
│   │   ├── location_model.dart
│   │   ├── user_model.dart
│   │   └── marker_model.dart
│   ├── providers/                # State management
│   │   ├── location_provider.dart
│   │   ├── map_provider.dart
│   │   ├── chart_provider.dart
│   │   └── call_provider.dart
│   ├── screens/                  # UI Screens
│   │   ├── home_screen.dart
│   │   ├── map_screen.dart
│   │   ├── chart_screen.dart
│   │   ├── video_call_screen.dart
│   │   └── profile_screen.dart
│   ├── widgets/                  # Reusable widgets
│   │   ├── custom_marker.dart
│   │   ├── location_card.dart
│   │   ├── chart_widget.dart
│   │   └── call_controls.dart
│   ├── services/                 # Business logic
│   │   ├── location_service.dart
│   │   ├── api_service.dart
│   │   ├── socket_service.dart
│   │   └── permission_service.dart
│   ├── utils/                    # Helper functions
│   │   ├── constants.dart
│   │   ├── helpers.dart
│   │   └── validators.dart
│   └── routes/                   # Navigation
│       └── app_router.dart
├── test/                         # Unit and widget tests
├── pubspec.yaml                  # Dependencies
├── analysis_options.yaml         # Linter rules
└── README.md                     # This file
```

## 📚 Dependencies

### Core Dependencies

#### Mapping & Location
```yaml
google_maps_flutter: ^2.2.2        # Google Maps integration
google_maps_flutter_web: ^0.5.11   # Web support for Google Maps
flutter_map: ^6.0.0                # Alternative mapping solution
latlong2: ^0.9.0                   # Latitude/longitude calculations
location: ^6.0.2                   # Location services
geocoding: ^2.0.4                  # Address geocoding
flutter_polyline_points: ^2.1.0    # Route polylines
```

#### Charts & Visualization
```yaml
fl_chart: ^0.66.0                  # Beautiful charts
mrx_charts: ^0.1.3                 # Lab data charts
syncfusion_flutter_charts: ^27.1.48 # Professional charts
graphic: ^2.6.0                    # Data-driven graphics
data_table_2: ^2.5.10              # Advanced data tables
```

#### Communication
```yaml
jitsi_meet: ^4.0.0                 # Video conferencing
flutter_webrtc: ^0.14.0            # WebRTC support
socket_io_client: ^2.0.3+1         # Real-time communication
audioplayers: ^5.2.1               # Audio playback
```

#### State Management & Navigation
```yaml
provider: ^6.0.5                   # State management
go_router: ^15.1.2                 # Declarative routing
url_strategy: ^0.2.0               # Clean URLs for web
```

#### UI Components
```yaml
curved_navigation_bar: ^1.0.3      # Animated navigation
carousel_slider: ^5.0.0            # Image carousels
cupertino_icons: ^1.0.8            # iOS style icons
```

#### Networking & Data
```yaml
dio: ^5.7.0                        # HTTP client
http: ^1.2.2                       # Alternative HTTP client
```

#### Web & Browser
```yaml
webview_flutter: ^4.2.1            # WebView widget
webview_flutter_web:               # Web platform support
url_launcher: ^6.2.5               # Open URLs
universal_html: ^2.2.1             # Cross-platform HTML
```

#### Utilities
```yaml
permission_handler:                # Runtime permissions
intl: ^0.18.1                     # Internationalization
uuid: ^3.0.7                      # UUID generation
```

### Dependency Compatibility Matrix

| Package | Android | iOS | Web | Notes |
|---------|---------|-----|-----|-------|
| google_maps_flutter | ✅ | ✅ | ✅ | Requires API key |
| flutter_map | ✅ | ✅ | ✅ | No API key needed |
| jitsi_meet | ✅ | ✅ | ❌ | Web not supported |
| flutter_webrtc | ✅ | ✅ | ✅ | Version 0.14.0+ |
| location | ✅ | ✅ | ✅ | Requires permissions |

## 🔌 API Integration

### REST API Service

```dart
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  ));
  
  Future<List<Location>> fetchLocations() async {
    try {
      final response = await _dio.get('/locations');
      return (response.data as List)
          .map((json) => Location.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Location> updateLocation(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/locations/$id', data: data);
      return Location.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout');
      case DioExceptionType.badResponse:
        return Exception('Server error: ${e.response?.statusCode}');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
```

### Geocoding API Usage

```dart
import 'package:geocoding/geocoding.dart';

class GeocodingService {
  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.country}';
      }
      return 'Unknown location';
    } catch (e) {
      print('Error getting address: $e');
      return 'Error loading address';
    }
  }
  
  Future<Location?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return locations.first;
      }
      return null;
    } catch (e) {
      print('Error getting coordinates: $e');
      return null;
    }
  }
}
```

## 🔧 Platform Specific Setup

### Android Configuration

#### 1. Update `android/app/build.gradle`

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.example.pick_location"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

dependencies {
    implementation 'com.android.support:multidex:1.0.3'
}
```

#### 2. Update `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>
    <uses-permission android:name="android.permission.BLUETOOTH"/>
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    
    <application
        android:label="Pick Location"
        android:icon="@mipmap/ic_launcher">
        
        <!-- Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="${GOOGLE_MAPS_API_KEY}"/>
        
        <activity
            android:name=".MainActivity"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
        </activity>
    </application>
</manifest>
```

#### 3. ProGuard Rules (if using)

Create `android/app/proguard-rules.pro`:

```proguard
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.android.gms.maps.** { *; }
```

### iOS Configuration

#### 1. Update `ios/Runner/Info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Location Permissions -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs your location to show you on the map</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>This app needs your location to track your route</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>This app needs your location for tracking and navigation</string>
    
    <!-- Camera & Microphone -->
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access for video calls</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>This app needs microphone access for video calls</string>
    
    <!-- Photo Library (if needed) -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs access to your photos</string>
    
    <!-- Background Modes -->
    <key>UIBackgroundModes</key>
    <array>
        <string>audio</string>
        <string>fetch</string>
        <string>location</string>
        <string>remote-notification</string>
        <string>voip</string>
    </array>
    
    <key>io.flutter.embedded_views_preview</key>
    <true/>
</dict>
</plist>
```

#### 2. Update `ios/Runner/AppDelegate.swift`

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### 3. Update `ios/Podfile`

```ruby
platform :ios, '12.0'

# CocoaPods analytics sends network stats synchronously
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist."
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found."
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

### Web Configuration

#### 1. Update `web/index.html`

```html
<!DOCTYPE html>
<html>
<head>
  <base href="$FLUTTER_BASE_HREF">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="Pick Location - Location tracking app">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="Pick Location">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">
  <link rel="icon" type="image/png" href="favicon.png"/>
  <title>Pick Location</title>
  <link rel="manifest" href="manifest.json">
  
  <!-- Google Maps JavaScript API -->
  <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY"></script>
  
  <style>
    body {
      margin: 0;
      padding: 0;
    }
  </style>
</head>
<body>
  <script>
    window.addEventListener('load', function(ev) {
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: serviceWorkerVersion,
        }
      }).then(function(engineInitializer) {
        return engineInitializer.initializeEngine();
      }).then(function(appRunner) {
        return appRunner.runApp();
      });
    });
  </script>
  <script src="flutter.js" defer></script>
</body>
</html>
```

#### 2. Update `web/manifest.json`

```json
{
    "name": "Pick Location",
    "short_name": "PickLoc",
    "start_url": ".",
    "display": "standalone",
    "background_color": "#0175C2",
    "theme_color": "#0175C2",
    "description": "Location tracking and mapping application",
    "orientation": "portrait-primary",
    "prefer_related_applications": false,
    "icons": [
        {
            "src": "icons/Icon-192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-512.png",
            "sizes": "512x512",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-maskable-192.png",
            "sizes": "192x192",
            "type": "image/png",
            "purpose": "maskable"
        },
        {
            "src": "icons/Icon-maskable-512.png",
            "sizes": "512x512",
            "type": "image/png",
            "purpose": "maskable"
        }
    ]
}
```

## 🏗️ Building

### Development Builds

```bash
# Android Debug APK
flutter build apk --debug

# iOS Debug
flutter build ios --debug

# Web Debug
flutter build web --web-renderer html
```

### Release Builds

```bash
# Android Release APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release --target-platform android-arm,android-arm64,android-x64

# iOS Release (requires Mac)
flutter build ios --release
# Then open ios/Runner.xcworkspace in Xcode and archive

# Web Release
flutter build web --release --web-renderer canvaskit

# Web with HTML renderer (better compatibility)
flutter build web --release --web-renderer html
```

### Build Optimization

```bash
# Split APKs per ABI (smaller download size)
flutter build apk --split-per-abi

# Enable obfuscation
flutter build apk --obfuscate --split-debug-info=/symbols

# Enable tree shaking (remove unused code)
flutter build apk --release --tree-shake-icons
```

### Platform Specific Build Commands

#### Android

```bash
# Clean build
cd android && ./gradlew clean && cd ..

# Build with custom flavor
flutter build apk --flavor production --release

# Build specific ABI
flutter build apk --target-platform android-arm64
```

#### iOS

```bash
# Clean build
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..

# Build for device
flutter build ios --release

# Build for simulator
flutter build ios --debug
```

## 🧪 Testing

### Unit Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/location_service_test.dart

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

### Widget Tests

```dart
// Example widget test
import 'package:flutter_test/flutter_test.dart';
import 'package:pick_location/widgets/location_card.dart';

void main() {
  testWidgets('LocationCard displays location info', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LocationCard(
          latitude: 37.7749,
          longitude: -122.4194,
          address: 'San Francisco, CA',
        ),
      ),
    );

    expect(find.text('San Francisco, CA'), findsOneWidget);
    expect(find.text('37.7749'), findsOneWidget);
  });
}
```

### Integration Tests

```bash
# Run integration tests
flutter test integration_test/app_test.dart

# Run on specific device
flutter drive --target=test_driver/app.dart
```

### Test Coverage Goals
- Unit Tests: > 80% coverage
- Widget Tests: All custom widgets
- Integration Tests: Critical user flows

## 🐛 Troubleshooting

### Common Issues

#### 1. Google Maps Not Showing

**Problem**: White screen or blank map

**Solutions**:
```bash
# Check API key is correct
# Verify billing is enabled on Google Cloud Console
# Ensure Maps SDK is enabled

# Android: Check build.gradle has correct settings
# iOS: Check Info.plist has correct permissions
# Web: Check index.html has correct script tag
```

#### 2. Location Permission Denied

**Problem**: Cannot access user location

**Solutions**:
```dart
// Check permission status
PermissionStatus status = await Permission.location.status;

// Request permission if not granted
if (status.isDenied) {
  await Permission.location.request();
}

// Handle permanently denied
if (status.isPermanentlyDenied) {
  openAppSettings();
}
```

#### 3. Video Call Not Working

**Problem**: Black screen or connection issues

**Solutions**:
```bash
# Check camera/microphone permissions
# Verify Jitsi server URL is correct
# Test network connectivity
# Update flutter_webrtc to latest version

# For iOS: Check Info.plist permissions
# For Android: Check AndroidManifest.xml permissions
```

#### 4. Build Failures

**Problem**: Gradle or build errors

**Solutions**:
```bash
# Clean project
flutter clean
flutter pub get

# Update dependencies
flutter pub upgrade

# Clear gradle cache (Android)
cd android && ./gradlew clean
rm -rf .gradle

# Update CocoaPods (iOS)
cd ios
pod deintegrate
pod install
```

#### 5. WebView Issues on Web

**Problem**: WebView not rendering on web platform

**Solution**:
```dart
// Use conditional imports
import 'package:webview_flutter/webview_flutter.dart' 
  if (dart.library.html) 'package:webview_flutter_web/webview_flutter_web.dart';
```

#### 6. Socket Connection Timeout

**Problem**: Socket.IO not connecting

**Solutions**:
```dart
// Increase timeout
socket = IO.io('your-url', <String, dynamic>{
  'transports': ['websocket'],
  'timeout': 10000, // 10 seconds
  'autoConnect': true,
});

// Add error handlers
socket.onConnectError((data) => print('Connect Error: $data'));
socket.onError((data) => print('Error: $data'));
```

### Debugging Commands

```bash
# Enable verbose logging
flutter run --verbose

# Check device logs
flutter logs

# Profile performance
flutter run --profile

# Analyze code
flutter analyze

# Format code
flutter format .

# Check for outdated packages
flutter pub outdated
```

### Performance Issues

#### Memory Leaks
```dart
// Always dispose controllers
@override
void dispose() {
  mapController.dispose();
  audioPlayer.dispose();
  socket.disconnect();
  super.dispose();
}
```

#### Slow Map Rendering
```bash
# Use lite mode for Google Maps
GoogleMap(
  liteModeEnabled: true,
  // ... other properties
)

# Limit markers on map
if (markers.length > 100) {
  markers = markers.sublist(0, 100);
}
```

## ⚡ Performance

### Optimization Tips

#### 1. Map Performance
```dart
// Use marker clustering for many markers
// Limit visible markers based on zoom level
// Cache map tiles for offline use
// Use lite mode when appropriate

GoogleMap(
  liteModeEnabled: Platform.isAndroid,
  markers: _visibleMarkers, // Only show markers in viewport
  onCameraMove: _updateVisibleMarkers,
)
```

#### 2. Chart Optimization
```dart
// Limit data points
final maxDataPoints = 100;
if (dataPoints.length > maxDataPoints) {
  dataPoints = _downsample(dataPoints, maxDataPoints);
}

// Use const constructors where possible
const LineChart(/* ... */);
```

#### 3. State Management
```dart
// Use selective rebuilds with Consumer
Consumer<LocationProvider>(
  builder: (context, provider, child) {
    return Text('${provider.currentPosition}');
  },
)

// Avoid unnecessary notifyListeners()
if (_position != newPosition) {
  _position = newPosition;
  notifyListeners();
}
```

#### 4. Image Optimization
```bash
# Compress images before adding to assets
# Use appropriate image formats (WebP for web)
# Provide multiple resolutions (1x, 2x, 3x)
```

#### 5. Network Optimization
```dart
// Implement request caching
final cacheOptions = CacheOptions(
  store: MemCacheStore(),
  maxAge: Duration(hours: 1),
);

// Batch API requests
Future<void> batchUpdate(List<Location> locations) async {
  await Future.wait(locations.map((loc) => updateLocation(loc)));
}
```

### Performance Monitoring

```dart
import 'dart:developer' as developer;

void monitorPerformance() {
  final timeline = Timeline.startSync('MapRendering');
  // Your code here
  timeline.finish();
}

// Use DevTools for profiling
// flutter run --profile
// Open DevTools in browser
```

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Getting Started

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter format` before committing
- Run `flutter analyze` and fix all issues
- Write meaningful commit messages

### Pull Request Process

1. Update README.md with any new dependencies or features
2. Add tests for new functionality
3. Ensure all tests pass (`flutter test`)
4. Update documentation as needed
5. Request review from maintainers

### Commit Message Format

```
type(scope): subject

body

footer
```

Types: feat, fix, docs, style, refactor, test, chore

Example:
```
feat(map): add marker clustering

Implement marker clustering to improve performance with many markers
Uses custom clustering algorithm for better user experience

Closes #123
```

## 🗺️ Roadmap

### Version 1.1.0 (Q1 2026)
- [ ] Offline map support with caching
- [ ] Multi-language support (i18n)
- [ ] Dark mode theme
- [ ] Route optimization algorithms
- [ ] Export location history to CSV/PDF

### Version 1.2.0 (Q2 2026)
- [ ] AR navigation features
- [ ] Voice commands integration
- [ ] Advanced analytics dashboard
- [ ] Team collaboration features
- [ ] Custom map styles

### Version 2.0.0 (Q3 2026)
- [ ] Machine learning route predictions
- [ ] Integration with popular mapping services
- [ ] Desktop support (Windows, macOS, Linux)
- [ ] Advanced reporting and insights
- [ ] Enterprise features

### Future Considerations
- Wearable device integration
- Offline voice navigation
- Public API for third-party integrations
- Marketplace for custom plugins

## 📄 License

This project is private and not published to pub.dev. All rights reserved.

For commercial use, please contact the maintainers.

## 👥 Authors

- **Your Name** - *Initial work* - [YourGitHub](https://github.com/yourusername)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Maps Platform for mapping services
- Jitsi Meet for video calling infrastructure
- All open-source contributors whose packages made this possible

## 📞 Support

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)
- [Provider Documentation](https://pub.dev/packages/provider)

### Community
- Stack Overflow: Tag questions with `flutter` and `pick-location`
- GitHub Issues: Report bugs and feature requests
- Discord: Join our community server (link)

### Contact
- Email: support@picklocation.com
- Twitter: [@picklocation](https://twitter.com/picklocation)
- Website: https://picklocation.com

---

<div align="center">

Made with ❤️ using Flutter

**[Website](https://picklocation.com)** • **[Documentation](https://docs.picklocation.com)** • **[Report Bug](https://github.com/yourusername/pick_location/issues)** • **[Request Feature](https://github.com/yourusername/pick_location/issues)**

</div>
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/crafty_bay_app.dart';
import 'firebase_options.dart';

// Business layer Q&N
// Scope of Work - Crafty Bay App
// Design - UI/UX -> Q&A
// Project Initiate -> Define Project version

// ----------- Coding -------------

// ETC -> Easy to Change
// SOC -> Separation of Concerns

// Set up Firebase
// Crashlytics
// Analytics
// Project structure -> MMVM, clean Arc, MVP, Onion

// Layer first architecture/Structure
// Feature first "

// Theming
// Navigator


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const CraftyBayApp());
}
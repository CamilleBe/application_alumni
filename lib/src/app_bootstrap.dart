// ignore_for_file: missing_provider_scope
import 'dart:async';
import 'dart:ui';

import 'package:ekod_alumni/firebase_options.dart';
import 'package:ekod_alumni/src/app/app.dart';
import 'package:ekod_alumni/src/exceptions/exceptions.dart';
import 'package:ekod_alumni/src/features/authentication/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Helper class to initialize services and configure the error handlers.
class AppBootstrap {
  /// Create the root widget that should be passed to [runApp].
  Widget createRootWidget() {
    // * Create the ProviderContainer and initialize
    // * the [UserTokenRefreshService]
    final container = ProviderContainer(
      observers: [AsyncErrorLogger()],
    )..read(userTokenRefreshServiceProvider);

    // * Register error handlers. For more info, see: https://docs.flutter.dev/testing/errors
    final errorLogger = container.read(errorLoggerProvider);
    registerErrorHandlers(errorLogger);

    return UncontrolledProviderScope(
      container: container,
      child: const App(),
    );
  }

  /// Register Flutter error handlers.
  void registerErrorHandlers(ErrorLogger errorLogger) {
    // * Show some error UI if any uncaught exception happens
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      errorLogger.logError(details.exception, details.stack);
    };

    // * Handle errors from the underlying platform/OS
    PlatformDispatcher.instance.onError = (error, stack) {
      errorLogger.logError(error, stack);
      return true;
    };

    // * Show some error UI when any widget in the app fails to build
    ErrorWidget.builder = (details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: Text('An error occurred'),
        ),
        body: Center(
          child: Text(details.toString()),
        ),
      );
    };
  }
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Create an app bootstrap instance
  final appBootstrap = AppBootstrap();

  final root = appBootstrap.createRootWidget();

  // Start the app
  runApp(root);
}

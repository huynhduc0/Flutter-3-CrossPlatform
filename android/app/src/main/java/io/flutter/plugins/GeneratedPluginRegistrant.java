package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.deviceinfo.DeviceInfoPlugin;
import io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin;
import io.flutter.plugins.googlesignin.GoogleSignInPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    DeviceInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.deviceinfo.DeviceInfoPlugin"));
    FlutterFirebaseCorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin"));
    FlutterFirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin"));
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    FlutterSecureStoragePlugin.registerWith(registry.registrarFor("com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin"));
    GoogleSignInPlugin.registerWith(registry.registrarFor("io.flutter.plugins.googlesignin.GoogleSignInPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}

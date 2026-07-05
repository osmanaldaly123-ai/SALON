import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../config/env.dart';
import 'firebase_initializer.dart';

/// Thin wrapper around Firebase Realtime Database for list/read operations.
class RealtimeDatabaseClient {
  RealtimeDatabaseClient() {
    if (!Env.isFirebaseDatabaseConfigured) {
      throw StateError(
        'FIREBASE_DATABASE_URL is not set. Pass --dart-define=FIREBASE_DATABASE_URL=...',
      );
    }
    _database = FirebaseDatabase.instanceFor(
      app: FirebaseInitializer.databaseApp(),
      databaseURL: Env.firebaseDatabaseUrl,
    );
  }

  late final FirebaseDatabase _database;

  DatabaseReference ref(String path) => _database.ref(path);

  /// Reads children under [path] as a list of maps (each child becomes one row).
  Future<List<Map<String, dynamic>>> listChildren(String path) async {
    final snapshot = await ref(path).get();
    return _snapshotToList(snapshot, path);
  }

  /// Reads a single child node.
  Future<Map<String, dynamic>?> getChild(String path, String id) async {
    final snapshot = await ref('$path/$id').get();
    if (!snapshot.exists || snapshot.value == null) return null;
    final map = _toMap(snapshot.value);
    map.putIfAbsent('id', () => id);
    return map;
  }

  /// Ping database connectivity (used for smoke tests).
  Future<bool> ping() async {
    try {
      await ref('.info/connected').get();
      return true;
    } catch (e) {
      debugPrint('Firebase RTDB ping failed: $e');
      return false;
    }
  }

  List<Map<String, dynamic>> _snapshotToList(DataSnapshot snapshot, String path) {
    if (!snapshot.exists || snapshot.value == null) return [];

    final value = snapshot.value;
    if (value is Map<Object?, Object?>) {
      return value.entries.map((entry) {
        final map = _toMap(entry.value);
        map.putIfAbsent('id', () => entry.key.toString());
        return map;
      }).toList();
    }

    if (value is List<Object?>) {
      return value.asMap().entries.map((entry) {
        if (entry.value == null) return <String, dynamic>{'id': '${entry.key}'};
        final map = _toMap(entry.value);
        map.putIfAbsent('id', () => entry.key.toString());
        return map;
      }).toList();
    }

    debugPrint('Unexpected RTDB shape at $path: ${value.runtimeType}');
    return [];
  }

  Map<String, dynamic> _toMap(Object? value) {
    if (value is Map<Object?, Object?>) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return {};
  }
}

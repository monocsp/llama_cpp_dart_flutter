import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'llama_cpp_dart_platform_interface.dart';

/// An implementation of [LlamaCppDartPlatform] that uses method channels.
class MethodChannelLlamaCppDart extends LlamaCppDartPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('llama_cpp_dart');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

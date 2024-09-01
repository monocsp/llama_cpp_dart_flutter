import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'llama_cpp_dart_method_channel.dart';

abstract class LlamaCppDartPlatform extends PlatformInterface {
  /// Constructs a LlamaCppDartPlatform.
  LlamaCppDartPlatform() : super(token: _token);

  static final Object _token = Object();

  static LlamaCppDartPlatform _instance = MethodChannelLlamaCppDart();

  /// The default instance of [LlamaCppDartPlatform] to use.
  ///
  /// Defaults to [MethodChannelLlamaCppDart].
  static LlamaCppDartPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LlamaCppDartPlatform] when
  /// they register themselves.
  static set instance(LlamaCppDartPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

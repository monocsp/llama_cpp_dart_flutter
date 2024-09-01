#ifndef FLUTTER_PLUGIN_LLAMA_CPP_DART_PLUGIN_H_
#define FLUTTER_PLUGIN_LLAMA_CPP_DART_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace llama_cpp_dart {

class LlamaCppDartPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  LlamaCppDartPlugin();

  virtual ~LlamaCppDartPlugin();

  // Disallow copy and assign.
  LlamaCppDartPlugin(const LlamaCppDartPlugin&) = delete;
  LlamaCppDartPlugin& operator=(const LlamaCppDartPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace llama_cpp_dart

#endif  // FLUTTER_PLUGIN_LLAMA_CPP_DART_PLUGIN_H_

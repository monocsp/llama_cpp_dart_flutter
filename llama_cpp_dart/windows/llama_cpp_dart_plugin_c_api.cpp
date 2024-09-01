#include "include/llama_cpp_dart/llama_cpp_dart_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "llama_cpp_dart_plugin.h"

void LlamaCppDartPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  llama_cpp_dart::LlamaCppDartPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

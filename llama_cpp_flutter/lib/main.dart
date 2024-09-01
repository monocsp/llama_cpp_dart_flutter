import 'dart:async';

import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'package:llama_cpp_dart/llama_cpp_dart.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter llama.cpp Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _modelPathController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  LlamaProcessor? llamaProcessor;
  StreamSubscription<String>? _streamSubscription;
  bool isModelLoaded = false;
  ContextParams contextParams = ContextParams();

  @override
  void initState() {
    super.initState();
    _modelPathController.text = "";
    _promptController.text = "### Human: divide by zero please\n### Assistant:";

    int size = 32768;
    size = 8192 * 4;
    contextParams.batch = 8192 ~/ 4;
    contextParams.context = size;
    contextParams.ropeFreqBase = 57200 * 4;
    contextParams.ropeFreqScale = 0.75 / 4;
    // _extractModel();
  }

  /*static */ _extractModel() async {
    String model = "model-00004-of-00004.safetensors";

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$model';

    final fileExists = await File(filePath).exists();
    if (!fileExists) {
      final byteData = await rootBundle.load('assets/models/$model');
      final file = File(filePath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }

    _modelPathController.text = filePath;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Model Interaction'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _modelPathController,
                decoration: const InputDecoration(
                  labelText: 'Model Path',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _promptController,
                decoration: const InputDecoration(
                  labelText: 'Prompt',
                  border: OutlineInputBorder(),
                ),
                minLines: 5,
                maxLines: null,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TextField(
                    controller: _resultController,
                    decoration: const InputDecoration(
                      labelText: 'Result',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top),
              ),
              const SizedBox(height: 10),
              Text(isModelLoaded ? 'Model Loaded' : 'Model Not Loaded'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // llamaProcessor = LlamaProcessor( _modelPathController.text);
                      llamaProcessor = LlamaProcessor(
                          contextParams: contextParams,
                          modelParams: ModelParams(),
                          path: "assets/models/mistral-7b-openorca.Q5_K_M.gguf",
                          samplingParams: SamplingParams(),
                          onDone: () {});
                      setState(() {
                        isModelLoaded = true;
                      });
                    },
                    child: const Text('Load Model'),
                  ),
                  ElevatedButton(
                    onPressed: isModelLoaded
                        ? () {
                            llamaProcessor?.unloadModel();
                            setState(() {
                              isModelLoaded = false;
                            });
                          }
                        : null,
                    child: const Text('Unload Model'),
                  ),
                  ElevatedButton(
                    onPressed: isModelLoaded
                        ? () {
                            _streamSubscription?.cancel();
                            _resultController.text = "";
                            _streamSubscription =
                                llamaProcessor?.stream.listen((data) {
                              _resultController.text += data;
                            }, onError: (error) {
                              _resultController.text = "Error: $error";
                            }, onDone: () {});
                            llamaProcessor?.prompt(_promptController.text);
                          }
                        : null,
                    child: const Text('Generate Answer'),
                  ),
                  ElevatedButton(
                    onPressed: isModelLoaded
                        ? () {
                            llamaProcessor?.stop();
                          }
                        : null,
                    child: const Text('Stop Generation'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _modelPathController.dispose();
    _promptController.dispose();
    _resultController.dispose();
    llamaProcessor?.unloadModel();
    super.dispose();
  }
}

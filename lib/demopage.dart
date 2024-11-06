import 'dart:typed_data';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class DemoPageView extends StatefulWidget {
  const DemoPageView({super.key});

  @override
  State<DemoPageView> createState() => _DemoPageViewState();
}

class _DemoPageViewState extends State<DemoPageView> {
  ArCoreController? arCoreController;

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AR view"),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onPlaneTap = _onPlaneTapHandler;
  }

  Future<Uint8List> getImageBytes(String imageName) async {
    final ByteData data = await rootBundle.load('assets/$imageName');
    return data.buffer.asUint8List();
  }

  void _onPlaneTapHandler(List<ArCoreHitTestResult> hitTestResults) {
    if (hitTestResults.isNotEmpty) {
      final hit = hitTestResults.first;
      _addImageAtAnchor(hit);
    }
  }

  void _addImageAtAnchor(ArCoreHitTestResult hit) async {
    // Load the image bytes from assets
    final imageBytes = await getImageBytes("harry.png");

    // Create the AR image node
    final node = ArCoreNode(
      image: ArCoreImage(bytes: imageBytes, width: 200, height: 200),
      position: hit.pose.translation,
      rotation: hit.pose.rotation,
    );

    arCoreController?.addArCoreNodeWithAnchor(node);
  }
}

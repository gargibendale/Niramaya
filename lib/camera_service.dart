import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraService with ChangeNotifier {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;

  CameraService() {
    _initializeCamera();
  }

  CameraController? get controller => _controller;
  List<CameraDescription>? get cameras => _cameras;
  int get selectedCameraIndex => _selectedCameraIndex;

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _initCameraController(_cameras![_selectedCameraIndex]);
  }

  void _initCameraController(CameraDescription cameraDescription) {
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    _controller?.initialize().then((_) {
      notifyListeners();
    }).catchError((e) {
      print('Error initializing camera: $e');
    });
  }

  void switchCamera() {
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    _initCameraController(_cameras![_selectedCameraIndex]);
  }

  Future<void> disposeController() async {
    await _controller?.dispose();
  }
}

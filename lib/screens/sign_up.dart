import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

import '../const.dart';

late List<CameraDescription> _cameras;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late Future<PermissionStatus> cameraStatus;
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  int _cameraIndex = 0;
  bool _canSignUp = true;
  final AlertDialog _permissionDeniedDialog = AlertDialog(
    title: const Text("Permission denied"),
    content: const Text("We need to access camera to identity"),
    actions: [
      TextButton(
          onPressed: () {
            Permission.camera.request();
          },
          child: const Text("OK")),
      TextButton(onPressed: () {}, child: const Text("Cancel")),
    ],
  );

  void changeCamera() {
    setState(() {
      _isCameraInitialized = false;
      _cameraIndex++;
      if (_cameraIndex == _cameras.length) {
        _cameraIndex = 0;
      }
    });
    _cameraController =
        CameraController(_cameras[_cameraIndex], ResolutionPreset.high);
    _cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isCameraInitialized = true;
        // _cameraIndex++;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    () async {
      cameraStatus = Permission.camera.status;
      _cameras = await availableCameras();
      _cameraController =
          CameraController(_cameras[_cameraIndex], ResolutionPreset.high);
      _cameraController.initialize().then((value) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isCameraInitialized = true;
          // _cameraIndex++;
        });
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              {
                log("Camera access denied");
                break;
              }
            default:
              {
                log(e.toString());
              }
          }
        }
      });
    }();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasError || _cameras.length == 0) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("There's some error or this device has no camera"),
                actions: [
                  TextButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: Text("Exit")),
                ],
              );
            } else {
              if (snapshot.data == PermissionStatus.denied) {
                return _permissionDeniedDialog;
              }
            }
            if (!_isCameraInitialized) {
              return Container(
                alignment: Alignment.center,
                child: const AlertDialog(
                  title: Text("Waitting ..."),
                  content: Text("Waiting for camera to ready"),
                ),
              );
            }
            return Stack(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_cameraController),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Positioned(
                    child: Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.none,
                      type: MaterialType.button,
                      animationDuration: Duration.zero,
                      child: IconButton(
                        alignment: Alignment.center,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          changeCamera();
                        },
                        icon: const Icon(
                          Icons.cameraswitch,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 8,
                          child: Material(
                            color: Colors.transparent,
                            child: TextField(
                              maxLines: 1,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  fillColor: Constants.backgroundColor,
                                  focusColor: Constants.backgroundColor,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.buttonColor
                            ),
                            onPressed: _canSignUp ? changeCamera : null,
                            child: Text("Sign up"),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

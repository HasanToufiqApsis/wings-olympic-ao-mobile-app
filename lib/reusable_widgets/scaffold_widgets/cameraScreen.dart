import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/constant_variables.dart';
import '../../services/helper.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera';

  final CameraLensDirection? cameraType;

  const CameraScreen({Key? key, required this.cameraType}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  CameraDescription? backCamera, frontCamera, initialCamera;

  @override
  void initState() {
    _getAvailableCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future _getAvailableCamera() async {
    cameras = await availableCameras();

    for (var i = 0; i < cameras.length; i++) {
      var camera = cameras[i];
      if (camera.lensDirection == CameraLensDirection.back) {
        backCamera = camera;
      }
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
      }
    }
    backCamera ??= cameras.first;
    frontCamera ??= cameras.last;
    initialCamera = backCamera;

    if(widget.cameraType != null && widget.cameraType == CameraLensDirection.front) {
      initialCamera = frontCamera;
    }

    _cameraController = CameraController(
      initialCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    ///
    // await _cameraController!.lockCaptureOrientation(DeviceOrientation.portraitUp);
    await _cameraController?.initialize();
    Helper.dPrint(
        'camera aspect ratio:: ${_cameraController?.value.aspectRatio}');

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!(_cameraController?.value.isInitialized ?? false)) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CameraPreview(_cameraController!),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkResponse(
                    onTap: () {
                      if (_cameraController?.description.lensDirection ==
                          CameraLensDirection.back) {
                        _cameraController = CameraController(
                            frontCamera!, ResolutionPreset.medium);
                      } else {
                        _cameraController = CameraController(
                            backCamera!, ResolutionPreset.medium);
                      }

                      _cameraController?.initialize().then((_) {
                        if (!mounted) {
                          return;
                        }
                        setState(() {});
                      });
                    },
                    child: Container(
                      height: 44,
                      width: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: .5,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.flip_camera_android,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkResponse(
                    onTap: () async {
                      await _cameraController?.takePicture().then((value) {
                        Navigator.pop(context, value.path);
                      });
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: .5,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  InkResponse(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 44,
                      width: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: .5,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class CameraScreen extends StatefulWidget {
//   static const routeName = '/camera';
//
//   const CameraScreen({Key? key}) : super(key: key);
//
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? _cameraController;
//   CameraDescription? backCamera, frontCamera;
//   List<CameraDescription> cameras = [];
//
//   @override
//   void initState() {
//     _getAvailableCamera();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }
//
//   Future _getAvailableCamera() async {
//     cameras = await availableCameras();
//
//     for (var i = 0; i < cameras.length; i++) {
//       var camera = cameras[i];
//       if (camera.lensDirection == CameraLensDirection.back) {
//         backCamera = camera;
//       }
//       if (camera.lensDirection == CameraLensDirection.front) {
//         frontCamera = camera;
//       }
//     }
//     backCamera ??= cameras.first;
//     frontCamera ??= cameras.last;
//
//     _cameraController = CameraController(
//       backCamera!,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//
//     await _cameraController?.initialize();
//     Helper.dPrint(
//         'camera aspect ratio:: ${_cameraController?.value.aspectRatio}');
//
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!(_cameraController?.value.isInitialized ?? false)) {
//       return const Scaffold(backgroundColor: Colors.black);
//     }
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.black,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.white.withOpacity(0.05),
//                       blurRadius: 10,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: CameraPreview(_cameraController!),
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(24),
//                   topRight: Radius.circular(24),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 10,
//                     offset: const Offset(0, -3),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildOptionButton(
//                     icon: Icons.flip_camera_android_rounded,
//                     color: Colors.blue[700]!,
//                     bgColor: Colors.blue.withOpacity(0.1),
//                     onTap: () {
//                       if (_cameraController?.description.lensDirection ==
//                           CameraLensDirection.back) {
//                         _cameraController = CameraController(
//                             frontCamera!, ResolutionPreset.medium);
//                       } else {
//                         _cameraController = CameraController(
//                             backCamera!, ResolutionPreset.medium);
//                       }
//
//                       _cameraController?.initialize().then((_) {
//                         if (!mounted) {
//                           return;
//                         }
//                         setState(() {});
//                       });
//                     },
//                   ),
//                   InkResponse(
//                     onTap: () async {
//                       await _cameraController?.takePicture().then((value) {
//                         Navigator.pop(context, value.path);
//                       });
//                     },
//                     child: Container(
//                       height: 72,
//                       width: 72,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           width: 4,
//                           color: Colors.grey[200]!,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Container(
//                         height: 54,
//                         width: 54,
//                         decoration: BoxDecoration(
//                           color: Colors.red[500],
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.camera_alt_rounded,
//                           color: Colors.white,
//                           size: 28,
//                         ),
//                       ),
//                     ),
//                   ),
//                   _buildOptionButton(
//                     icon: Icons.close_rounded,
//                     color: Colors.red[700]!,
//                     bgColor: Colors.red.withOpacity(0.1),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOptionButton({
//     required IconData icon,
//     required Color color,
//     required Color bgColor,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           height: 50,
//           width: 50,
//           decoration: BoxDecoration(
//             color: bgColor,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: color.withOpacity(0.1)),
//           ),
//           child: Icon(
//             icon,
//             color: color,
//             size: 24,
//           ),
//         ),
//       ),
//     );
//   }
// }
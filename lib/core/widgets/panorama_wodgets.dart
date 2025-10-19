// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:panorama/panorama.dart';
// import 'package:uyjoy/config/router/routes.dart';
//
// class PanoramaWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Panorama(
//         hotspots: [
//           Hotspot(
//             latitude: 0.1,
//             longitude: 1.0,
//             widgets: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const SecondRoom()),
//                 );
//               },
//               child: Icon(
//                 Icons.door_front_door,
//                 color: Colors.red,
//                 size: 50,
//               ),
//             ),
//           ),
//         ],
//         child: Image.asset("assets/eshik1.jpg"),
//       ),
//     );
//   }
// }
//
// class SecondRoom extends StatelessWidget {
//   const SecondRoom({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Panorama(
//         hotspots: [
//           Hotspot(
//             latitude: 0.1,
//             longitude: 1.0,
//             widgets: GestureDetector(
//               onTap: () {
//                 context.push(Routes.panorama);
//               },
//               child: Icon(
//                 Icons.door_front_door,
//                 color: Colors.red,
//                 size: 50,
//               ),
//             ),
//           ),
//         ],
//         child: Image.asset("assets/eshik2.jpg"),//
//       ),
//     );
//   }
// }

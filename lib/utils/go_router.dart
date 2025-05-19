import 'package:go_router/go_router.dart';
import 'package:pick_location/screens/caller_mobile_screen.dart';
import 'package:pick_location/screens/caller_screen.dart';
import 'package:pick_location/screens/dashboard_screen.dart';
import 'package:pick_location/screens/gis_map.dart';
import 'package:pick_location/screens/handasah_screen.dart';
import 'package:pick_location/screens/integration_with_stores_get_all_qty.dart';
import 'package:pick_location/screens/landing_screen.dart';
import 'package:pick_location/screens/login_screen.dart';
import 'package:pick_location/screens/mobile_emergency_room_screen.dart';
import 'package:pick_location/screens/receiver_mobile_screen.dart';
import 'package:pick_location/screens/receiver_screen.dart';
import 'package:pick_location/screens/report_screen.dart';
import 'package:pick_location/screens/request_tool_for_address_screen.dart';
import 'package:pick_location/screens/system_admin_screen.dart';
import 'package:pick_location/screens/tracking.dart';
import 'package:pick_location/screens/user_request_tools.dart';
import 'package:pick_location/screens/user_screen.dart';

import '../screens/address_to_coordinates_web.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/emergency',
      builder: (context, state) => const AddressToCoordinates(),
    ),
    GoRoute(
      path: '/handasah',
      builder: (context, state) => const HandasahScreen(),
    ),
    GoRoute(
      path: '/technician',
      builder: (context, state) => const UserScreen(),
    ),
    GoRoute(
      path: '/system-admin',
      builder: (context, state) => const SystemAdminScreen(),
    ),
    GoRoute(
      path: '/mobile-emergency-room',
      builder: (context, state) => const MobileEmergencyRoomScreen(),
    ),
    GoRoute(
      path: '/gis-map',
      builder: (context, state) => const GisMap(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const StationsDashboard(),
    ),
    GoRoute(
      path: '/report',
      builder: (context, state) => const ReportScreen(),
    ),
    GoRoute(
      path: '/caller',
      builder: (context, state) => const CallerScreen(),
    ),
    GoRoute(
      path: '/receiver',
      builder: (context, state) => const ReceiverScreen(),
    ),
    GoRoute(
      path: '/mobile-caller/:addressTitle',
      builder: (context, state) {
        final addressTitle = state.pathParameters['addressTitle']!;
        return CallerMobileScreen(addressTitle: addressTitle);
      },
    ),
    GoRoute(
      path: '/mobile-receiver/:addressTitle',
      builder: (context, state) {
        final addressTitle = state.pathParameters['addressTitle']!;
        return ReceiverMobileScreen(
          addressTitle: addressTitle,
        );
      },
    ),
    GoRoute(
      path: '/tracking/:latitude/:longitude/:address/:technicianName',
      builder: (context, state) {
        final latitude = state.pathParameters['latitude']!;
        final longitude = state.pathParameters['longitude']!;
        final address = state.pathParameters['address']!;
        final technicianName = state.pathParameters['technicianName']!;
        return Tracking(
          address: address,
          latitude: latitude,
          longitude: longitude,
          technicianName: technicianName,
        );
      },
    ),
    GoRoute(
      path: '/user-request-tool/:handasahName/:address/:technicianName',
      builder: (context, state) {
        final handasahName = state.pathParameters['handasahName']!;
        final address = state.pathParameters['address']!;
        final technicianName = state.pathParameters['technicianName']!;
        return UserRequestTools(
          handasahName: handasahName,
          address: address,
          technicianName: technicianName,
        );
      },
    ),
    GoRoute(
      path: '/request-tool-address/:address/:handasahName',
      builder: (context, state) {
        final address = state.pathParameters['address']!;
        final handasahName = state.pathParameters['handasahName']!;
        return RequestToolForAddressScreen(
          address: address,
          handasahName: handasahName,
        );
      },
    ),
    GoRoute(
      path: '/integrate-with-stores/:storeName',
      builder: (context, state) {
        final storeName = state.pathParameters['storeName']!;
        return IntegrationWithStoresGetAllQty(
          storeName: storeName,
        );
      },
    ),
    // GoRoute(
    //   path: '/agora',
    //   builder: (context, state) => const AgoraVideoCall(),
    // ),
  ],
);

//named arguments
// GoRoute(
//   path: '/product/:category/:productId',
//   builder: (context, state) {
//     final category = state.pathParameters['category']!;
//     final productId = state.pathParameters['productId']!;
//     return ProductPage(category: category, productId: productId);
//   },
// ),

// // In MaterialApp:
// MaterialApp.router(
//   routerConfig: router,
// );

// // To navigate:
// context.go('/myPage'); // or context.push('/myPage')

// final GoRouter _router = GoRouter(
//   routes: <RouteBase>[
//     GoRoute(
//       path: '/',
//       builder: (BuildContext context, GoRouterState state) {
//         return const HomeScreen();
//       },
//       routes: <RouteBase>[
//         GoRoute(
//           path: 'details',
//           builder: (BuildContext context, GoRouterState state) {
//             return const DetailsScreen();
//           },
//         ),
//       ],
//     ),
//   ],
// );

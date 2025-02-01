import 'dart:convert';

import 'package:dio/dio.dart';
// import 'package:pick_location/model/locations_marker_model.dart';
import 'package:pick_location/utils/dio_http_constants.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

class DioNetworkRepos {
  // Future getUsers() async {
  //   var dio = Dio();
  //   try {
  //     var response = await dio.get(url);
  //     return response.data;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     throw Exception(e);
  //   }
  // }

final dio = Dio();
//get locations(GET by flag 0 (address not set yet))
  Future getLoc() async {
    // var dio = Dio();
    try {
      var response = await dio.get(urlGet);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        debugPrint('List is empty');
        return [];
        // throw Exception('List is empty');
      }
    } catch (e) {
      debugPrint(e.toString());
      // throw Exception(e);
    }
  }

//update locations
  Future updateLoc(String address, double longitude, double latitude) async {
    // var dio = Dio();
    try {
      final response = await dio.put(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/$address",
          data: {
            "longitude": longitude,
            "latitude": latitude,
            "flag": 1,
          });
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//update locations(wiht-url)
  Future<void> updateLocations(
      String address, double longitude, double latitude, String url) async {
    // var dio = Dio();
    try {
      var response = await dio.put(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/$address",
          data: {
            "longitude": longitude,
            "latitude": latitude,
            "flag": 1,
            "gis_url": url
          });
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  //POST in GIS Server and GET MAP Link
  Future<String> createNewGisPointAndGetMapLink(
      int id, String longitude, String latitude) async {
    // var dio = Dio();
    // Encode credentials to Base64
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    try {
      final response = await dio.post(gisUrl,
          data: {
            "uid": id,
            "x": longitude,
            "y": latitude,
          },
          options: Options(
            headers: {
              'authorization': basicAuth,
            },
          ));
      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  //GET USERNAME AND PASSWORD
  //Login User using username and password(working)
  Future<bool> loginByUsernameAndPassword(
      String username, String password) async {
    // var dio = Dio();
    try {
      final response = await dio.get(
          "http://192.168.17.250:9999/pick-location/api/v1/users/$username/$password");
      if (response.statusCode == 200) {
        debugPrint("${response.data} from loginByUsernameAndPassword");
        final usernameResponse = response.data['username'];
        final passwordResponse = response.data['password'];
        debugPrint(
            'Login successful! Username: $usernameResponse, Password: $passwordResponse');
        return true;
      } else {
        debugPrint('Login failed: ${response.data}');
        return false;
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.response?.data ?? e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return false;
    }
  }

//Login User using username and password(working)
  Future<Map<String, dynamic>> login(String username, String password) async {
    // Replace with your API endpoint
    // var dio = Dio();

    try {
      // Sending GET request with query parameters
      Response response = await dio.get(
          "http://192.168.17.250:9999/pick-location/api/v1/users/$username/$password");

      if (response.statusCode == 200) {
        // Assuming the API returns JSON data
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Handling Dio errors
      if (e is DioException) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? e.message,
        };
      } else {
        return {
          'success': false,
          'message': 'An unexpected error occurred',
        };
      }
    }
  }

  //check if address exists
   Future<bool> checkAddressExists(String address) async {
    String encodedAddress = Uri.encodeComponent(address);
    String getAddressUrl = 'http://192.168.17.250:9999/pick-location/api/v1/get-loc/flag/0/address/$encodedAddress';

    try {
      var response = await dio.get(getAddressUrl);

      if (response.statusCode == 200) {
        debugPrint("PRINTED DATA FROM API: ${response.data}");
        return true;
      } else {
        debugPrint('Address not found');
        return false;
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      debugPrint("Unexpected error: $e");
      return false;
    }
  }

  //post locations(wiht-url)
  Future createNewLocation(
      String address, double longitude, double latitude, String url) async {
    var dio = Dio();
    try {
      var response = await dio.post(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc",
          data: {
            "address": address,
            "longitude": longitude,
            "latitude": latitude,
            "flag": 1,
            "gis_url": url
          });
      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//  Fetch Data from the Database(GET dropdown items for handasat)
  Future fetchHandasatItemsDropdownMenu() async {
    var dio = Dio();
    var getHandasatUrl =
        'http://192.168.17.250:9999/pick-location/api/v1/handasah/all';
    try {
      var response = await dio.get(getHandasatUrl);
      if (response.statusCode == 200) {
        // debugPrint(dataList);
        debugPrint("PRINTED DATA FROM API:  ${response.data}");

        return response.data;
      } else {
        debugPrint('List is empty');
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//  get last record number from GIS server (broken-number-generator)
  Future<int> getLastRecordNumber() async {
    var dio = Dio();
    var getLastRecordUrl = 'http://196.219.231.3:8000/lab-api/lab-id';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    try {
      var response = await dio.get(
        getLastRecordUrl,
        data: {"category": "gis_lab_api"},
        options: Options(
          headers: {
            'authorization': basicAuth,
          },
        ),
      );
      if (response.statusCode == 201) {
        // debugPrint(dataList);
        debugPrint("PRINTED DATA FROM API:  ${response.data}");

        return response.data;
      } else {
        debugPrint('List is empty');
        return 0;
        // throw Exception('List is empty');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//  Fetch Data from the Database(GET dropdown items for handasat users)
  // Future<List<String>> fetchItems() async {
  // final response = await http.get(Uri.parse('https://your-api.com/items'));
  // if (response.statusCode == 200) {
  //   List<dynamic> data = json.decode(response.body);
  //   return data.map((item) => item['address'].toString()).toList();
  // } else {
  //   throw Exception('Failed to load items');
  // }
}

//POST in GIS Server and GET MAP Link
//TODO:GET GIS map LINK (22-12-2024-NOT-TEST)
//   Future createNewGisPointAndGetMap(
//       String longitude,
//       String latitude, int id) async {
// // Future createNewGisPointAndGetMap(
// //       LocationsMarkerModel locationsMarkerModel) async{

//     var dio = Dio();
//     try {
//       final response = await dio
//           .post("http://192.168.17.250:8000/pick-location/api/", data: {
//         "uid": id,
//         "x": longitude,
//         "y": latitude,
//       });
//       if (response.statusCode == 201) {
//         return response.data;
//       } else {
//         throw Exception('Failed to post data');
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//       throw Exception(e);
//     }
//   }

//update locations using Constructor
//TODO: update locations using Constructor NOT TESTED(27-10-2024)
// Future updateLocs(LocationsMarkerModel locationsMarkerModel) async {
//   var dio = Dio();
//   try {
//     final response = await dio.put(
//         "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/$locationsMarkerModel.address",
//         data: {
//           "longitude": locationsMarkerModel.longitude,
//           "latitude": locationsMarkerModel.latitude,
//           "gis_url": locationsMarkerModel.url
//         });
//     return response.data;
//   } catch (e) {
//     debugPrint(e.toString());
//     throw Exception(e);
//   }
// }

//update locations using id
//TODO: update locations using id NOT TESTED(27-10-2024)
// Future updateLocationsById(
//     int id, LocationsMarkerModel locationsMarkerModel) async {
//   try {
//     List<LocationsMarkerModel> locationsList = [];
//     final locationIndex =
//         locationsList.indexWhere((element) => element.id == id);
//     var dio = Dio();

//     if (locationIndex >= 0) {
//       final response = await dio.put(
//           "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/$id",
//           data: {
//             "longitude": locationsMarkerModel.longitude,
//             "latitude": locationsMarkerModel.latitude,
//             "flag": 1,
//             "gis_url": locationsMarkerModel.url
//           });
//       locationsList[locationIndex] = locationsMarkerModel;
//       return response.data;
//     } else {
//       throw Exception('Location not found');
//     }
//   } catch (e) {
//     debugPrint(e.toString());
//     throw Exception(e);
//   }
// }

//POST in GIS Server
//TODO:POST in GIS Server (22-12-2024-NOT-TEST)
// Future createNewGisPoint(LocationsMarkerModel locationsMarkerModel) async{
//   var dio = Dio();
//   try {
//     final response = await dio.post(
//         "http://192.168.17.250:8000/pick-location/api/",
//         data: {
//           "y": locationsMarkerModel.longitude,
//           "x": locationsMarkerModel.latitude,
//           "uid": locationsMarkerModel.id,
//         });
//     return response.data;
//   } catch (e) {
//     debugPrint(e.toString());
//     throw Exception(e);
//   }
// }

// Future getLocs() async{
//   var response = await http.get(Uri.parse(url2));
//   if (response.statusCode == 200) {
//     return response.body;
//   }
//   else {
//     throw Exception('Failed to get data');
//   }
// }
// }

// UI VIEW for Dropdown
// import 'package:flutter/material.dart';

// class MyDropdownScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Custom Dropdown Menu")),
//       body: Center(
//         child: FutureBuilder<List<String>>(
//           future: fetchDropdownItems(), // Replace with your future method get from API
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (snapshot.hasData) {
//               return CustomDropdown(
//                 items: snapshot.data!,
//                 hintText: "Select an Item",
//                 onChanged: (value) {
//                   print('Selected item: $value');
//                 },
//               );
//             } else {
//               return Text('No items available');
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

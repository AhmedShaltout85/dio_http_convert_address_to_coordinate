import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pick_location/utils/dio_http_constants.dart';
import 'package:flutter/material.dart';

class DioNetworkRepos {
  final dio = Dio();
//1-- GET locations(GET by flag 0 (address not set yet))
  Future getLoc() async {
    try {
      var response = await dio.get(urlGetHotlineAddress);
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

//2-- GET locations(GET by flag 1 and isFinished 0)
  Future getLocByFlagAndIsFinished() async {
    try {
      var response = await dio.get(urlGetAllByFlagAndIsFinished);
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

//3-- GET locationsBy handasah(GET by handasah (handasah) and  isFinished 0)
  Future getLocByHandasahAndIsFinished(String handasah, int isFinished) async {
    var urlGetAllByHandasahAndIsFinished =
        'http://192.168.17.250:9999/pick-location/api/v1/get-loc/handasah/$handasah/is-finished/$isFinished';
    try {
      var response = await dio.get(urlGetAllByHandasahAndIsFinished);
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

//4-- GET locations(GET by Handasah free and Technician free)
  Future getLocByHandasahAndTechnician(
      String handasah, String technician) async {
    var urlGetAllByHandasahAndTechnician =
        'http://192.168.17.250:9999/pick-location/api/v1/get-loc/handasah/$handasah/technical/$technician'; //GET by Handasah free and Technician free
    try {
      var response = await dio.get(urlGetAllByHandasahAndTechnician);
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

//5-- UPDATE locations(by longitude and latitude)
  Future updateLoc(String address, double longitude, double latitude) async {
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

//6-- UPDATE locations By address (add handasahName)
  Future updateLocAddHandasah(String address, String? handasahName) async {
    try {
      final response = await dio.put(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc/handasah/$address",
          data: {
            "handasah_name": handasahName,
          });
      debugPrint(response.data.toString());

      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//7-- UPDATE locations By address (add technicianName)
  Future updateLocAddTechnician(String address, String? technicianName) async {
    try {
      final response = await dio.put(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc/technical/$address",
          data: {
            "technical_name": technicianName,
          });
      debugPrint(response.data.toString());

      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//8-- UPDATE locations By address (add isFinished)
  Future updateLocAddIsFinished(String address, int isFinished) async {
    try {
      final response = await dio.put(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc/is-finished/$address",
          data: {
            "is_finished": isFinished,
          });
      debugPrint(response.data.toString());

      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//9-- UPDATE locations(wiht-url)
  Future<void> updateLocations(
      String address, double longitude, double latitude, String url) async {
    try {
      var response = await dio.put(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/$address",
          data: {
            "longitude": longitude,
            "latitude": latitude,
            "flag": 1,
            "gis_url": url,
            "is_finished": 0,
            "handasah_name": "free",
            "technical_name": "free",
          });
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  //10-- POST in GIS Server and GET MAP Link
  Future<String> createNewGisPointAndGetMapLink(
      int id, String longitude, String latitude) async {
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

  //11-- GET USERNAME AND PASSWORD
  //Login User using username and password(working)
  Future<bool> loginByUsernameAndPassword(
      String username, String password) async {
    try {
      final response = await dio.get(
          "http://192.168.17.250:9999/pick-location/api/v1/users/$username/$password");
      if (response.statusCode == 200) {
        debugPrint("${response.data} from loginByUsernameAndPassword");
        final usernameResponse = response.data['username'];
        final passwordResponse = response.data['password'];
        DataStatic.userRole = response.data['role']; //not tested(18-02-2025)
        DataStatic.handasahName =
            response.data['handasah_name']; //not tested(18-02-2025)
        debugPrint(
            'Login successful! Username: $usernameResponse, Password: $passwordResponse , ID: $DataStatic.userRole');
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

//12-- LOGIN User using username and password(working)
  Future<Map<String, dynamic>> login(String username, String password) async {
    // Replace with your API endpoint

    try {
      // Sending GET request with query parameters
      Response response = await dio.get(
          "http://192.168.17.250:9999/pick-location/api/v1/users/$username/$password");

      if (response.statusCode == 200) {
        // Assuming the API returns JSON data
        DataStatic.userRole = response.data['role'];
        DataStatic.handasahName = response.data['controlUnit'];
        DataStatic.username = response.data['username'];
        // handasahName = response.data['controlUnit'];
        // userName = response.data['username'];
        debugPrint("PRINTED DATA FROM API: ${response.data['role']}");
        debugPrint("PRINTED DATA FROM API: ${response.data['controlUnit']}");
        debugPrint("PRINTED DATA FROM API: ${response.data['username']}");
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

  //13-- CHECK if address exists
  Future<bool> checkAddressExists(String address) async {
    String encodedAddress = Uri.encodeComponent(address);
    String getAddressUrl =
        // 'http://192.168.17.250:9999/pick-location/api/v1/get-loc/flag/0/address/$encodedAddress'; //updated 10-02-2025 not tested
        'http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/$encodedAddress';

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

  //14-- CHECK if address exists BY ADDRESS And HANDASAH
  Future<bool> checkAddressExistsByAddressAndHandasah(
      String address, String handasah) async {
    String encodedAddress = Uri.encodeComponent(address);
    String getAddressUrl =
        'http://192.168.17.250:9999/pick-location/api/v1/get-loc/flag/0/address/$encodedAddress/handasah/$handasah';

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

  //15-- POST locations(wiht-url)
  Future createNewLocation(
      String address, double longitude, double latitude, String url) async {
    try {
      var response = await dio.post(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc",
          data: {
            "address": address,
            "longitude": longitude,
            "latitude": latitude,
            "flag": 1,
            "gis_url": url,
            "is_finished": 0,
            "handasah_name": "free",
            "technical_name": "free",
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

//16-- FETCH Data from the Database(GET dropdown items for handasat)
  Future fetchHandasatItemsDropdownMenu() async {
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

  //17-- FETCH Data from the Database(GET dropdown items for handasat users)
  Future fetchHandasatUsersItemsDropdownMenu(String handasahName) async {
    var getHnadasatUsersUrl =
        'http://192.168.17.250:9999/pick-location/api/v1/users/role/3/control-unit/$handasahName';
    try {
      var response = await dio.get(getHnadasatUsersUrl);
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

//18-- FETCH Data from the Database(GET broken items for technicians users in handasat)
// http://localhost:9999/pick-location/api/v1/get-loc/handasah/handasah/technical/user/is-finished/0

  Future<List<Map<String, dynamic>>> fetchHandasatUsersItemsBroken(
      String handasahName, String technicianName, int isFinished) async {
    var getHnadasatUsersListUrl =
        'http://192.168.17.250:9999/pick-location/api/v1/get-loc/handasah/$handasahName/technical/$technicianName/is-finished/$isFinished';
    try {
      var response = await dio.get(getHnadasatUsersListUrl);

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          // If it's already a List, return it directly
          // debugPrint(dataList);
          debugPrint("PRINTED DATA FROM API:  ${[response.data]}");
          return List<Map<String, dynamic>>.from(response.data);
        } else if (response.data is Map<String, dynamic>) {
          // If it's a single Map, wrap it in a List
          return [response.data];
        } else {
          debugPrint("Unexpected response format: ${response.data}");
          return []; // Return an empty list if the format is unexpected
        }
      } else {
        debugPrint('List is empty');
        return [];
      }
    } catch (e) {
      debugPrint("API Error: $e");
      return []; // Return empty list on error
    }
  }

//19-- GET last record number from GIS server (broken-number-generator)
  Future<int> getLastRecordNumber() async {
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

//20-- GET last record number from GIS serverWEB (broken-number-generator)
  Future<int> getLastRecordNumberWeb() async {
    var getLastRecordUrlWeb = 'http://196.219.231.3:8000/lab-api/web-lab-id';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    try {
      var response = await dio.get(
        getLastRecordUrlWeb,
        // data: {"category": "gis_lab_api"},
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

  //21-- UPDATE locations By address (add isApproved)
  Future updateLocAddIsApproved(String address, int isApproved) async {
    try {
      final response = await dio.put(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc/is-approved/$address",
          data: {
            "is_approved": isApproved,
          });
      debugPrint(response.data.toString());

      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//22-- POST locations for tracking (sendLocationToBackend)
  Future<void> sendLocationToBackend(
      String address,
      String technicianName,
      double latitude,
      double longitude,
      double? currentLatitude,
      double? currentLongitude) async {
    final response = await dio.post(
      'http://192.168.17.250:9999/pick-location/api/v1/track-location',
      data: {
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'technicalName': technicianName,
        'startLatitude': currentLatitude,
        'startLongitude': currentLongitude,
        'currentLatitude': currentLatitude,
        'currentLongitude': currentLongitude,
      },
    );

    if (response.statusCode == 200) {
      debugPrint('Location sent successfully');
    } else {
      debugPrint('Failed to send location');
    }
  }

//23-- UPDATE locations for tracking (updateLocationToBackend)
  Future<void> updateLocationToBackend(String address,
      double currentLatitude, double currentLongitude) async {
    final response = await dio.put(
      'http://192.168.17.250:9999/pick-location/api/v1/track-location/address/$address',
      data: {
        'currentLatitude': currentLatitude,
        'currentLongitude': currentLongitude,
      },
    );

    if (response.statusCode == 200) {
      debugPrint('Location sent successfully');
    } else {
      debugPrint('Failed to send location');
    }
  }
  //23-- Get location for tracking By address And Technician (FETCH-LocationToBackend)
   Future getLocationByAddressAndTechnician(String address, String technicianName) async {
    var urlGetCertainLocationByAddressAndTechnician =
        'http://192.168.17.250:9999/pick-location/api/v1/track-location/address/$address/tech-name/$technicianName';
    try {
      var response = await dio.get(urlGetCertainLocationByAddressAndTechnician);
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

}

import 'package:dio/dio.dart';
import 'package:pick_location/model/locations_marker_model.dart';
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

//get locations(GET by flag 0 (address not set yet))
  Future getLoc() async {
    var dio = Dio();
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
  Future updateLoc(String address, double latitude, double longitude) async {
    var dio = Dio();
    try {
      final response = await dio.put(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/$address",
          data: {
            "latitude": latitude,
            "longitude": longitude,
            "flag": 1,
            "real_address": address
          });
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//update locations(update-29-12-2024) NOT TEST
  Future<void> updateLocations(
      String address, double latitude, double longitude) async {
    var dio = Dio();
    try {
      await dio.put(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/$address",
          data: {
            "latitude": latitude,
            "longitude": longitude,
            "flag": 1,
            "real_address": address
          });
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  //POST in GIS Server and GET MAP Link
//TODO:GET GIS map LINK (22-12-2024-NOT-TEST)
  Future createNewGisPointAndGetMap(
      String latitude, String longitude, int id) async {
// Future createNewGisPointAndGetMap(
//       LocationsMarkerModel locationsMarkerModel) async{

    var dio = Dio();
    try {
      final response = await dio
          .post("http://192.168.17.250:8000/pick-location/api/", data: {
        "x": latitude,
        "y": longitude,
        "uid": id,
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

  //POST in GIS Server and GET MAP Link
//TODO:GET GIS map LINK (29-12-2024-NOT-TEST)
  Future<void> createNewGisPointAndGetMapLink(
      String latitude, String longitude, int id) async {
// Future createNewGisPointAndGetMap(
//       LocationsMarkerModel locationsMarkerModel) async{

    var dio = Dio();
    try {
      final response = await dio
          .post("http://192.168.17.250:8000/pick-location/api/", data: {
        "x": latitude,
        "y": longitude,
        "uid": id,
      });
      if (response.statusCode == 201) {
        // return response.data;
        debugPrint('$response.data');

        LocationsMarkerModel locationsMarkerModel =
            LocationsMarkerModel.fromJson(response.data);
            
        debugPrint('$locationsMarkerModel.url');
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//update locations using Constructor
//TODO: update locations using Constructor NOT TESTED(27-10-2024)
  Future updateLocs(LocationsMarkerModel locationsMarkerModel) async {
    var dio = Dio();
    try {
      final response = await dio.put(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/$locationsMarkerModel.address",
          data: {
            "latitude": locationsMarkerModel.latitude,
            "longitude": locationsMarkerModel.longitude,
            "flag": 1,
            "real_address": locationsMarkerModel.address
          });
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  //update locations using id
  //TODO: update locations using id NOT TESTED(27-10-2024)
  Future updateLocationsById(
      int id, LocationsMarkerModel locationsMarkerModel) async {
    try {
      List<LocationsMarkerModel> locationsList = [];
      final locationIndex =
          locationsList.indexWhere((element) => element.id == id);
      var dio = Dio();

      if (locationIndex >= 0) {
        final response = await dio.put(
            "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/$id",
            data: {
              "latitude": locationsMarkerModel.latitude,
              "longitude": locationsMarkerModel.longitude,
              "flag": 1,
              "real_address": locationsMarkerModel.address
            });
        locationsList[locationIndex] = locationsMarkerModel;
        return response.data;
      } else {
        throw Exception('Location not found');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//POST in GIS Server
//TODO:POST in GIS Server (22-12-2024-NOT-TEST)
// Future createNewGisPoint(LocationsMarkerModel locationsMarkerModel) async{
//   var dio = Dio();
//   try {
//     final response = await dio.post(
//         "http://192.168.17.250:8000/pick-location/api/",
//         data: {
//           "x": locationsMarkerModel.latitude,
//           "y": locationsMarkerModel.longitude,
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
}

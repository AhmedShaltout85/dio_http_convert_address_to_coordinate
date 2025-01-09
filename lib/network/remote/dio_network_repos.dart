import 'dart:convert';

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
  Future updateLoc(String address, double longitude, double latitude) async {
    var dio = Dio();
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
      String address, double longitude, double latitude,  String url) async {
    var dio = Dio();
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
    var dio = Dio();
    // Encode credentials to Base64
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    try {
      final response = await dio
          // .post("https://api.allorigins.win/raw?url=$gisUrl", data: {
          .post(gisUrl,
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

  //POST in GIS Server and GET MAP Link
//TODO:GET GIS map LINK (22-12-2024-NOT-TEST)
  Future createNewGisPointAndGetMap(
      String longitude,
      String latitude, int id) async {
// Future createNewGisPointAndGetMap(
//       LocationsMarkerModel locationsMarkerModel) async{

    var dio = Dio();
    try {
      final response = await dio
          .post("http://192.168.17.250:8000/pick-location/api/", data: {
        "uid": id,
        "x": longitude,
        "y": latitude,
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

//update locations using Constructor
//TODO: update locations using Constructor NOT TESTED(27-10-2024)
  Future updateLocs(LocationsMarkerModel locationsMarkerModel) async {
    var dio = Dio();
    try {
      final response = await dio.put(
          "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/$locationsMarkerModel.address",
          data: {
            "longitude": locationsMarkerModel.longitude,
            "latitude": locationsMarkerModel.latitude,
            "gis_url": locationsMarkerModel.url
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
              "longitude": locationsMarkerModel.longitude,
              "latitude": locationsMarkerModel.latitude,
              "flag": 1,
              "gis_url": locationsMarkerModel.url
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
}

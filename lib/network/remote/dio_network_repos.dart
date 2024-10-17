import 'package:dio/dio.dart';
import 'package:dio_http/utils/dio_http_constants.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

class DioNetworkRepos {
  Future getUsers() async {
    var dio = Dio();
    try {
      var response = await dio.get(url);
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

//get locations(GET by flag 0 (address not set yet))
  Future getLoc() async {
    var dio = Dio();
    try {
      // var response = await dio.get(url2);
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
      var response = await dio.put(
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

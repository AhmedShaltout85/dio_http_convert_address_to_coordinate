// const String url = "https://jsonplaceholder.typicode.com/users";
const String url2 =
    "http://192.168.17.250:9999/pick-location/api/v1/get-loc/filter";
const String urlGetHotlineAddress =
    "http://192.168.17.250:9999/pick-location/api/v1/get-loc/flag/0"; //GET by flag 0 (address not set yet)
const String urlGetAllByFlagAndIsFinished =
    'http://192.168.17.250:9999/pick-location/api/v1/get-loc/flag/1/is-finished/0'; //GET by flag 0 and isFinished 0
const String urlPut =
    "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/"; //PUT update locations

//to run on phone (the host and phone in the same network)
//const String url2 = "http://10.0.2.2:9999/pick-location/api/v1/get-loc/filter"; for emulator

//GIS Server URL
const String gisUrl = "http://196.219.231.3:8000/lab-api/create-marker";

const String apiKey = "AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk";

//Agora Constants for Video Call
const appId = "ffd898c8ae5d4d96be499de1166e6229";
const token = "";
const channel = "pick_location";

// Basic Authentication credentials
const username = 'gis';
const password = 'gislab1257910';

class DataStatic {
//Assign HandasahName
  static String handasahName = '';
}

// const String url = "https://jsonplaceholder.typicode.com/users";
const String url2 =
    "http://192.168.17.250:9999/pick-location/api/v1/get-loc/filter";
const String urlGetHotlineAddress =
    "http://192.168.17.250:9999/pick-location/api/v1/get-loc/flag/0"; //GET by flag 0 (address not set yet)
const String urlGetAllByFlagAndIsFinished =
    'http://192.168.17.250:9999/pick-location/api/v1/get-loc/flag/1/is-finished/0'; //GET by flag 0 and isFinished 0
// const String urlGetAllByHandasahAndIsFinished =
//     'http://192.168.17.250:9999/pick-location/api/v1/get-loc/handasah/handasah/is-finished/0'; //GET by handasah (handasah) and isFinished 0
// const String urlGetAllByHandasahAndTechnician =
//     'http://192.168.17.250:9999/pick-location/api/v1/get-loc/handasah/free/technical/free'; //GET by Handasah free and Technician free
const String urlPut =
    "http://192.168.17.250:9999/pick-location/api/v1/get-loc/address/"; //PUT update locations

//to run on phone (the host and phone in the same network)
//const String url2 = "http://10.0.2.2:9999/pick-location/api/v1/get-loc/filter"; for emulator

//GIS Server URL
const String gisUrl = "http://196.219.231.3:8000/lab-api/create-marker";

const String googleMapsApiKey = "AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk";

//Agora Constants for Video Call
// const appId = "ffd898c8ae5d4d96be499de1166e6229";
// const token = "";
// const channel = "pick_location";

// //Agora Constants for Video Call updated
const appId = 'c7f8762224f147b2b446ba97543e2eaa';
const token = '';
const channel = 'control_room_location';

// //Agora Constants for Audio Call
// const appIdAudio = '179f3d65e03e4d40a6900cb55a51f154';
// const tokenAudio = '';
// const channelAudio = 'control_location_voice';

// Basic Authentication credentials
const username = 'gis';
const password = 'gislab1257910';

class DataStatic {
//Assign HandasahName
  static String handasahName = '';
  static int setectedIndax = 0;
//get user info
  static String username = '';
  static String password = '';  
  static int userRole = 0;
}

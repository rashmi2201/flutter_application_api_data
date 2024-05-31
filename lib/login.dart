import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_api_data/model_class/employee_model.dart';
import 'package:flutter_application_api_data/screens/employee_screen.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_api_data/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //for isloading pass boolean value
  bool isLoading = false;

// for login Url
  String loginUrl = "https://apis.siddhios.com/";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getDeviceId(); //get device id
        sendRequest();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Center(child: Text('Login Screen')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            
            GestureDetector(
              onTap: () {
          
                String username = usernameController.text;
                String password = passwordController.text;

                GetUserRequest(username, password);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => DashboardScreen()),
                // );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text('Login')),
              ),
            ),
            

          ],
        ),
      ),
    );
  }

  // method for get device id......
  Future<void> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    // shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save an integer value to 'counter' key.
    deviceId = await prefs.getString('deviceId');

    if (deviceId == null) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id; // Unique ID on Android
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor!; // Unique ID on iOS
      } else {
        throw UnsupportedError('Unsupported platform');
      }
      await prefs.setString('deviceId', deviceId);
    }
    String? deviceIds = await prefs.getString('deviceId');
    print('Device id == $deviceIds');
  }

  //method for sending the request ....
  Future<void> sendRequest() async {
    String loginUrl = "https://apis.siddhios.com/";
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? deviceId = pref.getString('deviceId');

    // First request to get the session ID
    var response = await http.post(
      Uri.parse(loginUrl),
      headers: {"Device-Id": deviceId!},
    );

    if (response.statusCode == 511) {
      var responseHeader = (response.headers);
      print("ResponseHeader == $responseHeader");
      String sessionId = responseHeader['session-id'] ?? '';
      await pref.setString('sessionId', sessionId);
      print("sessionId == $sessionId");
      // Second request with session ID, device ID, username, and password
    } else {
      print("Initial Request Failed: ${response.statusCode}");
    }
  }

  //method for getuserrequest....
  Future<void> GetUserRequest(String username, String password) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
  // for getting seesion id and device id
    String? deviceId = pref.getString('deviceId');
    String? sessionId = pref.getString('sessionId');
  

    try {
      var loginResponse = await http.post(
        Uri.parse(loginUrl),
        body: jsonEncode({
          "user": username,
          "pass": password,
        }),
        headers: {
          "Content-Type": "application/json",
          "Session-Id": sessionId!,
          "Device-Id": deviceId!,
        },
      );
     
      print("Login Rewuest==${loginResponse.request}");

      if (loginResponse.statusCode == 200) {
        var loginResponseBody = jsonDecode(loginResponse.body);
        // Access the 'data' key which should be a list
        List<dynamic> dataList = loginResponseBody['data'];

        // Assuming 'Data' is a model class, you need to convert the map to your model
        List<Data> loginDataList =
            dataList.map((data) => Data.fromJson(data)).toList();
        // print(loginDataList);
        Data logindata = loginDataList[0];
        // Check if login was successful
        // print(loginResponseBody['error']);
        print(loginResponseBody);
        if (loginResponseBody['status'] == 1) {
          if (logindata.type == "employee") {
            Navigator.pushReplacement(
              context,

              //if type employee scrren except admin
              MaterialPageRoute(
                builder: (context) => DashboardScreen(datas: logindata),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,

              //
              MaterialPageRoute(
                builder: (context) => EmployeeScreen(datas: logindata),
              ),
            );
          }
        }
      } else {
        // Handle non-200 status code
        print("HTTP Error: ${loginResponse.statusCode}");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error during login: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    //method for show snackbar
    void _showSnackBar(String message) {
      final snackBar = const SnackBar(
        content: Text('Please Enter Valid Details'),
        backgroundColor: Colors.redAccent,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

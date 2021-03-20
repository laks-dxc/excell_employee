// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'dart:async';
// import 'dart:io' show Platform;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final FirebaseApp app = await Firebase.initializeApp(
//       name: 'db2',
//       options: FirebaseOptions(
//         appId: '1:297855924061:android:669871c998cc21bd',
//         apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
//         projectId: 'flutter-firebase-plugins',
//         messagingSenderId: '1096121878493',
//         databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
//       ));
//   runApp(MyApp({app: app}));
// }

// class MyApp extends StatefulWidget {
//   MyApp({this.app});
//   final FirebaseApp app;
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final LocalAuthentication auth = LocalAuthentication();
//   _SupportState _supportState = _SupportState.unknown;
//   bool _canCheckBiometrics;
//   List<BiometricType> _availableBiometrics;
//   String _authorized = 'Not Authorized';
//   bool _isAuthenticating = false;
//   bool _authenticated = false;

//   @override
//   void initState() {
//     super.initState();
//     auth.isDeviceSupported().then(
//           (isSupported) => setState(() => _supportState = isSupported
//               ? _SupportState.supported
//               : _SupportState.unsupported),
//         );
//   }

//   Future<void> _checkBiometrics() async {
//     bool canCheckBiometrics;
//     try {
//       canCheckBiometrics = await auth.canCheckBiometrics;
//     } on PlatformException catch (e) {
//       canCheckBiometrics = false;
//       print(e);
//     }
//     if (!mounted) return;

//     setState(() {
//       _canCheckBiometrics = canCheckBiometrics;
//     });
//   }

//   Future<void> _getAvailableBiometrics() async {
//     List<BiometricType> availableBiometrics;
//     try {
//       availableBiometrics = await auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       availableBiometrics = <BiometricType>[];
//       print(e);
//     }
//     if (!mounted) return;

//     setState(() {
//       _availableBiometrics = availableBiometrics;
//     });
//   }

//   Future<void> _authenticate() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = 'Authenticating';
//       });
//       authenticated = await auth.authenticate(
//           localizedReason: 'Let OS determine authentication method',
//           useErrorDialogs: true,
//           stickyAuth: true);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = 'Authenticating';
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = "Error - ${e.message}";
//       });
//       return;
//     }
//     if (!mounted) return;

//     setState(() {
//       _authorized = authenticated ? 'Authorized' : 'Not Authorized';
//       _authenticated = authenticated;
//     });
//   }

//   Future<void> _authenticateWithBiometrics() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = 'Authenticating';
//       });
//       authenticated = await auth.authenticate(
//           localizedReason: 'Scan your fingerprint to authenticate',
//           useErrorDialogs: true,
//           stickyAuth: true,
//           biometricOnly: true);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = 'Authenticating';
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = "Error - ${e.message}";
//       });
//       return;
//     }
//     if (!mounted) return;

//     final String message = authenticated ? 'Authorized' : 'Not Authorized';

//     setState(() {
//       _authorized = message;
//     });

//     if (authenticated) {}
//   }

//   void _cancelAuthentication() async {
//     await auth.stopAuthentication();
//     setState(() => _isAuthenticating = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
// /*              if (_supportState == _SupportState.unknown)
//                 CircularProgressIndicator()
//               else if (_supportState == _SupportState.supported)
//                 Text("This device is supported")
//               else
//                 Text("This device is not supported"),
//               Divider(height: 100),
//               Text('Can check biometrics: $_canCheckBiometrics\n'),
//               ElevatedButton(
//                 child: const Text('Check biometrics'),
//                 onPressed: _checkBiometrics,
//               ),
//               Divider(height: 100),
//               Text('Available biometrics: $_availableBiometrics\n'),
//               ElevatedButton(
//                 child: const Text('Get available biometrics'),
//                 onPressed: _getAvailableBiometrics,
//               ),
//               Divider(height: 100),
// */
//               Image.asset("assets/logo.png", height: 150, width: 150),
//               Text(
//                 "Excell Employee",
//                 style: TextStyle(fontSize: 35),
//               ),
//               // Text('Current State: $_authorized\n'),
//               (_isAuthenticating)
//                   ? ElevatedButton(
//                       onPressed: _cancelAuthentication,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text("Cancel Authentication"),
//                           Icon(Icons.cancel),
//                         ],
//                       ),
//                     )
//                   : SizedBox(
//                       width: 100,
//                       child: ElevatedButton(
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(_isAuthenticating ? 'Cancel' : 'Login'),
//                           ],
//                         ),
//                         onPressed: _supportState == _SupportState.supported
//                             ? _authenticateWithBiometrics
//                             : () {},
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:excell_employee/views/sampleForm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
      name: 'db2',
      options: FirebaseOptions(
        appId: '1:1096121878493:android:b21657127834d362fad834',
        apiKey: 'AIzaSyA6eNZd88qhER94w2U9InP7R6Ji71UGj3Q',
        projectId: 'excell-employee',
        messagingSenderId: '1096121878493',
        databaseURL: 'https://excell-employee-default-rtdb.firebaseio.com/',
      ));
  runApp(MaterialApp(
    title: 'Flutter Database Example',
    home: MyHomePage(app: app),
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.app});
  final FirebaseApp app;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';

  @override
  void initState() {
    super.initState();

    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);

    database.reference().child('counter').once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    bool authenticated = false;
    try {
      setState(() {
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      if (authenticated) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SampleForm()),
        );
      }
      setState(() {
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excell Employee'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Image.asset("assets/logo.png", height: 150, width: 150),
            SizedBox(height: 30),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Biometric Login'),
                  ],
                ),
                onPressed: () {
                  _authenticateWithBiometrics(context);
                },
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('OTP Login'),
                  ],
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Normal OTP Login"),
                      action: SnackBarAction(
                        label: "Continue",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SampleForm(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

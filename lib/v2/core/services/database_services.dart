// import 'package:cryptox/v2/core/constants/api_endpoints.dart';
// import 'package:cryptox/v2/core/services/api_services.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DatabaseServices {
//   final api = new ApiServices();

//   validateUserEmail(String email) async {
//     var response =
//         await api.get(url: EndPoints.baseUrl, params: {"email": email});

//     if (response == 200) {
//     } else {}
//   }
// }

// class UserServices {
//   // Initialize the flutter app
//   // late FirebaseApp firebaseApp;
//   // late User firebaseUser;
//   // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   // final api = new API();

//   ///TO verify if email already exist or not

//   // createUser(String userName, password, email) {
//   //   ///Call create user api and pass the required parameters
//   //   api.createUserName(userName, password, email);
//   // }

//   fetchUser(String email) async {
//     await api.fetchUser(email);
//   }

//   getWalletAdress(String email) async {
//     var res = await api.fetchWalletAddress(email);
//     return res;
//   }

//   // ///For Msq/msqp
//   // verifyUserMsq(String username, password, amount, email) async {
//   //   Get.back();
//   //   Get.defaultDialog(
//   //       title: "",
//   //       content: Column(
//   //         children: [
//   //           Image.asset(
//   //             Assets.logoIcon,
//   //             height: 100,
//   //             width: 100,
//   //           ),
//   //           Text("Loading...")
//   //         ],
//   //       ),
//   //       barrierDismissible: false,
//   //       backgroundColor: Colors.transparent);
//   //   var response = await api.verifyCredential(username, password);
//   //   debugPrint(response.toString());
//   //   if (response == 200) {
//   //     var res = await api.msqToMsqp(email, amount);
//   //     debugPrint(res.toString());
//   //     if (res == 200) {
//   //       Get.offAll(() => MsqtoMsqp());
//   //       SnackBars.successSnackBar('Success', 'Exchanged Successfully');
//   //       // Get.off(()=>MsqtoMsqp());
//   //     } else {
//   //       Get.close(1);
//   //       SnackBars.errorSnackBar('Error', 'Exchanged Failed');
//   //       // Get.back(closeOverlays: true);
//   //     }
//   //   } else {
//   //     Get.back();
//   //     SnackBars.errorSnackBar('Error', 'Credentials are not correct');
//   //   }
//   // }

//   // ///For msqp/msq
//   // verifyUserMsqp(String username, password, amount, email) async {
//   //   Get.back();
//   //   Get.defaultDialog(
//   //       title: "",
//   //       content: Column(
//   //         children: [
//   //           Image.asset(
//   //             Assets.logoIcon,
//   //             height: 100,
//   //             width: 100,
//   //           ),
//   //           Text("Loading...")
//   //         ],
//   //       ),
//   //       barrierDismissible: false,
//   //       backgroundColor: Colors.transparent);
//   //   var response = await api.verifyCredential(username, password);
//   //   debugPrint(response.toString());
//   //   if (response == 200) {
//   //     var res = await api.msqpToMsq(email, amount);
//   //     debugPrint(res.toString());
//   //     if (res == 200) {
//   //       Get.offAll(() => MsqptoMsq());
//   //       SnackBars.successSnackBar('Success', 'Exchanged Successfully');
//   //     } else {
//   //       Get.back();
//   //       SnackBars.errorSnackBar('Error', 'Exchanged Failed');
//   //     }
//   //   } else {
//   //     Get.back();
//   //     SnackBars.errorSnackBar('Error', 'Credentials are not correct');
//   //   }
//   // }
// }

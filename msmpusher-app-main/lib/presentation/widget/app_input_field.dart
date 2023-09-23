// import 'package:flutter/material.dart';
// import 'package:msmpusher/core/helper/dimensions.dart';
// import 'package:msmpusher/core/helper/utils.dart';

// class AppInputField extends StatelessWidget {
//   final TextEditingController? textEditingController;
//   final String hintText;
//   final TextInputType textInputType;
//   final bool isObscure;
//   const AppInputField(
//       {Key? key,
//       required this.textEditingController,
//       required this.hintText,
//       required this.textInputType,
//       this.isObscure = false})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin:
//           EdgeInsets.only(left: Dimensions.width15, right: Dimensions.width15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(Dimensions.radius30),
//       ),
//       child: TextField(
//         obscureText: isObscure ? true : false,
//         keyboardType: textInputType,
//         controller: textEditingController,
//         decoration: InputDecoration(
//           labelText: hintText,
//           floatingLabelStyle:
//               const TextStyle(color: AppColor.borderInputNormal),
//           labelStyle: const TextStyle(color: AppColor.labelColor),
//           fillColor: Colors.white,
//           //Focus Border
//           focusedBorder: const OutlineInputBorder(
//             borderSide:
//                 BorderSide(color: AppColor.borderInputNormal, width: 2.0),
//           ),
//           //Enabled Border
//           enabledBorder: const OutlineInputBorder(
//             borderSide:
//                 BorderSide(color: AppColor.borderInputFocus, width: 2.0),
//           ),
//           //border
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }

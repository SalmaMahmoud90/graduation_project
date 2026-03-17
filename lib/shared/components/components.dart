import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget image({
  required String path,
  required double width,
  required double height,
  Color color = const Color(0xFFE0F2F1),
}) =>
    kIsWeb
        ? Container(
            child: Image.network(path),
            width: width,
            height: height,
            color: color,
          )
        : Container(
            child: Image.asset(path),
            width: width,
            height: height,
            color: color,
          );
Widget button({
  required double width,
  double height = 40,
  double start_end_padding = 5,
  double top_buttom_padding = 5,
  Color color = Colors.teal,
  required String text,
  Color textColor = Colors.white,
  double textSize = 20,
  required VoidCallback pressed,
  double radius = 5.0,
}) =>
    MaterialButton(
      onPressed: pressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        height: height,
        width: width,
        padding: EdgeInsetsDirectional.only(
            start: start_end_padding,
            end: start_end_padding,
            top: top_buttom_padding,
            bottom: top_buttom_padding),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
          ),
        ),
      ),
    );
Widget formFeild({
  required TextEditingController controller,
  required TextInputType keyboard,
  required String label,
  String hint = '',
  required Widget prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,
  required FormFieldValidator validate,
  bool isPassword = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: IconButton(
          icon: Icon(suffix),
          onPressed: suffixPressed,
        ),
        border: OutlineInputBorder(),
      ),
      validator: validate,
      obscureText: isPassword,
    );
Widget trip({
  required String? path,
  required String from,
  required String to,
  required String depature_time,
  required String arrival_time,
  required String price,
  required int? capacity,
  IconData icon = Icons.add_box_outlined,
  double width = 0,
  double moveWidth = 60,
  double iconSize = 55,
  VoidCallback? pressedIcon,
}) =>
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(color: Colors.teal, blurRadius: 5.0),
        ],
      ),
      padding: EdgeInsets.all(5.0),
      width: 330,
      child: Column(
        children: [
          Row(
            children: [
              image(
                path: path ?? "assets/images/car3.png",
                width: 190,
                height: 100,
                color: Colors.white,
              ),
              SizedBox(
                width: moveWidth,
              ),
              IconButton(
                  onPressed: pressedIcon,
                  icon: Icon(
                    Icons.more_vert,
                    size: 40,
                    color: Colors.blue[700],
                    weight: 20.0,
                  )),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'from: ',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$from',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'to: ',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$to',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'departure time: ',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$depature_time',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Estimated time of arrival: ',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$arrival_time',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'cost: ',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$price\$',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'capacity: ',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$capacity',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: width,
              ),
              IconButton(
                  onPressed: pressedIcon,
                  icon: Icon(
                    icon,
                    size: iconSize,
                    color: Colors.blue[700],
                    weight: 20.0,
                  )),
            ],
          ),
        ],
      ),
    );
Widget buildEditableField({
  required String title,
  required String value,
  required TextEditingController controller,
  required Function(String) onSave,
  required FormFieldValidator validate,
  required GlobalKey<FormState> formKey,
  required TextInputType keyBoard,
  List<TextInputFormatter>? inputFormatters,
}) {
  FocusNode focusNode = FocusNode();
  bool isEditing = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    controller.text = value;
                    isEditing = true;
                  });
                  Future.delayed(const Duration(milliseconds: 100), () {
                    FocusScope.of(context).requestFocus(focusNode);
                  });
                },
                icon: const Icon(Icons.edit, color: Colors.indigo, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 5),
          isEditing
              ? Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        validator: validate,
                        keyboardType: keyBoard,
                        inputFormatters: inputFormatters ?? [],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          setState(() {
                            onSave(controller.text);
                            isEditing = false;
                          });
                        }
                      },
                      icon: const Icon(Icons.check, color: Colors.green),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isEditing = false;
                        });
                      },
                      icon: const Icon(Icons.close, color: Colors.red),
                    ),
                  ],
                )
              : Text(
                  controller.text,
                  style: const TextStyle(fontSize: 18),
                ),
        ],
      );
    },
  );
}

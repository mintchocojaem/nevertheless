
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


typedef OnColorSelected = Function(Color color);

class CustomColorPicker extends AlertDialog{

  CustomColorPicker({this.backgroundColor, this.textColor, this.colors,
    required this.onColorSelected, required this.pickerColor });

  final Color pickerColor;
  final Color? backgroundColor;
  final Color? textColor;
  final List<Color>? colors;
  final OnColorSelected onColorSelected;

  @override
  Widget build(BuildContext context) {
    Color pickedColor = pickerColor;
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text('Palette',style: TextStyle(color: textColor)),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickedColor,
          labelTypes: [],
          onColorChanged: (color){
            pickedColor = color;
          },
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text('확인',style: TextStyle(fontSize: 16,color: textColor),),
                onPressed: () {
                  onColorSelected(pickedColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget pickerLayoutBuilder(BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: 300,
      height: orientation == Orientation.portrait ? 300 : 500,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 4 : 4,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color,
        boxShadow: [BoxShadow(color: color.withOpacity(0.8), offset: const Offset(1, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(50),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: 30,
              color: useWhiteForeground(color) ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const SearchField({
    required this.controller,
    required this.hintText,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  var _hasText = false;

  _onClear() {
    if (widget.controller.hasListeners) {
      FocusScope.of(context).unfocus();
      setState(() {
        widget.controller.text = "";
        _hasText = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (newStr) {
        var temp = newStr.isNotEmpty;
        if(_hasText != temp) {
          setState(() {
            _hasText = temp;
          });
        }
      },
      style: TextStyle(color: Get.theme.primaryColorLight),
      decoration: InputDecoration(

        contentPadding: const EdgeInsets.all(10),
        isDense: true,
        filled: true,
        fillColor: const Color(0xFF1c1c1e),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Get.theme.iconTheme.color),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: Get.theme.iconTheme.color,
        ),
        suffixIcon: _hasText
            ? GestureDetector(
                onTap: _onClear,
                child: Icon(
                  CupertinoIcons.clear_circled_solid,
                  color: Get.theme.iconTheme.color,
                ),
              )
            : const SizedBox.shrink(),
      ),
      controller: widget.controller,
    );
  }
}

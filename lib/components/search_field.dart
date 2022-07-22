import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onSubmitted;

  const SearchField({
    required this.controller,
    required this.hintText,
    this.onSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  var _hasText = false;
  var _width = 0.0;
  var _color = Colors.transparent;
  final _focusNode = FocusNode();

  _onClear() {
    FocusScope.of(context).unfocus();
    setState(() {
      widget.controller.text = "";
      _hasText = false;
    });
  }

  @override
  dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _width = 100;
          _color = Get.theme.primaryColor;
        });
      } else {
        setState(() {
          _width = 0;
          _color = Colors.transparent;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: _focusNode,
            onChanged: (newStr) {
              var temp = newStr.isNotEmpty;
              if (_hasText != temp) {
                setState(() {
                  _hasText = temp;
                });
              }
            },
            onSubmitted: widget.onSubmitted,
            autocorrect: false,
            style: TextStyle(color: Get.theme.primaryColorLight),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(2),
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
          ),
        ),
        AnimatedContainer(
          width: _width,
          height: 45,
          duration: const Duration(milliseconds: 250),
          child: GestureDetector(
            onTapDown: (details) {
              setState(() {
                _color = Color(0xFF0550A1);
              });
            },
            onTapUp: (details) {
              setState(() {
                _color = Get.theme.primaryColor;
              });
              FocusScope.of(context).unfocus();
            },
            child: Container(
              child: Center(
                child: AnimatedDefaultTextStyle(
                  maxLines: 1,
                  style: TextStyle(
                    color: _color,
                    fontSize: 16
                  ),
                  duration: const Duration(milliseconds: 150),
                  child: const Text("Отменить"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

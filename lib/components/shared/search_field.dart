import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:symphony/components/shared/action_button.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;

  const SearchField({
    required this.controller,
    required this.hintText,
    this.onSubmitted,
    this.onChanged,
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
      _hasText = widget.controller.text.isNotEmpty;
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
              widget.onChanged != null ? widget.onChanged!(newStr) : null;

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
              suffixIcon: widget.controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: _onClear,
                      child: Icon(
                        key: const Key("clear_button"),
                        CupertinoIcons.clear_circled_solid,
                        color: Get.theme.iconTheme.color,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            controller: widget.controller,
          ),
        ),
        ActionButton(
          color: _color,
          width: _width,
          text: const Text("Отменить"),
        )
      ],
    );
  }
}

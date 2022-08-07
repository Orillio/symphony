import 'package:flutter/cupertino.dart';
import 'package:symphony/api/api_downloads/directory_manager.dart';

class FileActionSheet extends StatelessWidget {
  const FileActionSheet({
    Key? key,
    this.title,
    required this.filePath,
  }) : super(key: key);

  final String? title;
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: title != null ? Text(title!) : null,
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Отменить"),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Переименовать"),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
            DirectoryManager.instance.deleteFile(filePath);
          },
          child: const Text("Удалить"),
        ),
      ],
    );
  }
}

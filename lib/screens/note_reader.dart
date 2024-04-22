import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/style/app_style.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class NoteReaderScreen extends StatefulWidget {
  final QueryDocumentSnapshot doc;
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  late TextEditingController _titleController;
  late TextEditingController _mainController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.doc['note_title']);
    _mainController = TextEditingController(text: widget.doc['note_content']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];

    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              FirebaseFirestore.instance
                  .collection("Notes")
                  .doc(widget.doc.id)
                  .delete()
                  .then((value) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "Note deleted successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }).catchError(
                (error) => print("Failed to delete note due to $error"),
              );
            },
            icon: const Icon(
              Icons.delete,
              size: 25.0,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              style: AppStyle.mainTitle,
            ),
            const SizedBox(height: 4.0),
            Text(
              widget.doc["creation_date"],
              style: AppStyle.dateTitle,
            ),
            const SizedBox(height: 28.0),
            TextField(
              controller: _mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.accentColor,
        onPressed: () async {
          FirebaseFirestore.instance
              .collection("Notes")
              .doc(widget.doc.id)
              .update({
            "note_title": _titleController.text,
            "note_content": _mainController.text,
          }).then((value) {
            Fluttertoast.showToast(
              msg: "Note updated successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
            FocusScope.of(context).unfocus();
          }).catchError(
            (error) => print("Failed to update note due to $error"),
          );
        },
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }
}

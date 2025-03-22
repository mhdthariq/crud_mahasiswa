import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'mahasiswa.dart';

class AddEditScreen extends StatefulWidget {
  final Mahasiswa? mahasiswa;

  AddEditScreen({this.mahasiswa});

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    if (widget.mahasiswa != null) {
      _namaController.text = widget.mahasiswa!.nama;
      _nimController.text = widget.mahasiswa!.nim;
    }
  }

  void _saveData() async {
    String nama = _namaController.text.trim();
    String nim = _nimController.text.trim();

    if (nama.isEmpty || nim.isEmpty) {
      _showAlertDialog("Error", "Please fill in all fields.");
      return;
    }

    if (widget.mahasiswa == null) {
      await dbHelper.insertMahasiswa(Mahasiswa(nama: nama, nim: nim));
    } else {
      await dbHelper.updateMahasiswa(
        Mahasiswa(id: widget.mahasiswa!.id, nama: nama, nim: nim),
      );
    }

    Navigator.pop(context, true);
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.mahasiswa == null ? "Add Student" : "Edit Student")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _nimController,
              decoration: InputDecoration(labelText: "NIM"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text(widget.mahasiswa == null ? "Add" : "Update"),
            ),
          ],
        ),
      ),
    );
  }
}
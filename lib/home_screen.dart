import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'mahasiswa.dart';
import 'add_edit_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Mahasiswa> mahasiswaList = [];

  @override
  void initState() {
    super.initState();
    _refreshMahasiswa();
  }

  void _refreshMahasiswa() async {
    final data = await dbHelper.getAllMahasiswa();
    setState(() {
      mahasiswaList = data;
    });
  }

  void _deleteMahasiswa(int id) async {
    await dbHelper.deleteMahasiswa(id);
    _refreshMahasiswa();
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student List"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mahasiswaList.length,
        itemBuilder: (context, index) {
          final mahasiswa = mahasiswaList[index];
          return ListTile(
            title: Text(mahasiswa.nama),
            subtitle: Text(mahasiswa.nim),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditScreen(mahasiswa: mahasiswa),
                      ),
                    );
                    _refreshMahasiswa();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteMahasiswa(mahasiswa.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditScreen()),
          );
          _refreshMahasiswa();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
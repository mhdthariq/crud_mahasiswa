import 'dart:convert';

class Mahasiswa {
  int? id;
  String nama;
  String nim;

  Mahasiswa({this.id, required this.nama, required this.nim});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
    };
  }

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      id: map['id'],
      nama: map['nama'],
      nim: map['nim'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Mahasiswa.fromJson(String source) => Mahasiswa.fromMap(json.decode(source));
}
import 'package:crud/models/User.dart';
import 'package:crud/pages/addUser.dart';
import 'package:crud/pages/editUser.dart';
import 'package:crud/pages/viewUser.dart';
import 'package:crud/services/userService.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crud App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // buat var kosong untuk menampung data dari database
  late List<User> _userList = <User>[];
  final _userService = UserService();

  // buat fungsi untuk mengambil seluruh data
  getAllUser() async {
    // memanggil user service
    var users = await _userService.readAllUser();
    _userList = <User>[];
    // ganti isi user [] dengan data dari database
    print(users);
    users.forEach((user) {
      setState(() {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.contact = user['contact'];
        userModel.description = user['description'];
        _userList.add(userModel);
      });
    });
  }

  // buat fungsi Snack bar untuk pesan
  _showSuccessMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  // fungsi untuk delete user
  _deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              "Apakah data ingin dihapus?",
              style: TextStyle(
                color: Colors.teal,
                fontSize: 20,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  // fungsi service delete
                  var result = await _userService.deleteUser(userId);
                  // cek jika id ada atau data ada
                  if (result != null) {
                    getAllUser();
                    Navigator.pop(context);
                    _showSuccessMessage("User berhasil didelete");
                  }
                },
                child: const Text("Delete"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"),
              ),
            ],
          );
        });
  }

  // buat constructor untuk fungsi2 yg pertama kali dijalankan
  @override
  void initState() {
    getAllUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD APP SQFLite"),
      ),
      body: ListView.builder(
        itemCount: _userList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewUser(
                      user: _userList[index],
                    ),
                  ),
                );
              },
              leading: const Icon(Icons.person),
              title: Text(_userList[index].name ?? ''),
              subtitle: Text(_userList[index].contact ?? ''),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUser(
                          user: _userList[index],
                        ),
                      ),
                    ).then((data) {
                      if (data != null) {
                        getAllUser();
                        _showSuccessMessage("Data user berhasil diupdate");
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _deleteFormDialog(context, _userList[index].id);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUser(),
            ),
          ).then((data) {
            if (data != null) {
              getAllUser();
              _showSuccessMessage("Data user berhasil didapatkan");
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // fasdfa
}

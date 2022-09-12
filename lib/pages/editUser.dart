import 'package:crud/models/User.dart';
import 'package:crud/services/userService.dart';
import 'package:flutter/material.dart';

class EditUser extends StatefulWidget {
  // tambahkan model params untuk main fungsi edit
  final User user;
  const EditUser({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _userNameController = TextEditingController();
  final _userContactController = TextEditingController();
  final _userDescriptionController = TextEditingController();
  bool _validateName = false;
  bool _validateContact = false;
  bool _validateDescription = false;
  // butuh model untuk menampung state yang baru
  final _userService = UserService();

  // buat constructor untuk memnampilkan data yang diambil berdasarkan id
  @override
  void initState() {
    setState(() {
      _userNameController.text = widget.user.name ?? '';
      _userContactController.text = widget.user.contact ?? '';
      _userDescriptionController.text = widget.user.description ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data User Baru"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah User',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Masukan Nama..',
                  labelText: 'Nama',
                  errorText: _validateName ? 'Nama harus diisi' : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _userContactController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Masukan Contact hp..',
                  labelText: 'Kontak',
                  errorText: _validateContact ? 'Kontak harus diisi' : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _userDescriptionController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Masukan Deskripsi..',
                  labelText: 'Deskripsi',
                  errorText:
                      _validateDescription ? 'Deskripsi harus diisi' : null,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _userNameController.text.isEmpty
                            ? _validateName = true
                            : _validateName = false;
                        _userContactController.text.isEmpty
                            ? _validateContact = true
                            : _validateContact = false;
                        _userDescriptionController.text.isEmpty
                            ? _validateDescription = true
                            : _validateDescription = false;
                      });
                      if (_validateName == false &&
                          _validateContact == false &&
                          _validateDescription == false) {
                        final _user = User();
                        _user.id = widget.user.id;
                        _user.name = _userNameController.text;
                        _user.contact = _userContactController.text;
                        _user.description = _userDescriptionController.text;

                        final result = await _userService.updateUser(_user);
                        Navigator.pop(context, result);
                      }
                    },
                    child: const Text('Update'),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

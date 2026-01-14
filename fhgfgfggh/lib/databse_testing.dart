import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Profile extends StatefulWidget {
  final int? id;
  final String name;
  final String email;
  final String password;

  const Profile({super.key, this.id, required this.name, required this.email, required this.password});

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
  };

  factory Profile.fromJson(Map<String, Object?> json) => Profile(
      id: json['id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String
  );

  Profile copy({
    int? id,
    String? name,
    String? email,
    String? password,
  }) =>
      Profile(
        id: id?? this.id,
        name: name?? this.name,
        email: email?? this.email,
        password: password?? this.password,
      );

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  ProfileDatabase database = ProfileDatabase.instance;

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[700],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _saveData,
                  child: const Text('Save'),
                ),
                SizedBox(width: 100,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Scaffold(
                            appBar: AppBar(
                              title: Text('Users List'),
                            ),
                            body: FutureBuilder<List<dynamic>>(
                              future: database.readAll(),
                              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Center(child: Text('No users found'));
                                }

                                final users = snapshot.data!;
                                return ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(users[index].name),
                                      subtitle: Text(users[index].email),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Text('Show Users'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveData() {
    final profile = Profile(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    database.create(profile);
  }
}

class ProfileDatabase {
  static final ProfileDatabase instance = ProfileDatabase._internal();
  static Database? _database;

  ProfileDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'profile_database.db'),
        version: 1,
        onCreate: _createDatabase
    );
  }

  Future<void> _createDatabase(Database database, int version) async {
    return await database.execute('''
        CREATE TABLE profile (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT NOT NULL,
          password TEXT NOT NULL
        )
      ''');
  }

  Future<Profile> create(Profile profile) async {
    final db = await instance.database;
    final id = await db.insert('profile', profile.toJson());
    return profile.copy(id: id);
  }

  Future<List<Profile>> readAll() async {
    final db = await instance.database;
    final result = await db.query('profile');
    return result.map((json) => Profile.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
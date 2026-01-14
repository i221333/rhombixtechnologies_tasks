import 'package:flutter/material.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  Map<String, String> userData = {
    'Name': 'John Doe',
    'Email': 'john@example.com',
    'Password': 'johndoe',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Brainyte"),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Reloading.....")));
              },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[900]),
              child: Container(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.account_circle_outlined, color: Colors.white70, size: 60,),
                          Text('Name:', style: TextStyle(color: Colors.white70),),
                          Text('Occupation:', style: TextStyle(color: Colors.white70))
                        ]
                    ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsPage(
                      isEditable: false,
                      initialValues: userData,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Edit Profile '),
              onTap: () async {
                Navigator.pop(context);
                final updated = await Navigator.push<Map<String, String>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsPage(
                      isEditable: true,
                      initialValues: userData,
                    ),
                  ),
                );

                if (updated != null) {
                  setState(() {
                    userData = updated;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image(image: AssetImage("assets/brainyte_logo.png"))),
          Text("Brainyte Solutions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}

class UserDetailsPage extends StatefulWidget {
  final bool isEditable;
  final Map<String, String>? initialValues;

  const UserDetailsPage({
    super.key, required this.isEditable, this.initialValues
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPage();
}

class _UserDetailsPage extends State<UserDetailsPage> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  bool _obscurePassword = true;

  @override void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.initialValues?['Name'] ?? '');
    emailController =
        TextEditingController(text: widget.initialValues?['Email'] ?? '');
    passwordController =
        TextEditingController(text: widget.initialValues?['Password'] ?? '');
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
    final isEditable = widget.isEditable;

    return Scaffold(
      appBar: AppBar(title: (isEditable)? const Text("Edit Profile"): const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              enabled: isEditable,
              decoration: InputDecoration(labelText: 'Name',
                labelStyle: TextStyle(color: isEditable ? null : Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),),
              style: TextStyle(
                color: isEditable ? null : Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              enabled: isEditable,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email',
                labelStyle: TextStyle(color: isEditable ? null : Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),),
              style: TextStyle(
                color: isEditable ? null : Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: passwordController,
                      enabled: isEditable,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: isEditable ? null : Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        color: isEditable ? null : Colors.black87,
                      ),
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
            if (isEditable)
              Center(
                child: ElevatedButton(
                  onPressed: _saveData,
                  child: const Text('Save'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _saveData() {
    final updatedValues = {
      'Name': nameController.text,
      'Email': emailController.text,
      'Password': passwordController.text,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data saved')),
    );
    Navigator.pop(context, updatedValues);
  }
}


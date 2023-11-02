import 'package:flutter/material.dart';
import 'package:sos/login_page.dart';

import 'box_utils.dart';
import 'http_utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _email = TextEditingController(text: "");
  TextEditingController _password = TextEditingController(text: "");
  TextEditingController _name = TextEditingController(text: "");
  void _submit() async {
    try {
      print("${_email.text}, ${_password.text}");

      var response = await appDio.post('/register', data: {
        "email": _email.text,
        "password": _password.text,
        "name": _name.text,
      });


      showDialog(context: context, builder: (_) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Register Successfully!"),
        );
      });
    } catch (error) {
      print(error);
      showDialog(context: context, builder: (_) => AlertDialog(title: Text("Error"), content: Text("Invalid credential."),));
    }
  }
  String? _logo;

  bool _logoLoading = true;

  Future loadLogo() async {
    var response = await appDio.get('/logo');
    print(response);
    print(response);
    setState(() {
      _logo = response.data;
      _logoLoading = false;
    });
  }

  void _load () async {
    await loadLogo();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'), // Use the path defined in pubspec.yaml
              fit: BoxFit.cover, // You can adjust the fit as needed
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _logoLoading ? CircularProgressIndicator() : Image.network("https://sos-app.elezerk.net/storage/${_logo}", height: 100, width: 100, cacheHeight: 160, cacheWidth: 200, ),
                Text("Registration Page",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    label: Text("Name"),
                    icon: Icon(Icons.verified_user),
                  ),
                  controller: _name,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    label: Text("Email"),
                    icon: Icon(Icons.email),
                  ),
                  controller: _email,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    label: Text("Password"),
                    icon: Icon(Icons.password),
                  ),
                  obscureText: true,
                  controller: _password,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Text("REGISTER NOW"),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Text("OR"),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPage()));
                    },
                    child: Text("ALREADY HAVE AN ACCOUNT?"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos/dashboard_page.dart';
import 'package:sos/register_page.dart';

import 'box_utils.dart';
import 'http_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController(text: '');
  TextEditingController _password = TextEditingController(text: '');
  bool _isLoading = false;
  void _submit() async {
    try {
      print("${_email.text}, ${_password.text}");

      var response = await appDio.post('/login', data: {
        "email": _email.text,
        "password": _password.text,
      });

      print("$response");
      box.write('token', response.data['token']);
      box.write('userName', response.data['user']['name']);
      box.write('userId', response.data['user']['id']);
      box.write('userEmail', response.data['user']['email']);
      box.write('userJoinedDate', response.data['user']['created_at']);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DashboardPage()));
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
                _logoLoading ? CircularProgressIndicator(): Image.network("https://sos-app.elezerk.net/storage/${_logo}", height: 100, width: 100, cacheHeight: 160, cacheWidth: 200,),

                const Text("Welcome user",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                const SizedBox(
                  height: 20,
                ),
                 TextField(
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    icon: Icon(Icons.email),
                  ),
                  controller: _email,
                ),
                const SizedBox(
                  height: 10,
                ),
                 TextField(
                  decoration: const InputDecoration(
                    label: Text("Password"),
                    icon: Icon(Icons.password),
                  ),
                  obscureText: true,
                   controller: _password,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _submit();
                    },
                    child: const Text("LOGIN"),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                MaterialButton(
                  onPressed: () {},
                  child: const Text("OR"),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
                    },
                    child: const Text("REGISTER"),
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

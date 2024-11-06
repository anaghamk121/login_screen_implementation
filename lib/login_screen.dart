import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class loginscreen extends StatefulWidget {
  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  bool hidepass1 = true;
  bool _isLoading = false;
  String _errorMessage = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final url = Uri.parse(
          "https://online-entrance-test-api-umxbq.ondigitalocean.app/api/v1/auth/login");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": _emailController.text,
          "password": _passwordController.text,
        }));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userName = responseData['user']['name'] ?? 'User';
        _showSuccessDialog(userName);
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['message'] ?? 'Login failed. Please try again.';
        });
        _showErrorDialog(_errorMessage);
      }}
    catch (e) {
      setState(() {
        _errorMessage = 'Network error. Please try again.';
      });
      _showErrorDialog(_errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login Success"),
          content: Text("Welcome, $userName"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();},
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();},
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14BF9E),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              "asset/Frame 1000004794photo.png",
              fit: BoxFit.contain,
             ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const ShapeDecoration(
                color: Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Please Enter the details",
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      const Text(
                        "below to Continue",
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        cursorColor: Colors.grey,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        cursorColor: Colors.grey,
                        controller: _passwordController,
                        obscureText: hidepass1,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidepass1 = !hidepass1;
                              });
                            },
                            icon: Icon(
                                hidepass1 ? Icons.visibility_off : Icons.visibility
                            ),
                          ),
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(left: 40,right: 40),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF14BF9E),
                              ),
                            child: _isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text('Sign in',style: TextStyle(color: Color(0xFFFFFFFF)),),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: TextButton(
                          onPressed: () {},
                          child: const Row(
                            children: [
                              Text(
                                "Don't have an account ? ",
                                style: TextStyle(fontSize: 18,color: Colors.grey),
                              ),
                              Text("Sign up",style: TextStyle(fontSize: 18,color: Color(0xFF01579B)),)
                            ],
                          ),
                        ),
                      ),
                     // const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
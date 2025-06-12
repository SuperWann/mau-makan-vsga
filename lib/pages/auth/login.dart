import 'package:flutter/material.dart';
import 'package:mau_makan/helpers/dbHelper.dart';
import 'package:mau_makan/models/user.dart';
import 'package:mau_makan/providers/userProvider.dart';
import 'package:mau_makan/services/userService.dart';
import 'package:mau_makan/widgets/button.dart';
import 'package:mau_makan/widgets/inputForm.dart';

class LoginPage extends StatefulWidget {
  static const nameRoute = '/loginPage';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    // Opsional: Cek apakah ada user di DB, jika tidak, tambahkan dummy user
    _checkAndAddDummyUser();
  }

  void _checkAndAddDummyUser() async {
    final users = await _userService.getAllUsers();
    if (users.isEmpty) {
      // Tambahkan user dummy jika belum ada
      await _userService.insertUser(
        UserModel(username: 'admin', password: 'password'),
      );
      print('Dummy user "admin:password" added.');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = UserProvider();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFF2D4F2B),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),

        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Image(image: AssetImage('assets/images/logo.png')),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Masuk",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 36,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Masukkan Username",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              InputFormWithHintText(
                                text: "Username",
                                controller: _usernameController,
                                type: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Masukkan Password",
                              style: TextStyle(
                                color: Colors.black45,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            InputPassword(controller: _passwordController),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: LongButton(
                        text: "Masuk",
                        color: "#2D4F2B",
                        colorText: "FFFFFF",
                        onPressed: () {
                          userProvider.login(
                            context,
                            _usernameController,
                            _passwordController,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

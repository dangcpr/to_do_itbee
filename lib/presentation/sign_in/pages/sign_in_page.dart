import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/common_widget.dart';
import '../../../core/function.dart';
import '../provider/user_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final keyForm = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  UserProvider get userProvider => context.read<UserProvider>();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }

                    // final regexEmail = RegExp(
                    //   r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    // );
                    // if (!regexEmail.hasMatch(value)) {
                    //   return 'Please enter a valid email address';
                    // }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    errorMaxLines: 3,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    // final passwordStrongRegex = RegExp(
                    //   r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                    // );
                    // if (!passwordStrongRegex.hasMatch(value)) {
                    //   return 'Please enter a strong password - at least 8 characters, one uppercase letter, one lowercase letter, one number and one special character';
                    // }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  child: const Text(
                    "Forgot password?",
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    if (emailController.text.isEmpty) {
                      AppFunctions.snackMessage(context, 'Please enter email');
                    }
                  },
                ),
                const SizedBox(height: 20),
                Consumer<UserProvider>(
                  builder: (_, value, _) {
                    if (value.isLoading) {
                      return AppButtons.circleButton();
                    }
                    if (value.errorMessage.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        AppFunctions.snackMessage(context, value.errorMessage);
                      });
                      userProvider.init();
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () async {
                        if (keyForm.currentState!.validate()) {
                          await value.login(
                            emailController.text,
                            passwordController.text,
                          );
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                Text(
                  "If you don't have an account",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    side: const BorderSide(color: Colors.deepPurple),
                  ),
                  child: const Text("Sign up", style: TextStyle(fontSize: 18)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

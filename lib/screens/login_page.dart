import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:test_app/providers/login_provider.dart';
import 'package:test_app/service/login_service.dart';
import 'package:test_app/widgets/input_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final loginProvider = Provider.of<LoginProvider>(context);
    final LoginService googleAuthService = LoginService();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        // actions: const [CartIcon()],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FormBuilder(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomInputField(
                    labelText: 'username',
                    validators: [
                      FormBuilderValidators.email(),
                    ],
                    hintText: 'Enter your username',
                    controller: usernameController,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    labelText: 'password',
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(2),
                    ],
                    hintText: 'Enter your password',
                    controller: passwordController,
                    isPassword: true,
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      if (formKey.currentState!.saveAndValidate()) {
                        final formData = formKey.currentState!.value;
                        final username = formData['username'] ?? "";
                        final password = formData['password'] ?? "";
                        print('Form Data: $username $password');

                        if (username.isEmpty || password.isEmpty) {
                          print('Username or Password cannot be empty');
                          return; // Early exit if any field is empty
                        }

                        bool success = await loginProvider.login(
                          username,
                          password,
                        );

                        if (success) {
                          Navigator.pop(context);
                        }
                        // Use formKey.currentState!.value to access form data
                      } else {
                        print("Validation failed");
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 40,
                    thickness: 0.5,
                    color: Colors.grey[300],
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await loginProvider.signInWithGoogle();
                      if (success) {
                        Navigator.pop(context);
                      }
                      // Handle post-login actions here, like navigating to a home page
                    },
                    child: const Text('Sign in with Google'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olxclone/Resources/auth_methods.dart';
import 'package:olxclone/Screens/login_screen.dart';
import 'package:olxclone/Utils/colors.dart';
import 'package:olxclone/Utils/utils.dart';
import 'package:olxclone/Widgets/text_field_input.dart';
import 'package:provider/provider.dart';
import '../Providers/user_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void dispose() {
    Provider.of<UserProvider>(context, listen: false).disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
          child: Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                    Text(
                      'Instagram',
                      style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          // Use the image from UserProvider
                          backgroundImage: userProvider.image != null ? FileImage(userProvider.image!) : null,
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () => userProvider.selectImage(),
                            icon: Icon(Icons.add_a_photo),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: userProvider.nameController,
                      hinttext: 'Enter your name',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: userProvider.emailController,
                      hinttext: 'Enter your email',
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: userProvider.passwordController,
                      hinttext: 'Enter your password',
                      textInputType: TextInputType.text,
                      isPass: true,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: userProvider.bioController,
                      hinttext: 'Enter your bio',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () => userProvider.signUpUser(context),
                      child: Container(
                        child: userProvider.isLoading
                            ? CircularProgressIndicator(
                          color: primaryColor,
                        )
                            : Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: ShapeDecoration(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                      ),
                    ),
                    Flexible(flex: 2, child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text('Already have an account?'),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          child: Container(
                            child: Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

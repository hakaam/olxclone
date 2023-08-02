import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olxclone/Resources/auth_methods.dart';
import '../Responsive_Layout/mobile_screen_layout.dart';
import '../Responsive_Layout/responsive_layout.dart';
import '../Responsive_Layout/web_screen_layout.dart';
import '../Screens/login_screen.dart';
import '../Utils/utils.dart';
import '../home_screen.dart';

class UserProvider with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  File? _image;

  File? get image => _image;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  void selectImage() async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: ImageSource.camera);
    if (_file != null) {
      _image = File(_file.path);
      notifyListeners();
    }
  }

  Future<void> signUpUser(BuildContext context) async {
    isLoading = true;
    File? profileImage = image;
    if (profileImage != null) {
      String res = await AuthMethods().signupUser(
        email: emailController.text,
        password: passwordController.text,
        username: nameController.text,
        bio: bioController.text,
        profileImage: profileImage,
      );
      isLoading = false;
      if (res == 'success') {
        // Reset the image after successful sign up
        _image = null;
      }
      showSnackBar(context, res);
      if (res == 'success') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder:(context)=>ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout()) ), (route) => false);      }
    } else {
      isLoading = false;
      showSnackBar(context, "Please select an image.");
    }
  }

  Future<void> loginUser(BuildContext context) async {
    isLoading = true;
    String res = await AuthMethods().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );
    isLoading = false;
    showSnackBar(context, res);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder:(context)=>ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout()) ), (route) => false);
    }
  }
}

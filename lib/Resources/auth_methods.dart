import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:olxclone/Models/user_model.dart' as model;

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<model.User> getUserDetails()async{
    User currentUser=_auth.currentUser!;
    DocumentSnapshot  snap=await FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid).get();
      return model.User.fromSnap(snap);
  }



  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required File profileImage, // Change the parameter type to File
  }) async {
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          profileImage != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Upload the profile image to Firebase Storage
        String photoUrl = await _uploadImageToStorage(
            profileImage, 'profilePics', cred.user!.uid);

         model.User _user=model.User(
           username: username,
           uid: cred.user!.uid,
           email: email,
           bio: bio,
           followers: [],
           following: [],
           photoUrl: photoUrl,
         );
        await _firestore.collection('users').doc(cred.user!.uid).set(
           _user.toJson()

        );
        return 'success';
      }
    } catch (e) {
      return e.toString();
    }
    return 'Some error occurred';
  }

  // Function to upload the image to Firebase Storage
  Future<String> _uploadImageToStorage(File imageFile, String folderName, String filename) async {
    try {
      Reference reference = _storage.ref().child('$folderName/$filename.jpg');
      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw e;
    }
  }

  Future<String> loginUser({required String email, required String password}) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        return 'success';
      }
    } catch (e) {
      return e.toString();
    }
    return 'Some error occurred';
  }
}

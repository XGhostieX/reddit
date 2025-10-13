import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/utils/assets.dart';
import 'auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRepoImpl(this.firebaseFirestore, this.firebaseAuth, this.googleSignIn);

  CollectionReference get _users => firebaseFirestore.collection('users');

  @override
  void signInWithGoogle() async {
    try {
      googleSignIn;
      final GoogleSignInAccount googleUser = await googleSignIn
          .initialize()
          .then((value) => googleSignIn.authenticate());
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      if (userCredential.additionalUserInfo!.isNewUser) {
        await _users
            .doc(userCredential.user!.uid)
            .set(
              UserModel(
                name: userCredential.user!.displayName ?? 'Unknown',
                profile: userCredential.user!.photoURL ?? Assets.avatar,
                banner: Assets.banner,
                uid: userCredential.user!.uid,
                isAuthenticated: true,
                karma: 0,
                awards: [],
              ).toMap(),
            );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/utils/assets.dart';
import 'auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRepoImpl(this.firebaseFirestore, this.firebaseAuth, this.googleSignIn);

  CollectionReference get _users => firebaseFirestore.collection('users');
  Stream<UserModel> getUser(String uid) {
    return _users
        .doc(uid)
        .snapshots()
        .map(
          (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
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
      UserModel user;
      if (userCredential.additionalUserInfo!.isNewUser) {
        user = UserModel(
          name: userCredential.user!.displayName ?? 'Unknown',
          profile: userCredential.user!.photoURL ?? Assets.avatar,
          banner: Assets.banner,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [],
        );
        await _users.doc(userCredential.user!.uid).set(user.toMap());
      } else {
        user = await getUser(userCredential.user!.uid).first;
      }
      return right(user);
    } on GoogleSignInException catch (e) {
      return left(GoogleSignInFailure.handleGoogleSignInException(e));
    } catch (e) {
      return Left(GoogleSignInFailure(e.toString()));
    }
  }
}

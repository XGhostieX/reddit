import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/service_locator.dart';
import 'auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRepoImpl(this.firebaseFirestore, this.firebaseAuth, this.googleSignIn);

  CollectionReference get _users => firebaseFirestore.collection('users');

  @override
  Stream<UserModel> getUser(String uid) {
    return _users
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  @override
  Stream<User?> get authStateChange => firebaseAuth.authStateChanges();

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle(bool fromGuest) async {
    try {
      googleSignIn;
      final GoogleSignInAccount googleUser = await googleSignIn.initialize().then(
        (value) => googleSignIn.authenticate(),
      );
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      UserCredential userCredential;
      if (fromGuest) {
        userCredential = await firebaseAuth.currentUser!.linkWithCredential(credential);
      } else {
        userCredential = await firebaseAuth.signInWithCredential(credential);
      }
      UserModel user;
      if (userCredential.additionalUserInfo!.isNewUser) {
        user = UserModel(
          name: userCredential.user!.displayName ?? 'Unknown',
          profile: userCredential.user!.photoURL ?? Assets.avatar,
          banner: Assets.banner,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [
            'awesome',
            'gold',
            'helpful',
            'platinum',
            'plusone',
            'rocket',
            'thankyou',
            'til',
          ],
        );
        await _users.doc(userCredential.user!.uid).set(user.toMap());
      } else {
        user = await getUser(userCredential.user!.uid).first;
      }
      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure.handleFirebaseAuthException(e));
    } on GoogleSignInException catch (e) {
      return left(AuthFailure.handleGoogleSignInException(e));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await googleSignIn.signOut();
      return right(await firebaseAuth.signOut());
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure.handleFirebaseAuthException(e));
    } on GoogleSignInException catch (e) {
      return left(AuthFailure.handleGoogleSignInException(e));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInAsGuest() async {
    try {
      UserCredential userCredential = await firebaseAuth.signInAnonymously();
      UserModel user;

      user = UserModel(
        name: 'Guest',
        profile: Assets.avatar,
        banner: Assets.banner,
        uid: userCredential.user!.uid,
        isAuthenticated: false,
        karma: 0,
        awards: [],
      );
      await _users.doc(userCredential.user!.uid).set(user.toMap());
      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure.handleFirebaseAuthException(e));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

final authRepoProvider = Provider(
  (ref) => AuthRepoImpl(
    ref.read(firebaseFirestoreProvider),
    ref.read(firebaseAuthProvider),
    ref.read(googleSignInProvider),
  ),
);

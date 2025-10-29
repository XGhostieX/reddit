import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/failure.dart';
import 'service_locator.dart';

class FirebaseService {
  final FirebaseStorage firebaseStorage;

  FirebaseService(this.firebaseStorage);

  Future<Either<Failure, String>> storeImage({
    required String path,
    required String id,
    required File image,
  }) async {
    try {
      final snapshot = await firebaseStorage.ref().child(path).child(id).putFile(image);
      return right(await snapshot.ref.getDownloadURL());
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseStorageException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteImage({required String path, required String id}) async {
    try {
      return right(await firebaseStorage.ref().child(path).child(id).delete());
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseStorageException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }
}

final firebaseServiceProvider = Provider(
  (ref) => FirebaseService(ref.read(firebaseStorageProvider)),
);

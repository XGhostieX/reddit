import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/models/user_model.dart';

abstract class ProfileRepo {
  Future<Either<Failure, void>> editProfile(UserModel user);
  Stream<List<PostModel>> getUserPosts(String uid);
  Future<Either<Failure, void>> updateKarma(UserModel user);
}

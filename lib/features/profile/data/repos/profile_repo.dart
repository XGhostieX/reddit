import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/user_model.dart';

abstract class ProfileRepo {
  Future<Either<Failure, void>> editProfile(UserModel user);
}

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/post_model.dart';

abstract class PostRepo {
  Future<Either<Failure, void>> addPost(PostModel post);
}

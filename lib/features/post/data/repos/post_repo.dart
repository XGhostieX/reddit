import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/post_model.dart';

abstract class PostRepo {
  Future<Either<Failure, void>> addPost(PostModel post);
  Stream<List<PostModel>> getPosts(List<CommunityModel> communities);
  Future<Either<Failure, void>> deletePost(PostModel post);
  Future<Either<Failure, void>> upvotePost(PostModel post, String uid);
  Future<Either<Failure, void>> downvotePost(PostModel post, String uid);
}

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/community_model.dart';

abstract class CommunityRepo {
  Future<Either<Failure, void>> createCommunity(CommunityModel community);
  Future<Either<Failure, void>> editCommunity(CommunityModel community);
  Stream<List<CommunityModel>> getUserCommunities(String uid);
  Stream<CommunityModel> getCommunity(String name);
}

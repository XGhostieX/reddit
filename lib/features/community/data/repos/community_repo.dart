import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/community_model.dart';

abstract class CommunityRepo {
  Future<Either<Failure, void>> createCommunity(CommunityModel community);
  Future<Either<Failure, void>> editCommunity(CommunityModel community);
  Future<Either<Failure, void>> joinCommunity(String name, String uid);
  Future<Either<Failure, void>> leaveCommunity(String name, String uid);
  Stream<List<CommunityModel>> getUserCommunities(String uid);
  Stream<List<CommunityModel>> searchCommunity(String query);
  Stream<CommunityModel> getCommunity(String name);
}

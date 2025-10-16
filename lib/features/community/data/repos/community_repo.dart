import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/community_model.dart';

abstract class CommunityRepo {
  Future<Either<Failure, void>> createCommunity(CommunityModel community);
}

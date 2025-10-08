// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';

// final getIt = GetIt.instance;

// void setup() {
//   getIt.registerSingleton<Dio>(Dio());
//   getIt.registerSingleton<DatabaseHelper>(SQLiteDatabaseHelper());
//   getIt.registerSingleton<ApiService>(ApiService(getIt.get<Dio>()));
//   getIt.registerSingleton<Mapper>(MapperImpl());
//   getIt.registerSingleton<AuthLocalDataSource>(
//     AuthLocalDataSourceImpl(getIt.get<DatabaseHelper>()),
//   );
//   getIt.registerSingleton<AuthRepo>(
//     AuthRepoImpl(getIt.get<AuthLocalDataSource>()),
//   );
//   getIt.registerSingleton<HomeRepo>(
//     HomeRepoImpl(getIt.get<ApiService>(), getIt.get<Mapper>()),
//   );
//   getIt.registerSingleton<DetailsRepo>(
//     DetailsRepoImpl(getIt.get<ApiService>(), getIt.get<Mapper>()),
//   );
//   getIt.registerSingleton<SearchRepo>(
//     SearchRepoImpl(getIt.get<ApiService>(), getIt.get<Mapper>()),
//   );
//   getIt.registerSingleton<ActorRepo>(
//     ActorRepoImpl(getIt.get<ApiService>(), getIt.get<Mapper>()),
//   );
// }

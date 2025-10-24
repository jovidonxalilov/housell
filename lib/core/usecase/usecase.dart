import '../either/either.dart';
import '../error/failure.dart';

abstract class UseCase<Type, Params>{
  Future<Either<Failure, Type>> call(Params param);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}
class NoParams{}
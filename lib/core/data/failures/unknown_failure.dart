import 'package:testing_flutter_apps_workshop/core/data/failures/failure.dart';

class UnknownFailure extends Failure {
  UnknownFailure({
    required this.exception,
  });

  final Exception exception;
}

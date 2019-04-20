import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PostsEvent extends Equatable {
  PostsEvent([List props = const []]) : super(props);
}

class Fetch extends PostsEvent {
  @override
  String toString() => "Fetch";
}


import 'package:equatable/equatable.dart';
import 'package:image_collage_widget/model/images.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CollageState extends Equatable {
  CollageState([List props = const []]) : super();
}

class InitialState extends CollageState {
  @override
  String toString() => 'InitialState';

  @override
  List<Object> get props => [];
}

class PermissionDeniedState extends CollageState {

  @override
  String toString() => 'PermissionDeniedState';

  @override
  List<Object> get props => [];
}

class LoadImageState extends CollageState {

  @override
  String toString() => 'LoadImageState';

  @override
  List<Object> get props => [];
}

class ImageListState extends CollageState {

  final List<Images> images;

  ImageListState({
    this.images = const [],
  }) : super([images]);

  ImageListState copyWith({
    List<Images>? images,
  }) {
    return ImageListState(
      images: images ?? this.images,
    );
  }

  @override
  String toString() => 'ImageListState';

  @override
  List<Object> get props => [images];
}


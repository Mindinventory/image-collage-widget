
import 'package:image_collage_widget/model/images.dart';

class image_list_state {
  final List<Images> imageList;
  final bool isImageLoadedStarted;
  final bool isPermissionGranted;

  const image_list_state({this.imageList, this.isImageLoadedStarted, this.isPermissionGranted});

  factory image_list_state.initial() => image_list_state(
    imageList: List<Images>(),
    isImageLoadedStarted: false,
    isPermissionGranted: false,
  );

  currentState() => image_list_state(
    imageList: imageList,
    isImageLoadedStarted: false,
    isPermissionGranted: false,
  );
}

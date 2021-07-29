library image_collage_widget;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage_widget/utils/collage_type.dart';
import 'package:image_collage_widget/utils/permission_type.dart';
import 'package:image_collage_widget/utils/extensions.dart';
import 'package:image_collage_widget/widgets/row_widget.dart';

import 'blocs/bloc.dart';

/// A ImageCollageWidget.
class ImageCollageWidget extends StatefulWidget {
  final String? filePath;
  final CollageType collageType;
  final bool withImage;

  const ImageCollageWidget(
      {required this.collageType, Key? key, this.filePath, this.withImage = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImageCollageWidget(filePath: filePath, collageType: collageType);
  }
}

class _ImageCollageWidget extends State<ImageCollageWidget>
    with WidgetsBindingObserver {
  _ImageCollageWidget({required this.collageType, this.filePath});

  String? filePath;
  final CollageType collageType;
  bool withImage = false;

  late CollageBloc _imageListBloc;
  bool isFromPermissionButton = false;

  @override
  void initState() {
    super.initState();

    withImage = widget.withImage;

    WidgetsBinding.instance!.addObserver(this);
    _imageListBloc =
        CollageBloc(context: context, path: filePath, collageType: collageType);

    if (withImage && !Platform.isIOS) {
      _handlePermission();
    } else {
      _imageListBloc.add(ImageListEvent(_imageListBloc.blankList()));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _imageListBloc,
        builder: (context, CollageState? state) {
          if (state is PermissionDeniedState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      'To show images you have to allow storage permission.'),
                  TextButton(
                    style: ButtonStyle().flatButton,
                    child: Text('Allow'),
                    onPressed: _handlePermission,
                  ),
                ],
              ),
            );
          }

          if (state is LoadImageState) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }

          if (state is ImageListState) {
            return _gridView();
          }

          return Container();
        });
  }

  void _handlePermission() {
    _imageListBloc.dispatchCheckPermissionEvent(
        permissionType: PermissionType.Storage);
  }

  Widget _gridView() {
    return AspectRatio(
      aspectRatio: 1.0 / 1.0,
      child: GridCollageWidget(collageType, _imageListBloc),
    );
  }
}
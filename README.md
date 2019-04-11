# Image Collage Widget

A flutter package for creating photo collages in your applications.

## Preview
![image](https://github.com/Mindinventory/image-collage-widget/blob/master/media/center_big_fr.png)  ![image](https://github.com/Mindinventory/image-collage-widget/blob/master/media/left_big_rf.png)   ![image](https://github.com/Mindinventory/image-collage-widget/blob/master/media/v_split_rf.png)

## Key Features

* Create 11 different type of collages.
* Start with or without images from gallery preloaded (Only for Android).
* Allow user to add or remove photo into collage.
* User can update images from gallery/camera.
* Don't worry about `permissions`, we handled it.


## Usage

 * Step 1:- Prepare AndroidManifest.xml
 
    ```xml
        <uses-permission android:name="android.permission.CAMERA" />

        <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
        <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    ```

 * Step 2:- Prepare Info.plist

    ```xml
        <key>NSPhotoLibraryUsageDescription</key>
        <string>Need to access photo library</string>
        <key>NSCameraUsageDescription</key>
        <string>To upload your picture</string>
    ```

 * Step 3:- To use this package, add `image_collage_widget ` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

     ```yaml
         dependencies:
           ...
           image_collage_widget: ^0.0.2
     ```

 * Step 4:- Add `ImageCollageWidget` in your dart file

   ```dart
         import 'package:image_collage_widget/image_collage_widget.dart';
         import 'package:image_collage_widget/utils/collage_type.dart';
         
         ...
         
      /// @param withImage:- If withImage = true, It will load image from given {filePath (default = "Camera")}
      /// @param collageType:- CollageType.CenterBig

              child: ImageCollageWidget(
                collageType: widget.collageType,
                withImage: true,
                filePath: _directory?.path?.toString(),
              ),

   ```

### Dependencies

* flutter_staggered_grid_view: ^0.2.7
* flutter_bloc: ^0.9.0
* flutter_file_manager: ^0.0.6
* permission_handler: ^3.0.0
* image_picker: ^0.5.0+9
* equatable: ^0.2.3

# LICENSE!

Image Collage Widget is [MIT-licensed](/LICENSE).


# Let us know!

We’d be really happy if you send us links to your projects where you use our component. Just send an email to sales@mindinventory.com And do let us know if you have any questions or suggestion regarding our work.

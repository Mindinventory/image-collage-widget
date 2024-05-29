# Image Collage Widget

A flutter package for creating photo collages in your applications.

## Preview
![image](https://github.com/Mindinventory/image-collage-widget/blob/master/media/center_big_fr.png?raw=true "Title")  ![image](https://github.com/Mindinventory/image-collage-widget/blob/master/media/left_big_rf.png?raw=true "Title")   ![image](https://github.com/Mindinventory/image-collage-widget/blob/master/media/v_split_rf.png?raw=true "Title")

## Key Features

* Create 11 different type of collages.
* Start with or without images from gallery preloaded (Only for Android).
* Allow user to add or remove photo into collage.
* User can update images from gallery/camera.
* Don't worry about `permissions`, we handled it.


## Usage

* Step 1:- To use this package, add `image_collage_widget ` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

    ```yaml
        dependencies:
          ...
          image_collage_widget: ^1.0.5
    ```


* Step 2:- Prepare AndroidManifest.xml

   ```
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-feature android:name="android.hardware.camera" />

    <!-- Devices running Android 13 (API level 33) or higher -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />

    <!-- To handle the reselection within the app on devices running Android 14
         or higher if your app targets Android 14 (API level 34) or higher.  -->
    <uses-permission android:name="android.permission.READ_MEDIA_VISUAL_USER_SELECTED" />
  
   ```

  * Step 3:- Prepare Info.plist

     ```
         <key>NSPhotoLibraryUsageDescription</key>
         <string>Need to access photo library</string>
         <key>NSCameraUsageDescription</key>
         <string>To upload your picture</string>
     ```

    * Step 4:- Add `ImageCollageWidget` in your dart file

      ```
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

* flutter_staggered_grid_view
* flutter_bloc
* flutter_file_manager
* permission_handler
* image_picker
* equatable

# LICENSE!

Image Collage Widget is [MIT-licensed](/LICENSE).


# Let us know!

We’d be really happy if you send us links to your projects where you use our component. Just send an email to sales@mindinventory.com And do let us know if you have any questions or suggestion regarding our work.

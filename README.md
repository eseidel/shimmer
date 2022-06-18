# shimmer

Playing with Flame and dart_frog.

## Dependencies

You will need Flutter 3.0 or later.  Flutter will also install Dart.
flutter.dev/install

You will want `melos` and `dart_frog` installed:

`dart pub global activate melos`
`dart pub global activate dart_frog`

Once you've done that `melos bootstrap` at the root will set up your workspace
including fetching pub packages.

### To launch the server:

`cd packages/shimmer_server`
`dart_frog dev`

### To launch the client:
`cd packages/shimmer_client`
`flutter run`
Also works fine from within an IDE.

Edits you make to any of the above should be hot-reloaded automatically.

If you plan to edit the @JsonSerializable classes, you will also need to run:
`flutter packages pub run build_runner build`
or to have it run continuously while you edit:
`flutter pub run build_runner watch --delete-conflicting-outputs`

### IDE Support

You might want the Melos extension:
https://marketplace.visualstudio.com/items?itemName=blaugold.melos-code

If you're using intellij, you may wish to remove the:
```
ide:
  intellij: false
```
line from melos.yaml and re-run `melos bootstrap` to generate .iml files.

Patches welcome!
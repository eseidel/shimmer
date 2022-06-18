# shimmer

Playing with [Flame](https://flame-engine.org/) and
[dart_frog](https://github.com/VeryGoodOpenSource/dart_frog).

## Dependencies

You will need [Flutter 3.0 or later](https://flutter.dev/install).
Installing Flutter will also install Dart.


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

The client can also be launched fine from within an IDE.  I personally open
the root and just click on packages/shimmer_client/main.dart and click run.

Edits made should hot-reload automatically to both client and server.

If you plan to edit the @JsonSerializable classes, you will also need to run:
`flutter packages pub run build_runner build`
or to have it run continuously while you edit:
`flutter pub run build_runner watch --delete-conflicting-outputs`

### Flutter Web support

The client does work from Flutter Web, but hits CORS errors when served
from localhost on a separate port from the server.

There are a variety of ways to work around the CORS errors, but it will be
much easier when we can just serve the Flutter Web bits from the server
https://github.com/VeryGoodOpenSource/dart_frog/issues/89

### IDE Support

You might want the Melos extension:
https://marketplace.visualstudio.com/items?itemName=blaugold.melos-code

If you're using intellij, you may wish to remove:
```
ide:
  intellij: false
```
from melos.yaml and re-run `melos bootstrap` to generate .iml files.

Patches welcome!
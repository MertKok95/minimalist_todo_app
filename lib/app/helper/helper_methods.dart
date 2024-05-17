import 'dart:math';

import '../../constants/string_constants.dart';

class HelperMethods {
  HelperMethods() {}

  String getRandomString(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => StringConstants.chars
            .codeUnitAt(Random().nextInt(StringConstants.chars.length)),
      ),
    );
  }
}


import 'dart:math';

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
}

int generateRandomInt() {
  var rn = new Random();
  return 100000 + rn.nextInt(999999 - 100000);
}
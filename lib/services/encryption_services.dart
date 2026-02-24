import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class EncryptionServices {
  final String secreteKey = "theSuperSecretKey456";

  String? encrypt(String plainText) {
    try {
      final salt = genRandomWithNonZero(8);
      KeyIVModel keyndIV = deriveKeyAndIV(salt);
      final key = Key(keyndIV.key);
      final iv = IV(keyndIV.iv);
      final encrypter =
          Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      Uint8List encryptedBytesWithSalt = Uint8List.fromList(
          createUint8ListFromString("Salted__") + salt + encrypted.bytes);
      return base64Encode(encryptedBytesWithSalt);
    } catch (error) {
      print("inside encrypt encryption services catch block $e");
      return null;
    }
  }

  String? decrypt(String encryptedText) {
    try {
      Uint8List encryptedBytesWithSalt = base64.decode(encryptedText);
      Uint8List encryptedBytes =
          encryptedBytesWithSalt.sublist(16, encryptedBytesWithSalt.length);
      final salt = encryptedBytesWithSalt.sublist(8, 16);
      KeyIVModel keyndIV = deriveKeyAndIV(salt);
      final key = Key(keyndIV.key);
      final iv = IV(keyndIV.iv);
      final encrypter =
          Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
      final decrypted =
          encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
      return decrypted;
    } catch (e, s) {
      print("inside decrypt encryption services catch block $e  $s");
    }
  }

  Uint8List genRandomWithNonZero(int seedLength) {
    final random = Random.secure();
    const int randomMax = 245;
    final Uint8List uint8list = Uint8List(seedLength);
    for (int i = 0; i < seedLength; i++) {
      uint8list[i] = random.nextInt(randomMax) + 1;
    }
    return uint8list;
  }

  KeyIVModel deriveKeyAndIV(Uint8List salt) {
    var password = createUint8ListFromString(secreteKey);
    Uint8List concatenatedHashes = Uint8List(0);
    Uint8List currentHash = Uint8List(0);
    bool enoughBytesForKey = false;
    Uint8List preHash = Uint8List(0);

    while (!enoughBytesForKey) {
      int preHashLength = currentHash.length + password.length + salt.length;
      if (currentHash.length > 0)
        preHash = Uint8List.fromList(currentHash + password + salt);
      else
        preHash = Uint8List.fromList(password + salt);

      currentHash = Uint8List.fromList(md5.convert(preHash).bytes);
      concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash);
      if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
    }

    var keyBtyes = concatenatedHashes.sublist(0, 32);
    var ivBtyes = concatenatedHashes.sublist(32, 48);
    return KeyIVModel(key: keyBtyes, iv: ivBtyes);
  }

  Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }
}

class KeyIVModel {
  final Uint8List key;
  final Uint8List iv;
  KeyIVModel({required this.key, required this.iv});
}

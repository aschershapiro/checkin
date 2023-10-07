import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class Encryption {
  static String encryptStringWithPassword(String text, String password) {
    if (password == '' || text == '') return text;
    final key = sha256.convert(utf8.encode(password)).bytes;
    final iv = List<int>.generate(16, (_) => 0); // Initialization vector
    final encrypter = Encrypter(AES(Key(Uint8List.fromList(key))));
    final encrypted = encrypter.encrypt(text, iv: IV(Uint8List.fromList(iv)));
    return encrypted.base64;
  }

  static String decryptStringWithPassword(
      String encryptedText, String password) {
    if (password == '' || encryptedText == '') return encryptedText;
    final key = sha256.convert(utf8.encode(password)).bytes;
    final iv = List<int>.generate(16, (_) => 0); // Initialization vector
    final encrypter = Encrypter(AES(Key(Uint8List.fromList(key))));
    final encrypted = Encrypted.fromBase64(encryptedText);
    final decrypted =
        encrypter.decrypt(encrypted, iv: IV(Uint8List.fromList(iv)));
    return decrypted;
  }
}

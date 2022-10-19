import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageService {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static Future<StorageFile> saveFile(
    File file,
    String filePath, {
      Function(String)? onStatusChanged
    }
  ) async {
    Reference fileRef = _firebaseStorage.ref().child(filePath);
    UploadTask uploadTask = fileRef.putFile(file);
    if (onStatusChanged != null) {
      uploadTask.snapshotEvents.listen((event) =>
        onStatusChanged('${(event.bytesTransferred / event.totalBytes * 100 / 1.25).round()}%')
      );
    }
    return StorageFile(
      path: fileRef.fullPath,
      url: await (await uploadTask).ref.getDownloadURL()
    );
  }

  static Future<void> removeFile(String filePath) {
    return _firebaseStorage.ref().child(filePath).delete();
  }
}

class StorageFile {
  final String path;
  final String url;

  StorageFile({
    required this.path,
    required this.url
  });
}
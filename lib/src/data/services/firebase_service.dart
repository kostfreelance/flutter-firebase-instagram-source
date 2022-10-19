import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseService {
  static Future<void> init() {
    return Firebase.initializeApp();
  }

  static String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<List<DocumentSnapshot>> getDocsByIds(
    List<String> ids,
    String collectionPath,
    Object field, {
      DocumentSnapshot? docSnapshot,
      int? limit,
      String? orderByField,
      bool? orderByDescending
    }
  ) async {
    if (ids.isEmpty) {
      return [];
    }
    ids = ids.toSet().toList();
    List<List<DocumentSnapshot>> chunkDocs = await Future.wait(_partitionListToChunks(ids, 10).map((idsChunk) async {
      Query query = FirebaseFirestore.instance
        .collection(collectionPath)
        .where(field, whereIn: idsChunk);
      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: orderByDescending ?? false);
      }
      if (docSnapshot != null) {
        query = query.startAfterDocument(docSnapshot);
      }
      if (limit != null) {
        query = query.limit(limit);
      }
      QuerySnapshot collectionSnapshot = await query.get();
      return collectionSnapshot.docs;
    }));
    return chunkDocs.fold<List<DocumentSnapshot>>([], (prevDocs, currentDocs) {
      for (DocumentSnapshot currentDoc in currentDocs) {
        prevDocs.add(currentDoc);
      }
      return prevDocs;
    });
  }

  static List _partitionListToChunks(List list, int chunkSize) {
    if (list.isEmpty) {
      return [[]];
    }
    List chunks = [];
    int listLength = list.length;
    if (chunkSize > 0) {
      for (var i = 0; i < listLength; i += chunkSize) {
        int end = i + chunkSize;
        chunks.add(list.sublist(i, (end > listLength) ? listLength : end));
      }
    } else {
      chunks.add(list.sublist(0, listLength));
    }
    return chunks;
  }
}
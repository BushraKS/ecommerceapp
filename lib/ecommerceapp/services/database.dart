import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userinfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userinfoMap);
  }

  Future addProductDetails(
      Map<String, dynamic> userinfoMap, String category) async {
    return await FirebaseFirestore.instance
        .collection(category)
        .add(userinfoMap);
  }

  Future addAllProducts(Map<String, dynamic> userinfoMap) async {
    return await FirebaseFirestore.instance
        .collection("products")
        .add(userinfoMap);
  }

  Future<QuerySnapshot> search(String uname) async {
    return await FirebaseFirestore.instance
        .collection("products")
        .get();
  }

  Future<Stream<QuerySnapshot>> getProducts(String category) async {
    return await FirebaseFirestore.instance.collection(category).snapshots();
  }
}

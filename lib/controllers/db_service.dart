import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class DbService{

  User? user = FirebaseAuth.instance.currentUser;

  //USER DATA
  //ADD USER TO FIRESTORE

Future saveUserData ({required String name, required String email}) async{


  try{
    Map<String, dynamic> data ={

      "name": name,
      "email": email,

    };

   
    await FirebaseFirestore.instance
    .collection("shop-users")
    .doc(user!.uid)
    .set(data);

  }catch (e){
    print("Error on saving user data: $e");
  }



}


  //update the data of the user in firestore

Future updateUserData({required Map<String, dynamic> extraData}) async {

await FirebaseFirestore.instance
    .collection("shop-users")
    .doc(user!.uid)
    .update(extraData);




}

//read current user data


Stream <DocumentSnapshot> readUserData(){
return FirebaseFirestore.instance
    .collection("shop-users")
    .doc(user!.uid)
    .snapshots();

}

//read all promos and banners

Stream <QuerySnapshot> readPromos(){
return FirebaseFirestore.instance
    .collection("Shop_Promo")
    .snapshots();

}
Stream <QuerySnapshot> readBanners(){
return FirebaseFirestore.instance
    .collection("shop_banners")
    .snapshots();

}

//DISCOUNT
//read discount coupons

Stream<QuerySnapshot> readDiscountCoupons() {
  return FirebaseFirestore.instance
      .collection("shop_coupons")
      .orderBy("discount", descending: true)
      .snapshots();
      
      }

      //verify the coupons

Future<QuerySnapshot> verifyDiscount({required String code}){
  print("searching for code : $code");
  return FirebaseFirestore.instance
  .collection("shop_coupons")
  .where("code", isEqualTo: code)
  .get();
}


      //read all categories from firestore
Stream<QuerySnapshot> readCategories() {

  return FirebaseFirestore.instance
      .collection("shop_categories") .orderBy("priority", descending: true)
      .snapshots();
}

//products
//read all products from firestore
Stream<QuerySnapshot> readProducts( String category) {
  return FirebaseFirestore.instance
      .collection("shop_products")
      .where("category", isEqualTo: category.toLowerCase())
      .snapshots();
}

//search  products by doc id


Stream<QuerySnapshot> searchProducts(List<String>  docsIds){
  // Filter out empty strings from docsIds
  List<String> filteredDocsIds = docsIds.where((id) => id.isNotEmpty).toList();

  if(filteredDocsIds.isEmpty){
    // Return an empty stream if no valid document IDs
    return Stream.empty();
  }

  return FirebaseFirestore.instance
  .collection("shop_products")
  .where(FieldPath.documentId, whereIn: filteredDocsIds)
  .snapshots();
}

//reduce the count of products after purchase

Future reduceQuantity(
  {
    required String productId, required int quantity
  }
) async{
   await FirebaseFirestore.instance
   .collection("shop_prodcts")
   .doc(productId)
   .update({
    "quantity": FieldValue.increment(-quantity)
   });

}


//cart
//display cart items to user


Stream <QuerySnapshot> readUserCart() {
  return FirebaseFirestore.instance
      .collection("shop-users")
      .doc(user!.uid)
      .collection("cart")
      .snapshots();



}



// ORDERS
// create a new order


//read the order data of specific user





}
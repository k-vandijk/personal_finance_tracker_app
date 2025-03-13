import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';

// TODO: Voeg caching toe

class AssetsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get assets => _firestore.collection('assets');
  CollectionReference get categories => _firestore.collection('categories');

  Future<List<CategoryDTO>> getAllCategoriesAsync() async {
    try {
      final snapshot = await categories.get();

      return snapshot.docs.map((doc) {
        return CategoryDTO(doc.id, doc['name']);
      }).toList();
    } 
    
    catch (error) {
      rethrow;
    }
  }

  Future<List<AssetDTO>> getAllAssetsAsync() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await assets.where('userId', isEqualTo: userId).get();


      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AssetDTO(
          id: doc.id,
          categoryId: data['categoryId'],
          name: data['name'],
          description: (data['description'] as String?),
          purchasePrice: (data['purchasePrice'] as num).toDouble(),
          purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
          salePrice: data['salePrice'] != null ? (data['salePrice'] as num).toDouble() : null,
          saleDate: data['saleDate'] != null ? (data['saleDate'] as Timestamp).toDate() : null,
          fictionalPrice: data['fictionalPrice'] != null ? (data['fictionalPrice'] as num).toDouble() : null,
        );
      }).toList();
    } 
    
    catch (error) {
      rethrow;
    }
  }

  Future<void> addAssetAsync(CreateAssetDTO asset) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await assets.add({
        'userId': userId,
        'categoryId': asset.categoryId,
        'name': asset.name,
        'description': asset.description,
        'purchasePrice': asset.purchasePrice,
        'purchaseDate': asset.purchaseDate,
        'fictionalPrice': asset.fictionalPrice,
      });
    } 
    
    catch (error) {
      rethrow;
    }
  }

  Future<void> deleteAssetAsync(String id) async {
    try {
      await assets.doc(id).delete();
    } 
    
    catch (error) {
      rethrow;
    }
  }

  Future<void> editAssetAsync(String assetId, CreateAssetDTO asset) async {
    try {
      await assets.doc(assetId).update({
        'categoryId': asset.categoryId,
        'name': asset.name,
        'description': asset.description,
        'purchasePrice': asset.purchasePrice,
        'purchaseDate': asset.purchaseDate,
        'fictionalPrice': asset.fictionalPrice,
      });
    } 
    
    catch (error) {
      rethrow;
    }
  }
}

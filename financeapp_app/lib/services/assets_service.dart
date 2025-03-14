import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get assets => _firestore.collection('assets');
  CollectionReference get categories => _firestore.collection('categories');

  Future<List<CategoryDTO>> getAllCategoriesAsync() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Check if a JSON string for the full category list exists in local storage.
      final cachedJson = prefs.getString('categories');
      if (cachedJson != null) {
        // Decode the JSON and convert to a list of CategoryDTO.
        final List<dynamic> jsonList = jsonDecode(cachedJson);
        return jsonList.map((jsonItem) => CategoryDTO.fromJson(jsonItem)).toList();
      }
      
      // If not cached, fetch categories from Firestore.
      final snapshot = await categories.get();
      final List<CategoryDTO> categoryList = snapshot.docs.map((doc) {
        return CategoryDTO(doc.id, doc['name']);
      }).toList();
      
      // Save the complete list as a JSON string in SharedPreferences.
      final jsonString = jsonEncode(categoryList.map((cat) => cat.toJson()).toList());
      await prefs.setString('categories', jsonString);
      
      return categoryList;
    } 
    
    catch (error) {
      rethrow;
    }
  }

  Future<List<AssetDTO>> getAllAssetsAsync() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Return cached assets if available.
      final cachedJson = prefs.getString('assets');
      if (cachedJson != null) {
        final List<dynamic> jsonList = jsonDecode(cachedJson);
        return jsonList.map((jsonItem) => AssetDTO.fromJson(jsonItem)).toList();
      }

      // If not cached, fetch assets from Firestore.
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await assets.where('userId', isEqualTo: userId).get();

      final List<AssetDTO> assetList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AssetDTO(
          id: doc.id,
          categoryId: data['categoryId'] as String,
          name: data['name'] as String,
          description: data['description'] as String?,
          purchasePrice: (data['purchasePrice'] as num).toDouble(),
          purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
          salePrice: data['salePrice'] != null ? (data['salePrice'] as num).toDouble() : null,
          saleDate: data['saleDate'] != null ? (data['saleDate'] as Timestamp).toDate() : null,
          fictionalPrice: data['fictionalPrice'] != null ? (data['fictionalPrice'] as num).toDouble() : null,
        );
      }).toList();

      // Cache the fetched asset list as a JSON string.
      final jsonString = jsonEncode(assetList.map((asset) => asset.toJson()).toList());
      await prefs.setString('assets', jsonString);

      return assetList;
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

      // Clear the cached asset list to force a refresh.
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('assets');
    } 
    
    catch (error) {
      rethrow;
    }
  }

  Future<void> deleteAssetAsync(String id) async {
    try {
      await assets.doc(id).delete();

      // Clear the cached asset list to force a refresh.
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('assets');
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

      // Clear the cached asset list to force a refresh.
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('assets');
    } 
    
    catch (error) {
      rethrow;
    }
  }
}

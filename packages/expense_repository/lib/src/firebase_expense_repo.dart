import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  FirebaseExpenseRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  String? get userId => _firebaseAuth.currentUser?.uid;

  @override
  Future<void> createCategory(Category category) async {
    try {
      if (userId != null) {
        await usersCollection
            .doc(userId)
            .collection('categories')
            .doc(category.categoryId)
            .set(category.toEntity().toDocument());
      } else {
        throw Exception('No user is currently logged in.');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategory() async {
    try {
      if (userId != null) {
        return await usersCollection
            .doc(userId)
            .collection('categories')
            .get()
            .then((value) => value.docs
                .map((e) => Category.fromEntity(CategoryEntity.fromDocument(e.data())))
                .toList());
      } else {
        throw Exception('No user is currently logged in.');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createExpense(Expense expense) async {
    try {
      if (userId != null) {
        await usersCollection
            .doc(userId)
            .collection('expenses')
            .doc(expense.expenseId)
            .set(expense.toEntity().toDocument());
      } else {
        throw Exception('No user is currently logged in.');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      if (userId != null) {
        return await usersCollection
            .doc(userId)
            .collection('expenses')
            .get()
            .then((value) => value.docs
                .map((e) => Expense.fromEntity(ExpenseEntity.fromDocument(e.data())))
                .toList());
      } else {
        throw Exception('No user is currently logged in.');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

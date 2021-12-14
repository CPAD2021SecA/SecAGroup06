import 'dart:collection';
import 'package:cpad_assignment/models/concern.dart';
import 'package:flutter/material.dart';

class ConcernProvider extends ChangeNotifier {
  List<Concern> _concernList = [];

  int get concernsCount => _concernList.length;

  UnmodifiableListView<Concern> get concernList {
    return UnmodifiableListView(_concernList);
  }

  void updateConcernList(List<Concern> concernList) {
    _concernList.clear();
    _concernList = List.from(concernList);
    _concernList.sort((a, b) {
      DateTime firstDate = DateTime.tryParse(a.date!)!;
      DateTime secondDate = DateTime.tryParse(b.date!)!;
      return secondDate.compareTo(firstDate);
    });
    notifyListeners();
  }

  void addConcern(Concern concern) {
    if (!_concernList.contains(concern)) {
      _concernList.add(concern);
      _concernList
          .sort((a, b) => a.date.toString().compareTo(b.date.toString()));
    }
    notifyListeners();
  }

  void markResolved({required Concern concern, required bool isResolved}) {
    _concernList.remove(concern);
    concern.isResolved = isResolved;
    addConcern(concern);
    notifyListeners();
  }

  void deleteConcern(Concern concern) {
    _concernList.remove(concern);
    notifyListeners();
  }
}

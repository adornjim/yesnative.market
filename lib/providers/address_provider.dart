import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/address.dart';

class AddressNotifier extends Notifier<List<Address>> {
  static const _storageKey = 'saved_addresses';
  final _uuid = const Uuid();

  @override
  List<Address> build() {
    _loadAddresses();
    return [];
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? addressesJson = prefs.getString(_storageKey);
    
    if (addressesJson != null) {
      final List<dynamic> decodedList = json.decode(addressesJson);
      final List<Address> addresses = decodedList.map((item) => Address.fromMap(item)).toList();
      state = addresses;
    }
  }

  Future<void> _saveAddresses(List<Address> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = json.encode(addresses.map((a) => a.toMap()).toList());
    await prefs.setString(_storageKey, encodedList);
  }

  Future<void> addAddress(Address address) async {
    final newAddress = address.copyWith(
      id: _uuid.v4(),
      isDefault: state.isEmpty ? true : address.isDefault,
    );

    List<Address> newState;
    if (newAddress.isDefault) {
      newState = state.map((a) => a.copyWith(isDefault: false)).toList();
      newState.add(newAddress);
    } else {
      newState = [...state, newAddress];
    }

    state = newState;
    await _saveAddresses(newState);
  }

  Future<void> updateAddress(Address address) async {
    List<Address> newState;
    if (address.isDefault) {
      newState = state.map((a) {
        if (a.id == address.id) return address;
        return a.copyWith(isDefault: false);
      }).toList();
    } else {
      // If we are unsetting the only default address, we should prevent it or handle it.
      // For simplicity, just update it.
      newState = state.map((a) => a.id == address.id ? address : a).toList();
      
      // Ensure at least one default if list is not empty
      if (newState.isNotEmpty && !newState.any((a) => a.isDefault)) {
        newState[0] = newState[0].copyWith(isDefault: true);
      }
    }

    state = newState;
    await _saveAddresses(newState);
  }

  Future<void> deleteAddress(String id) async {
    final newState = state.where((a) => a.id != id).toList();
    
    if (newState.isNotEmpty && !newState.any((a) => a.isDefault)) {
      newState[0] = newState[0].copyWith(isDefault: true);
    }
    
    state = newState;
    await _saveAddresses(newState);
  }

  Future<void> setDefault(String id) async {
    final newState = state.map((a) => a.copyWith(isDefault: a.id == id)).toList();
    state = newState;
    await _saveAddresses(newState);
  }
}

final addressProvider = NotifierProvider<AddressNotifier, List<Address>>(() {
  return AddressNotifier();
});

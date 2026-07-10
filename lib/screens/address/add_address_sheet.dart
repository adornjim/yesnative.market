import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../models/address.dart';
import '../../providers/address_provider.dart';

class AddAddressSheet extends ConsumerStatefulWidget {
  final Address? existingAddress;

  const AddAddressSheet({super.key, this.existingAddress});

  @override
  ConsumerState<AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends ConsumerState<AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;
  
  String _type = 'Home';
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final a = widget.existingAddress;
    _nameController = TextEditingController(text: a?.fullName ?? '');
    _phoneController = TextEditingController(text: a?.phone ?? '');
    _address1Controller = TextEditingController(text: a?.addressLine1 ?? '');
    _address2Controller = TextEditingController(text: a?.addressLine2 ?? '');
    _cityController = TextEditingController(text: a?.city ?? '');
    _stateController = TextEditingController(text: a?.state ?? '');
    _pincodeController = TextEditingController(text: a?.pincode ?? '');
    _type = a?.type ?? 'Home';
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        id: widget.existingAddress?.id ?? '', // UUID will be generated in provider if new
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        addressLine1: _address1Controller.text.trim(),
        addressLine2: _address2Controller.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        type: _type,
        isDefault: _isDefault,
      );

      if (widget.existingAddress == null) {
        ref.read(addressProvider.notifier).addAddress(address);
      } else {
        ref.read(addressProvider.notifier).updateAddress(address);
      }
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.existingAddress == null ? 'Add New Address' : 'Edit Address',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              AppSpacing.gapVlg,
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                  AppSpacing.gapHmd,
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                      keyboardType: TextInputType.phone,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                        if (val.length != 10 || int.tryParse(val) == null) return 'Enter a valid 10-digit number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVmd,
              
              TextFormField(
                controller: _address1Controller,
                decoration: const InputDecoration(labelText: 'Address Line 1', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              AppSpacing.gapVmd,
              
              TextFormField(
                controller: _address2Controller,
                decoration: const InputDecoration(labelText: 'Address Line 2 (Optional)', border: OutlineInputBorder()),
              ),
              AppSpacing.gapVmd,
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Required';
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)) return 'Invalid city';
                        return null;
                      },
                    ),
                  ),
                  AppSpacing.gapHmd,
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(labelText: 'State', border: OutlineInputBorder()),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Required';
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)) return 'Invalid state';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVmd,
              
              TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(labelText: 'Pincode', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  if (val.length != 6 || int.tryParse(val) == null) return 'Enter a valid 6-digit pincode';
                  return null;
                },
              ),
              AppSpacing.gapVlg,
              
              const Text('Address Type', style: TextStyle(fontWeight: FontWeight.w500)),
              AppSpacing.gapVsm,
              Wrap(
                spacing: 8,
                children: ['Home', 'Work', 'Other'].map((t) {
                  return ChoiceChip(
                    label: Text(t),
                    selected: _type == t,
                    onSelected: (selected) {
                      if (selected) setState(() => _type = t);
                    },
                    selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                  );
                }).toList(),
              ),
              
              AppSpacing.gapVsm,
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Set as Default Address'),
                value: _isDefault,
                onChanged: (val) => setState(() => _isDefault = val),
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
              
              AppSpacing.gapVlg,
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: AppSpacing.edgeInsetsVmd,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.surface,
                ),
                child: const Text('Save Address', style: TextStyle(fontSize: 16)),
              ),
              AppSpacing.gapVxl,
            ],
          ),
        ),
      ),
    );
  }
}

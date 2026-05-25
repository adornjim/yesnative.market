import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/address.dart';
import '../../providers/address_provider.dart';
import 'add_address_sheet.dart';

class SavedAddressesScreen extends ConsumerWidget {
  const SavedAddressesScreen({super.key});

  void _showAddEditSheet(BuildContext context, [Address? address]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AddAddressSheet(existingAddress: address),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off_outlined, size: 64, color: Colors.grey.shade400),
                  AppSpacing.gapVmd,
                  Text('No addresses saved yet', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600)),
                  AppSpacing.gapVlg,
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditSheet(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Address'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: AppSpacing.edgeInsetsMd,
              itemCount: addresses.length,
              separatorBuilder: (context, index) => AppSpacing.gapVmd,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return _buildAddressCard(context, ref, address);
              },
            ),
      floatingActionButton: addresses.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showAddEditSheet(context),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Address', style: TextStyle(color: Colors.white)),
              backgroundColor: Theme.of(context).colorScheme.primary,
            )
          : null,
    );
  }

  Widget _buildAddressCard(BuildContext context, WidgetRef ref, Address address) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: address.isDefault ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: AppSpacing.edgeInsetsLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            address.type == 'Home' ? Icons.home : (address.type == 'Work' ? Icons.work : Icons.location_on),
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            address.type,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Default',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ],
                ),
                AppSpacing.gapVmd,
                Text(address.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                AppSpacing.gapVsm,
                Text('${address.addressLine1}${address.addressLine2.isNotEmpty ? ', ${address.addressLine2}' : ''}', style: TextStyle(color: Colors.grey[700])),
                Text('${address.city}, ${address.state} - ${address.pincode}', style: TextStyle(color: Colors.grey[700])),
                AppSpacing.gapVsm,
                Text('Phone: ${address.phone}', style: TextStyle(color: Colors.grey[700])),
                AppSpacing.gapVmd,
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _showAddEditSheet(context, address),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    AppSpacing.gapHlg,
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Address?'),
                            content: const Text('Are you sure you want to delete this address?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(addressProvider.notifier).deleteAddress(address.id);
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      label: const Text('Delete', style: TextStyle(color: Colors.red)),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    if (!address.isDefault) ...[
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          ref.read(addressProvider.notifier).setDefault(address.id);
                        },
                        child: const Text('Set as Default'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

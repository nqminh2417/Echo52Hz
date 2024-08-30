import 'package:flutter/material.dart';

import 'data_sync_service.dart';

class DataSyncModal extends StatefulWidget {
  const DataSyncModal({super.key});

  @override
  State<DataSyncModal> createState() => _DataSyncModalState();
}

class _DataSyncModalState extends State<DataSyncModal> {
  bool _isSyncing = false;
  String _syncStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _syncData();
  }

  Future<void> _syncData() async {
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Syncing data...';
    });

    try {
      await DataSyncService.syncData();
      setState(() {
        _isSyncing = false;
        _syncStatus = 'Synchronization complete!';
      });
    } catch (e) {
      setState(() {
        _isSyncing = false;
        _syncStatus = 'Error: $e';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isSyncing) const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(_syncStatus),
              if (!_isSyncing)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

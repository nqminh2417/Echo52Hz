import 'package:flutter/material.dart';

import 'data_sync_model.dart';
import 'data_sync_service.dart';

class DataSyncScreen extends StatefulWidget {
  const DataSyncScreen({super.key});

  @override
  State<DataSyncScreen> createState() => _DataSyncScreenState();
}

class _DataSyncScreenState extends State<DataSyncScreen> {
  final DataSyncService _dataSyncService = DataSyncService();
  SyncProgress? _syncProgress;
  SyncError? _syncError;

  @override
  void initState() {
    super.initState();
    _startSync();
  }

  Future<void> _startSync() async {
    try {
      setState(() {
        _syncProgress = null;
        _syncError = null;
      });
      final progress = await _dataSyncService.synchronizeData();
      setState(() {
        // _syncProgress = progress;
      });
    } catch (e) {
      setState(() {
        _syncError = SyncError(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Synchronization'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_syncProgress != null)
              LinearProgressIndicator(value: _syncProgress!.completedItems / _syncProgress!.totalItems),
            if (_syncProgress != null)
              Text('${_syncProgress!.completedItems}/${_syncProgress!.totalItems} items synced'),
            if (_syncError != null) Text(_syncError!.message),
          ],
        ),
      ),
    );
  }
}

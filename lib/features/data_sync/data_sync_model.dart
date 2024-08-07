class SyncProgress {
  final int totalItems;
  final int completedItems;

  SyncProgress({
    required this.totalItems,
    required this.completedItems,
  });
}

class SyncError {
  final String message;

  SyncError(this.message);
}

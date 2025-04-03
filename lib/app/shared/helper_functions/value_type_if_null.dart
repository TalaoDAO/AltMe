 String? valueTypeIfNull(dynamic data) {
    if (data is String) {
      if (data.startsWith('data:image/jpeg;base64')) {
        return 'image/jpeg';
      }
      if (data.startsWith('data:image/png;base64')) {
        return 'image/png';
      }
    }
    return null;
  }
  

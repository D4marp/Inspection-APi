abstract final class TrainingNavigationPolicy {
  static bool allows(String rawUrl) {
    if (rawUrl == 'about:blank') return true;
    final uri = Uri.tryParse(rawUrl);
    return uri?.scheme == 'file';
  }
}

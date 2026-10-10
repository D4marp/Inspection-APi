String? validateNote(String condition, String raw) {
  final note = raw.trim();
  if (note.length > 500) return 'Maksimal 500 karakter';
  if (condition == 'needs_action' && note.length < 10) {
    return 'Temuan membutuhkan catatan minimal 10 karakter';
  }
  return null;
}

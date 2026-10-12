const CONDITIONS = new Set(['good', 'needs_action']);

const requiredString = (value, field, maxLength, errors) => {
  if (typeof value !== 'string' || value.trim().length === 0) {
    errors[field] = 'Field wajib diisi.';
    return '';
  }
  const normalized = value.trim();
  if (normalized.length > maxLength) {
    errors[field] = `Maksimal ${maxLength} karakter.`;
  }
  return normalized;
};

export function normalizeCreateInspection(input) {
  const errors = {};
  if (input === null || typeof input !== 'object' || Array.isArray(input)) {
    return { value: null, errors: { body: 'Body harus berupa JSON object.' } };
  }

  const assetCode = requiredString(input.assetCode, 'assetCode', 30, errors);
  const location = requiredString(input.location, 'location', 80, errors);
  const condition =
    typeof input.condition === 'string' ? input.condition.trim() : '';
  const note = typeof input.note === 'string' ? input.note.trim() : '';

  if (!CONDITIONS.has(condition)) {
    errors.condition = 'Gunakan good atau needs_action.';
  }
  if (typeof input.note !== 'string') {
    errors.note = 'Field wajib bertipe string.';
  } else if (note.length > 500) {
    errors.note = 'Maksimal 500 karakter.';
  } else if (condition === 'needs_action' && note.length < 10) {
    errors.note = 'Temuan membutuhkan catatan minimal 10 karakter.';
  }

  return {
    value: { assetCode, location, condition, note },
    errors,
  };
}

export function parseListQuery(query) {
  const errors = {};
  const page = Number.parseInt(query.page ?? '1', 10);
  const perPage = Number.parseInt(query.per_page ?? '50', 10);
  const q = typeof query.q === 'string' ? query.q.trim().toLowerCase() : '';
  const condition =
    typeof query.condition === 'string' ? query.condition.trim() : '';

  if (!Number.isInteger(page) || page < 1) {
    errors.page = 'Harus berupa integer minimal 1.';
  }
  if (!Number.isInteger(perPage) || perPage < 1 || perPage > 100) {
    errors.per_page = 'Harus berupa integer 1-100.';
  }
  if (condition && !CONDITIONS.has(condition)) {
    errors.condition = 'Gunakan good atau needs_action.';
  }

  return {
    value: { page, perPage, q, condition },
    errors,
  };
}

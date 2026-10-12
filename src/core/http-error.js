export class HttpError extends Error {
  constructor(status, message, { code, errors, headers } = {}) {
    super(message);
    this.name = 'HttpError';
    this.status = status;
    this.code = code;
    this.errors = errors;
    this.headers = headers;
  }
}

export const unauthorized = (message = 'Session tidak valid. Silakan login.') =>
  new HttpError(401, message, { code: 'UNAUTHORIZED' });

export const notFound = (message = 'Data tidak ditemukan.') =>
  new HttpError(404, message, { code: 'NOT_FOUND' });

export const conflict = (message) =>
  new HttpError(409, message, { code: 'CONFLICT' });

export const validationFailed = (errors) =>
  new HttpError(422, 'Validasi gagal.', {
    code: 'VALIDATION_ERROR',
    errors,
  });

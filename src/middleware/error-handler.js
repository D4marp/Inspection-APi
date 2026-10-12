import { HttpError } from '../core/http-error.js';

export function notFoundHandler(req, _res, next) {
  next(
    new HttpError(404, `Endpoint ${req.method} ${req.path} tidak ditemukan.`, {
      code: 'ENDPOINT_NOT_FOUND',
    }),
  );
}

export function errorHandler(error, req, res, _next) {
  if (error instanceof SyntaxError && error.status === 400 && 'body' in error) {
    return res.status(400).json({
      message: 'JSON request tidak valid.',
      code: 'INVALID_JSON',
      requestId: req.requestId,
    });
  }

  const known = error instanceof HttpError;
  const status = known ? error.status : 500;
  const payload = {
    message: known ? error.message : 'Terjadi kesalahan pada server.',
    code: known ? error.code : 'INTERNAL_SERVER_ERROR',
    requestId: req.requestId,
  };
  if (known && error.errors) payload.errors = error.errors;
  if (known && error.headers) {
    for (const [name, value] of Object.entries(error.headers)) {
      res.set(name, value);
    }
  }
  if (!known) {
    console.error(
      JSON.stringify({
        level: 'error',
        requestId: req.requestId,
        message: error.message,
        stack: process.env.NODE_ENV === 'production' ? undefined : error.stack,
      }),
    );
  }
  return res.status(status).json(payload);
}

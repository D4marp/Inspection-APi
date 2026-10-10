import { unauthorized } from '../core/http-error.js';

export function requireAuth(expectedToken) {
  return (req, _res, next) => {
    const header = req.get('Authorization') ?? '';
    const [scheme, token] = header.split(' ');
    if (scheme !== 'Bearer' || token !== expectedToken) {
      return next(unauthorized());
    }
    req.user = { id: 'u1', name: 'Trainer' };
    return next();
  };
}

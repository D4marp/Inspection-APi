import { Router } from 'express';
import { unauthorized } from '../core/http-error.js';
import { applyTrainingDelay } from '../middleware/training-faults.js';

export function createAuthRouter({ config }) {
  const router = Router();

  router.post('/login', async (req, res, next) => {
    try {
      await applyTrainingDelay(req, config);
      const { username, password } = req.body ?? {};
      if (username !== config.username || password !== config.password) {
        throw unauthorized('Username atau password salah.');
      }
      res.json({
        token: config.token,
        user: { id: 'u1', name: 'Trainer' },
      });
    } catch (error) {
      next(error);
    }
  });

  return router;
}

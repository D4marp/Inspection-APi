import { Router } from 'express';

export function createHealthRouter({ version }) {
  const router = Router();
  router.get('/', (_req, res) => {
    res.json({
      status: 'ok',
      service: 'dpl-inspection-training-api',
      version,
      timestamp: new Date().toISOString(),
    });
  });
  return router;
}

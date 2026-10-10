import { Router } from 'express';
import { validationFailed } from '../core/http-error.js';
import {
  normalizeCreateInspection,
  parseListQuery,
} from '../domain/inspection.js';
import {
  applyTrainingDelay,
  throwWhenFaultRequested,
} from '../middleware/training-faults.js';

export function createInspectionRouter({ config, store }) {
  const router = Router();

  router.get('/', async (req, res, next) => {
    try {
      await applyTrainingDelay(req, config);
      throwWhenFaultRequested(req, config, 'list');
      const parsed = parseListQuery(req.query);
      if (Object.keys(parsed.errors).length > 0) {
        throw validationFailed(parsed.errors);
      }
      res.json(store.list(parsed.value));
    } catch (error) {
      next(error);
    }
  });

  router.get('/:id', (req, res, next) => {
    try {
      res.json(store.getById(req.params.id));
    } catch (error) {
      next(error);
    }
  });

  router.post('/', async (req, res, next) => {
    try {
      await applyTrainingDelay(req, config);
      throwWhenFaultRequested(req, config, 'create');
      const parsed = normalizeCreateInspection(req.body);
      if (Object.keys(parsed.errors).length > 0) {
        throw validationFailed(parsed.errors);
      }
      const result = store.create(parsed.value, {
        idempotencyKey: req.get('Idempotency-Key'),
      });
      if (result.replayed) res.set('Idempotency-Replayed', 'true');
      res.status(201).json(result.record);
    } catch (error) {
      next(error);
    }
  });

  return router;
}

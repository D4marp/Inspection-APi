import { HttpError } from '../core/http-error.js';

const wait = (milliseconds) =>
  new Promise((resolve) => setTimeout(resolve, milliseconds));

const debugDelay = (req, config) => {
  if (!config.enableFaults) return 0;
  const raw = req.get('X-Debug-Delay-Ms');
  if (!raw) return 0;
  const parsed = Number.parseInt(raw, 10);
  return Number.isInteger(parsed) ? Math.min(Math.max(parsed, 0), 15000) : 0;
};

export async function applyTrainingDelay(req, config) {
  const delay = Math.max(config.responseDelayMs, debugDelay(req, config));
  if (delay > 0) await wait(delay);
}

export function throwWhenFaultRequested(req, config, operation) {
  const requested = config.enableFaults ? req.get('X-Debug-Fault') : undefined;
  const configuredFailure =
    (operation === 'list' && config.failList) ||
    (operation === 'create' && config.failCreate);
  if (configuredFailure || requested === `${operation}-500`) {
    throw new HttpError(500, `Simulasi ${operation} gagal.`, {
      code: 'TRAINING_FAULT',
    });
  }
}

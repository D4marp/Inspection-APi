import { randomUUID } from 'node:crypto';

const SAFE_REQUEST_ID = /^[A-Za-z0-9._:-]{1,100}$/;

export function requestContext(req, res, next) {
  const incoming = req.get('X-Request-Id');
  const requestId = incoming && SAFE_REQUEST_ID.test(incoming)
    ? incoming
    : randomUUID();
  const startedAt = process.hrtime.bigint();

  req.requestId = requestId;
  res.set('X-Request-Id', requestId);

  res.on('finish', () => {
    const elapsedMs = Number(process.hrtime.bigint() - startedAt) / 1_000_000;
    console.log(
      JSON.stringify({
        level: 'info',
        requestId,
        method: req.method,
        path: req.originalUrl.split('?')[0],
        status: res.statusCode,
        durationMs: Number(elapsedMs.toFixed(1)),
      }),
    );
  });
  next();
}

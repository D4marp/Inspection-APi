import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import request from 'supertest';
import { createApp } from '../src/app.js';
import { loadConfig } from '../src/config.js';

const token = 'training-demo-token';
const auth = { Authorization: `Bearer ${token}` };

const buildApp = (overrides = {}) => {
  const config = loadConfig({
    NODE_ENV: 'test',
    PORT: '3000',
    PUBLIC_BASE_URL: 'http://localhost:3000',
    TRAINING_USERNAME: 'trainer',
    TRAINING_PASSWORD: 'training123',
    TRAINING_TOKEN: token,
    ENABLE_FAULTS: 'true',
    ...overrides,
  });
  return createApp({ config });
};

describe('DPL Inspection Training API', () => {
  it('returns health and a request id', async () => {
    const response = await request(buildApp()).get('/health').expect(200);
    assert.equal(response.body.status, 'ok');
    assert.equal(response.body.version, '1.0.0');
    assert.ok(response.headers['x-request-id']);
  });

  it('logs in with dummy credentials', async () => {
    const response = await request(buildApp())
      .post('/auth/login')
      .send({ username: 'trainer', password: 'training123' })
      .expect(200);
    assert.equal(response.body.token, token);
    assert.deepEqual(response.body.user, { id: 'u1', name: 'Trainer' });
  });

  it('rejects invalid credentials and invalid bearer token', async () => {
    await request(buildApp())
      .post('/auth/login')
      .send({ username: 'trainer', password: 'wrong' })
      .expect(401);
    await request(buildApp())
      .get('/inspections')
      .set('Authorization', 'Bearer invalid')
      .expect(401);
  });

  it('lists, searches, filters, and paginates inspections', async () => {
    const app = buildApp();
    const page = await request(app)
      .get('/inspections?page=1&per_page=2')
      .set(auth)
      .expect(200);
    assert.equal(page.body.items.length, 2);
    assert.equal(page.body.total, 3);

    const filtered = await request(app)
      .get('/inspections?q=PMP-002&condition=needs_action')
      .set(auth)
      .expect(200);
    assert.equal(filtered.body.items.length, 1);
    assert.equal(filtered.body.items[0].id, '2');
  });

  it('returns field errors for an invalid create request', async () => {
    const response = await request(buildApp())
      .post('/inspections')
      .set(auth)
      .send({
        assetCode: 'PMP-099',
        location: 'Workshop B',
        condition: 'needs_action',
        note: 'pendek',
      })
      .expect(422);
    assert.equal(response.body.code, 'VALIDATION_ERROR');
    assert.match(response.body.errors.note, /minimal 10/);
  });

  it('creates a record and returns the detail', async () => {
    const app = buildApp();
    const created = await request(app)
      .post('/inspections')
      .set(auth)
      .send({
        assetCode: 'PMP-099',
        location: 'Workshop B',
        condition: 'good',
        note: '',
      })
      .expect(201);
    assert.equal(created.body.id, '4');

    const detail = await request(app)
      .get(`/inspections/${created.body.id}`)
      .set(auth)
      .expect(200);
    assert.equal(detail.body.assetCode, 'PMP-099');
  });

  it('replays the same idempotent request and rejects a changed payload', async () => {
    const app = buildApp();
    const input = {
      assetCode: 'PMP-200',
      location: 'Workshop B',
      condition: 'good',
      note: '',
    };
    const first = await request(app)
      .post('/inspections')
      .set(auth)
      .set('Idempotency-Key', 'training-request-1')
      .send(input)
      .expect(201);
    const replay = await request(app)
      .post('/inspections')
      .set(auth)
      .set('Idempotency-Key', 'training-request-1')
      .send(input)
      .expect(201);
    assert.equal(replay.body.id, first.body.id);
    assert.equal(replay.headers['idempotency-replayed'], 'true');

    await request(app)
      .post('/inspections')
      .set(auth)
      .set('Idempotency-Key', 'training-request-1')
      .send({ ...input, location: 'Workshop C' })
      .expect(409);
  });

  it('supports opt-in fault and delay simulation', async () => {
    const app = buildApp();
    await request(app)
      .get('/inspections')
      .set(auth)
      .set('X-Debug-Fault', 'list-500')
      .expect(500);
    const startedAt = Date.now();
    await request(app)
      .get('/inspections')
      .set(auth)
      .set('X-Debug-Delay-Ms', '30')
      .expect(200);
    assert.ok(Date.now() - startedAt >= 25);
  });

  it('serves an OpenAPI document matching the implemented routes', async () => {
    const response = await request(buildApp()).get('/openapi.json').expect(200);
    assert.equal(response.body.openapi, '3.1.0');
    assert.ok(response.body.paths['/auth/login']);
    assert.ok(response.body.paths['/inspections'].get);
    assert.ok(response.body.paths['/inspections'].post);
    assert.ok(response.body.paths['/inspections/{id}'].get);
  });

  it('returns structured 400 and 404 responses', async () => {
    const invalidJson = await request(buildApp())
      .post('/auth/login')
      .set('Content-Type', 'application/json')
      .send('{')
      .expect(400);
    assert.equal(invalidJson.body.code, 'INVALID_JSON');

    const missing = await request(buildApp()).get('/unknown').expect(404);
    assert.equal(missing.body.code, 'ENDPOINT_NOT_FOUND');
  });
});

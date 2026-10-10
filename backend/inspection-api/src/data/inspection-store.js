import { conflict, notFound } from '../core/http-error.js';

const seedRecords = () => [
  {
    id: '1',
    assetCode: 'PMP-001',
    location: 'Workshop A',
    condition: 'good',
    note: '',
    createdAt: '2026-10-03T01:01:00Z',
  },
  {
    id: '2',
    assetCode: 'PMP-002',
    location: 'Workshop A',
    condition: 'needs_action',
    note: 'Getaran motor perlu diperiksa',
    createdAt: '2026-10-03T01:02:00Z',
  },
  {
    id: '3',
    assetCode: 'PMP-003',
    location: 'Workshop A',
    condition: 'good',
    note: '',
    createdAt: '2026-10-03T01:03:00Z',
  },
];

export class InspectionStore {
  constructor({ empty = false, now = () => new Date() } = {}) {
    this.records = empty ? [] : seedRecords();
    this.nextId = this.records.length + 1;
    this.idempotency = new Map();
    this.now = now;
  }

  list({ page, perPage, q, condition }) {
    const selected = this.records.filter((record) => {
      const matchesCondition = !condition || record.condition === condition;
      const matchesText =
        !q ||
        record.assetCode.toLowerCase().includes(q) ||
        record.location.toLowerCase().includes(q);
      return matchesCondition && matchesText;
    });
    const start = (page - 1) * perPage;
    return {
      items: selected.slice(start, start + perPage).map((item) => ({ ...item })),
      page,
      per_page: perPage,
      total: selected.length,
    };
  }

  getById(id) {
    const record = this.records.find((item) => item.id === id);
    if (!record) throw notFound('Inspeksi tidak ditemukan.');
    return { ...record };
  }

  create(input, { idempotencyKey } = {}) {
    const signature = JSON.stringify(input);
    if (idempotencyKey) {
      const previous = this.idempotency.get(idempotencyKey);
      if (previous && previous.signature !== signature) {
        throw conflict('Idempotency-Key sudah dipakai untuk payload berbeda.');
      }
      if (previous) return { record: { ...previous.record }, replayed: true };
    }

    const record = {
      id: String(this.nextId++),
      ...input,
      createdAt: this.now().toISOString(),
    };
    this.records.unshift(record);
    if (idempotencyKey) {
      this.idempotency.set(idempotencyKey, { signature, record: { ...record } });
    }
    return { record: { ...record }, replayed: false };
  }
}

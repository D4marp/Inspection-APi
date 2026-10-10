const errorResponses = {
  401: {
    description: 'Session tidak valid.',
    content: {
      'application/json': { schema: { $ref: '#/components/schemas/Error' } },
    },
  },
  500: {
    description: 'Kesalahan server atau fault simulation.',
    content: {
      'application/json': { schema: { $ref: '#/components/schemas/Error' } },
    },
  },
};

export function createOpenApiSpec({ baseUrl }) {
  return {
    openapi: '3.1.0',
    info: {
      title: 'DPL Inspection Training API',
      version: '1.0.0',
      description:
        'API in-memory untuk latihan integrasi Flutter. Seluruh akun, token, dan data bersifat dummy.',
    },
    servers: [{ url: baseUrl, description: 'Training API' }],
    tags: [
      { name: 'System' },
      { name: 'Authentication' },
      { name: 'Inspections' },
    ],
    paths: {
      '/health': {
        get: {
          tags: ['System'],
          summary: 'Health check',
          operationId: 'getHealth',
          responses: {
            200: {
              description: 'Service sehat.',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Health' },
                },
              },
            },
          },
        },
      },
      '/auth/login': {
        post: {
          tags: ['Authentication'],
          summary: 'Login dummy untuk training',
          operationId: 'login',
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/LoginRequest' },
                example: { username: 'trainer', password: 'training123' },
              },
            },
          },
          responses: {
            200: {
              description: 'Login berhasil.',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/LoginResponse' },
                },
              },
            },
            401: errorResponses[401],
          },
        },
      },
      '/inspections': {
        get: {
          tags: ['Inspections'],
          summary: 'Daftar inspeksi',
          operationId: 'listInspections',
          security: [{ bearerAuth: [] }],
          parameters: [
            { $ref: '#/components/parameters/Page' },
            { $ref: '#/components/parameters/PerPage' },
            { $ref: '#/components/parameters/Search' },
            { $ref: '#/components/parameters/Condition' },
            { $ref: '#/components/parameters/DebugFault' },
            { $ref: '#/components/parameters/DebugDelay' },
          ],
          responses: {
            200: {
              description: 'Daftar inspeksi.',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/InspectionList' },
                },
              },
            },
            401: errorResponses[401],
            422: {
              description: 'Query tidak valid.',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/ValidationError' },
                },
              },
            },
            500: errorResponses[500],
          },
        },
        post: {
          tags: ['Inspections'],
          summary: 'Membuat inspeksi',
          operationId: 'createInspection',
          security: [{ bearerAuth: [] }],
          parameters: [
            { $ref: '#/components/parameters/IdempotencyKey' },
            { $ref: '#/components/parameters/DebugFault' },
            { $ref: '#/components/parameters/DebugDelay' },
          ],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/CreateInspection' },
                examples: {
                  good: {
                    value: {
                      assetCode: 'PMP-099',
                      location: 'Workshop B',
                      condition: 'good',
                      note: '',
                    },
                  },
                  needsAction: {
                    value: {
                      assetCode: 'PMP-100',
                      location: 'Workshop B',
                      condition: 'needs_action',
                      note: 'Motor bergetar tinggi',
                    },
                  },
                },
              },
            },
          },
          responses: {
            201: {
              description: 'Inspeksi dibuat atau hasil idempotent diputar ulang.',
              headers: {
                'Idempotency-Replayed': {
                  schema: { type: 'string', enum: ['true'] },
                },
              },
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Inspection' },
                },
              },
            },
            401: errorResponses[401],
            409: {
              description: 'Idempotency-Key dipakai dengan payload berbeda.',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Error' },
                },
              },
            },
            422: {
              description: 'Body tidak memenuhi validasi.',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/ValidationError' },
                },
              },
            },
            500: errorResponses[500],
          },
        },
      },
      '/inspections/{id}': {
        get: {
          tags: ['Inspections'],
          summary: 'Detail inspeksi',
          operationId: 'getInspection',
          security: [{ bearerAuth: [] }],
          parameters: [
            {
              name: 'id',
              in: 'path',
              required: true,
              schema: { type: 'string' },
            },
          ],
          responses: {
            200: {
              description: 'Detail inspeksi.',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Inspection' },
                },
              },
            },
            401: errorResponses[401],
            404: {
              description: 'Inspeksi tidak ditemukan.',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Error' },
                },
              },
            },
          },
        },
      },
    },
    components: {
      securitySchemes: {
        bearerAuth: { type: 'http', scheme: 'bearer' },
      },
      parameters: {
        Page: {
          name: 'page',
          in: 'query',
          schema: { type: 'integer', minimum: 1, default: 1 },
        },
        PerPage: {
          name: 'per_page',
          in: 'query',
          schema: { type: 'integer', minimum: 1, maximum: 100, default: 50 },
        },
        Search: {
          name: 'q',
          in: 'query',
          schema: { type: 'string' },
        },
        Condition: {
          name: 'condition',
          in: 'query',
          schema: { type: 'string', enum: ['good', 'needs_action'] },
        },
        IdempotencyKey: {
          name: 'Idempotency-Key',
          in: 'header',
          required: false,
          description: 'Gunakan nilai stabil untuk retry POST yang aman.',
          schema: { type: 'string', maxLength: 200 },
        },
        DebugFault: {
          name: 'X-Debug-Fault',
          in: 'header',
          required: false,
          description: 'Aktif hanya jika ENABLE_FAULTS=true.',
          schema: { type: 'string', enum: ['list-500', 'create-500'] },
        },
        DebugDelay: {
          name: 'X-Debug-Delay-Ms',
          in: 'header',
          required: false,
          description: 'Delay 0-15000 ms; aktif jika ENABLE_FAULTS=true.',
          schema: { type: 'integer', minimum: 0, maximum: 15000 },
        },
      },
      schemas: {
        Health: {
          type: 'object',
          required: ['status', 'service', 'version', 'timestamp'],
          properties: {
            status: { type: 'string', const: 'ok' },
            service: { type: 'string' },
            version: { type: 'string' },
            timestamp: { type: 'string', format: 'date-time' },
          },
        },
        LoginRequest: {
          type: 'object',
          required: ['username', 'password'],
          properties: {
            username: { type: 'string' },
            password: { type: 'string', format: 'password' },
          },
        },
        LoginResponse: {
          type: 'object',
          required: ['token', 'user'],
          properties: {
            token: { type: 'string' },
            user: {
              type: 'object',
              required: ['id', 'name'],
              properties: {
                id: { type: 'string' },
                name: { type: 'string' },
              },
            },
          },
        },
        Inspection: {
          type: 'object',
          required: [
            'id',
            'assetCode',
            'location',
            'condition',
            'note',
            'createdAt',
          ],
          properties: {
            id: { type: 'string' },
            assetCode: { type: 'string', maxLength: 30 },
            location: { type: 'string', maxLength: 80 },
            condition: {
              type: 'string',
              enum: ['good', 'needs_action'],
            },
            note: { type: 'string', maxLength: 500 },
            createdAt: { type: 'string', format: 'date-time' },
          },
        },
        CreateInspection: {
          type: 'object',
          additionalProperties: false,
          required: ['assetCode', 'location', 'condition', 'note'],
          properties: {
            assetCode: { type: 'string', minLength: 1, maxLength: 30 },
            location: { type: 'string', minLength: 1, maxLength: 80 },
            condition: {
              type: 'string',
              enum: ['good', 'needs_action'],
            },
            note: { type: 'string', maxLength: 500 },
          },
        },
        InspectionList: {
          type: 'object',
          required: ['items', 'page', 'per_page', 'total'],
          properties: {
            items: {
              type: 'array',
              items: { $ref: '#/components/schemas/Inspection' },
            },
            page: { type: 'integer' },
            per_page: { type: 'integer' },
            total: { type: 'integer' },
          },
        },
        Error: {
          type: 'object',
          required: ['message', 'code', 'requestId'],
          properties: {
            message: { type: 'string' },
            code: { type: 'string' },
            requestId: { type: 'string' },
          },
        },
        ValidationError: {
          allOf: [
            { $ref: '#/components/schemas/Error' },
            {
              type: 'object',
              required: ['errors'],
              properties: {
                errors: {
                  type: 'object',
                  additionalProperties: { type: 'string' },
                },
              },
            },
          ],
        },
      },
    },
  };
}

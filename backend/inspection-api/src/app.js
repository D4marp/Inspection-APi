import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import swaggerUi from 'swagger-ui-express';
import { loadConfig } from './config.js';
import { InspectionStore } from './data/inspection-store.js';
import { createOpenApiSpec } from './docs/openapi.js';
import { requireAuth } from './middleware/auth.js';
import { errorHandler, notFoundHandler } from './middleware/error-handler.js';
import { requestContext } from './middleware/request-context.js';
import { createAuthRouter } from './routes/auth.routes.js';
import { createHealthRouter } from './routes/health.routes.js';
import { createInspectionRouter } from './routes/inspection.routes.js';

const API_VERSION = '1.0.0';

export function createApp(options = {}) {
  const config = options.config ?? loadConfig();
  const store = options.store ?? new InspectionStore({ empty: config.emptyData });
  const openApi = createOpenApiSpec({ baseUrl: config.publicBaseUrl });
  const app = express();

  app.disable('x-powered-by');
  app.use(
    helmet({
      // Swagger UI memakai inline script/style; endpoint API tetap mendapat
      // header Helmet lainnya. Untuk production, pasang CSP khusus /docs.
      contentSecurityPolicy: false,
    }),
  );
  app.use(
    cors({
      origin: config.corsOrigin === '*' ? true : config.corsOrigin.split(','),
    }),
  );
  app.use(requestContext);
  app.use(express.json({ limit: '64kb' }));

  app.use(
    '/docs',
    swaggerUi.serve,
    swaggerUi.setup(openApi, {
      customSiteTitle: 'DPL Inspection API',
      swaggerOptions: { persistAuthorization: true },
    }),
  );
  app.get('/openapi.json', (_req, res) => res.json(openApi));
  app.use('/health', createHealthRouter({ version: API_VERSION }));
  app.use('/auth', createAuthRouter({ config }));
  app.use(
    '/inspections',
    requireAuth(config.token),
    createInspectionRouter({ config, store }),
  );

  app.use(notFoundHandler);
  app.use(errorHandler);
  return app;
}

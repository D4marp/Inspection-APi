import { createApp } from './app.js';
import { loadConfig } from './config.js';

const config = loadConfig();
const app = createApp({ config });
const server = app.listen(config.port, config.host, () => {
  console.log(
    `DPL Inspection API listening on http://${config.host}:${config.port}`,
  );
  console.log(`Swagger UI: ${config.publicBaseUrl}/docs`);
});

const shutdown = (signal) => {
  console.log(`${signal} received; closing HTTP server.`);
  server.close((error) => {
    if (error) {
      console.error(error);
      process.exitCode = 1;
    }
  });
};

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));

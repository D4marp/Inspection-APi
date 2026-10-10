const parseBoolean = (value, fallback = false) => {
  if (value === undefined) return fallback;
  return ['1', 'true', 'yes', 'on'].includes(String(value).toLowerCase());
};

const parseInteger = (value, fallback, { min, max, name }) => {
  const parsed = value === undefined ? fallback : Number.parseInt(value, 10);
  if (!Number.isInteger(parsed) || parsed < min || parsed > max) {
    throw new Error(`${name} harus berupa integer ${min}-${max}.`);
  }
  return parsed;
};

const normalizeBaseUrl = (value) => {
  const url = new URL(value);
  if (!['http:', 'https:'].includes(url.protocol)) {
    throw new Error('PUBLIC_BASE_URL harus menggunakan http atau https.');
  }
  return url.toString().replace(/\/$/, '');
};

export function loadConfig(env = process.env) {
  const config = {
    nodeEnv: env.NODE_ENV ?? 'development',
    host: env.HOST ?? '0.0.0.0',
    port: parseInteger(env.PORT, 3000, {
      min: 1,
      max: 65535,
      name: 'PORT',
    }),
    publicBaseUrl: normalizeBaseUrl(
      env.PUBLIC_BASE_URL ?? `http://localhost:${env.PORT ?? 3000}`,
    ),
    corsOrigin: env.CORS_ORIGIN ?? '*',
    username: env.TRAINING_USERNAME ?? 'trainer',
    password: env.TRAINING_PASSWORD ?? 'training123',
    token: env.TRAINING_TOKEN ?? 'training-demo-token',
    enableFaults: parseBoolean(env.ENABLE_FAULTS, false),
    responseDelayMs: parseInteger(env.RESPONSE_DELAY_MS, 0, {
      min: 0,
      max: 30000,
      name: 'RESPONSE_DELAY_MS',
    }),
    failList: parseBoolean(env.FAIL_LIST, false),
    failCreate: parseBoolean(env.FAIL_CREATE, false),
    emptyData: parseBoolean(env.EMPTY_DATA, false),
  };

  for (const [name, value] of [
    ['TRAINING_USERNAME', config.username],
    ['TRAINING_PASSWORD', config.password],
    ['TRAINING_TOKEN', config.token],
  ]) {
    if (!value) throw new Error(`${name} tidak boleh kosong.`);
  }

  return Object.freeze(config);
}

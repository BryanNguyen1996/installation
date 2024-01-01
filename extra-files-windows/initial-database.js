const exec = require('child_process').execFileSync;
const { join } = require('path');
const fs = require('fs');

const args = process.argv.slice(2);
const [tempDir] = args;
const envTempDir = join(tempDir, '.env');
const mysqlDir = join(tempDir, 'mariadb.exe');

function parseEnvFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const lines = content.split('\n');

  const envVariables = {};
  lines.forEach((line) => {
    const [key, value] = line.split('=');
    if (key && value) {
      envVariables[key.trim()] = value.trim();
    }
  });

  return envVariables;
}

const initDatabase = async function () {
  const { host, port, username, password, database } = parseEnvFile(envTempDir);

  try {
    await exec(mysqlDir, [
      '-u',
      username,
      `-p${password}`,
      '-h',
      host - 'P',
      port,
      '-e',
      `SET global time_zone = '+00:00';`,
    ]);
  } catch {}
  await exec(mysqlDir, [
    '-u',
    username,
    `-p${password}`,
    '-e',
    `CREATE DATABASE ${database} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;`,
  ]);
};

initDatabase();

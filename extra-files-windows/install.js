const Service = require('node-windows').Service;
const { join } = require('path');

function capitalizeFLetter(string) {
  return string[0].toUpperCase() + string.slice(1);
}

function normalizeName(string) {
  return string
    .split('-')
    .map((e) => capitalizeFLetter(e))
    .join('');
}

const isUninstall = process.argv[2] === '--uninstall';

const services = [
  'backend'
];

for (const serviceName of services) {
  const nameService = normalizeName(serviceName);

  // Create a new service object
  const svc = new Service({
    name: nameService,
    description: 'The nodejs.org service.',
    maxRetries: 10,
    wait: 2,
    grow: 0.5,
    script: join(__dirname, serviceName, 'dist', 'index.js'),
    execPath: join(__dirname, 'node.exe'),
  });

  if (!isUninstall) {
    // process is available as a service.
    svc.on('install', function () {
      svc.start();
    });

    svc.install();
  } else {
    // Listen for the "uninstall" event so we know when it's done.
    svc.on('uninstall', function () {
      console.log('Uninstall complete.');
      console.log('The service exists: ', svc.exists);
    });

    // Uninstall the service.
    svc.uninstall();
  }
}

// Genera public/version.json antes del build
const { execSync } = require('child_process');
const { writeFileSync } = require('fs');

let v;
try {
  v = execSync('git rev-parse --short HEAD').toString().trim();
} catch {
  v = (process.env.VERCEL_GIT_COMMIT_SHA || Date.now().toString(36)).slice(0, 7);
}

writeFileSync('public/version.json', JSON.stringify({ v }));
console.log(`[gen-version] version = ${v}`);

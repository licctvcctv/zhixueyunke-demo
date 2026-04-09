#!/usr/bin/env node
/**
 * 智学云课 - 一键启动脚本
 *
 * 功能：
 * 1. 自动检查并安装 server 和 admin 的依赖
 * 2. 初始化数据库（如果不存在）
 * 3. 启动后端 API 服务 (端口 3000)
 * 4. 启动管理后台开发服务 (端口 5173)
 *
 * 使用方法：node start.js
 */

const { execSync, spawn } = require('child_process');
const { existsSync } = require('fs');
const { join } = require('path');

const ROOT = __dirname;
const SERVER_DIR = join(ROOT, 'server');
const ADMIN_DIR = join(ROOT, 'admin');

// 颜色输出
const log = {
  info: (msg) => console.log(`\x1b[36m[信息]\x1b[0m ${msg}`),
  ok: (msg) => console.log(`\x1b[32m[完成]\x1b[0m ${msg}`),
  warn: (msg) => console.log(`\x1b[33m[警告]\x1b[0m ${msg}`),
  err: (msg) => console.log(`\x1b[31m[错误]\x1b[0m ${msg}`),
  step: (msg) => console.log(`\n\x1b[1m>>> ${msg}\x1b[0m`),
};

function run(cmd, cwd) {
  try {
    execSync(cmd, { cwd, stdio: 'inherit' });
    return true;
  } catch {
    return false;
  }
}

function checkNode() {
  try {
    const v = execSync('node -v', { encoding: 'utf8' }).trim();
    const major = parseInt(v.replace('v', ''));
    if (major < 16) {
      log.err(`Node.js 版本过低 (${v})，需要 v16+`);
      process.exit(1);
    }
    log.ok(`Node.js ${v}`);
  } catch {
    log.err('未安装 Node.js，请先安装: https://nodejs.org/');
    process.exit(1);
  }
}

function installDeps(name, dir) {
  const nodeModules = join(dir, 'node_modules');
  if (existsSync(nodeModules)) {
    log.ok(`${name} 依赖已存在`);
    return;
  }
  log.info(`正在安装 ${name} 依赖...`);
  if (!run('npm install', dir)) {
    log.err(`${name} 依赖安装失败`);
    process.exit(1);
  }
  log.ok(`${name} 依赖安装完成`);
}

function seedDatabase() {
  const dbFile = join(SERVER_DIR, 'data.db');
  if (existsSync(dbFile)) {
    log.ok('数据库已存在，跳过初始化');
    return;
  }
  log.info('正在初始化数据库...');
  if (!run('npx ts-node src/seed.ts', SERVER_DIR)) {
    log.warn('数据库初始化失败，服务启动后会自动创建空表');
  } else {
    log.ok('数据库初始化完成');
    console.log('  管理员: admin@demo.com / admin123');
    console.log('  学生:   zhangsan@demo.com / 123456');
  }
}

function startService(name, cmd, args, cwd, readyMsg) {
  return new Promise((resolve) => {
    log.info(`正在启动 ${name}...`);
    const child = spawn(cmd, args, {
      cwd,
      stdio: ['ignore', 'pipe', 'pipe'],
      shell: true,
    });

    let resolved = false;
    const onData = (data) => {
      const text = data.toString();
      process.stdout.write(`  [${name}] ${text}`);
      if (!resolved && text.includes(readyMsg)) {
        resolved = true;
        resolve(child);
      }
    };

    child.stdout.on('data', onData);
    child.stderr.on('data', onData);
    child.on('error', (err) => {
      log.err(`${name} 启动失败: ${err.message}`);
    });
    child.on('exit', (code) => {
      if (!resolved) {
        log.err(`${name} 异常退出 (code: ${code})`);
        resolve(null);
      }
    });

    // 超时 30 秒
    setTimeout(() => {
      if (!resolved) {
        resolved = true;
        log.warn(`${name} 启动超时，可能仍在初始化...`);
        resolve(child);
      }
    }, 30000);
  });
}

async function main() {
  console.log('\n\x1b[1;36m╔══════════════════════════════════════╗');
  console.log('║     智学云课 - 一键启动脚本         ║');
  console.log('╚══════════════════════════════════════╝\x1b[0m\n');

  // 1. 检查环境
  log.step('检查环境');
  checkNode();

  // 2. 安装依赖
  log.step('检查依赖');
  installDeps('后端服务', SERVER_DIR);
  installDeps('管理后台', ADMIN_DIR);

  // 3. 初始化数据库
  log.step('检查数据库');
  seedDatabase();

  // 4. 启动服务
  log.step('启动服务');

  const serverChild = await startService(
    '后端API',
    'npx', ['ts-node', 'src/main.ts'],
    SERVER_DIR,
    'Nest application successfully started'
  );

  const adminChild = await startService(
    '管理后台',
    'npx', ['vite', '--host'],
    ADMIN_DIR,
    'Local:'
  );

  // 获取本机IP
  let localIP = 'localhost';
  try {
    const os = require('os');
    const nets = os.networkInterfaces();
    for (const name of Object.keys(nets)) {
      for (const net of nets[name]) {
        if (net.family === 'IPv4' && !net.internal) {
          localIP = net.address;
          break;
        }
      }
    }
  } catch {}

  console.log('\n\x1b[1;32m╔══════════════════════════════════════════════╗');
  console.log('║              全部启动完成！                   ║');
  console.log('╠══════════════════════════════════════════════╣');
  console.log(`║  后端 API:   http://${localIP}:3000          `);
  console.log(`║  管理后台:   http://localhost:8080           `);
  console.log('║                                              ║');
  console.log('║  测试账号:                                   ║');
  console.log('║    管理员: admin@demo.com / admin123         ║');
  console.log('║    学生:   zhangsan@demo.com / 123456        ║');
  console.log('║                                              ║');
  console.log('║  按 Ctrl+C 停止所有服务                      ║');
  console.log('╚══════════════════════════════════════════════╝\x1b[0m\n');

  // 优雅退出
  const cleanup = () => {
    console.log('\n正在停止服务...');
    if (serverChild) serverChild.kill();
    if (adminChild) adminChild.kill();
    process.exit(0);
  };

  process.on('SIGINT', cleanup);
  process.on('SIGTERM', cleanup);
}

main().catch((err) => {
  log.err(`启动失败: ${err.message}`);
  process.exit(1);
});

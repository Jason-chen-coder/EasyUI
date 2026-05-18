#!/usr/bin/env node

import { cp, mkdir, rm, stat } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import os from 'node:os';

const skillName = 'easy-ui-view-builder';

function printHelp() {
  console.log(`Easy UI Skill installer

Usage:
  npx --yes github:Jason-chen-coder/EasyUI
  npx easy-ui-skill@latest
  easy-ui-skill install [--target all|codex|claude|claude-project]

Options:
  --target <name>            Install target. Defaults to all.
                             all installs Codex and personal Claude Code skills.
  --skills-dir <path>        Override the skills directory for one target.
  --codex-skills-dir <path>  Override the Codex skills directory.
  --claude-skills-dir <path> Override the Claude Code skills directory.
  --dry-run                  Print the install plan without copying files.
  -h, --help                 Show this help.
`);
}

function parseArgs(argv) {
  const options = {
    target: 'all',
    dryRun: false,
    skillsDir: null,
    codexSkillsDir: null,
    claudeSkillsDir: null,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === 'install') {
      continue;
    }
    if (arg === '--dry-run') {
      options.dryRun = true;
      continue;
    }
    if (arg === '--target') {
      const value = argv[index + 1];
      if (!value) {
        throw new Error('--target requires a value');
      }
      options.target = value;
      index += 1;
      continue;
    }
    if (arg === '--skills-dir') {
      const value = argv[index + 1];
      if (!value) {
        throw new Error('--skills-dir requires a path');
      }
      options.skillsDir = value;
      index += 1;
      continue;
    }
    if (arg === '--codex-skills-dir') {
      const value = argv[index + 1];
      if (!value) {
        throw new Error('--codex-skills-dir requires a path');
      }
      options.codexSkillsDir = value;
      index += 1;
      continue;
    }
    if (arg === '--claude-skills-dir') {
      const value = argv[index + 1];
      if (!value) {
        throw new Error('--claude-skills-dir requires a path');
      }
      options.claudeSkillsDir = value;
      index += 1;
      continue;
    }
    if (arg === '-h' || arg === '--help') {
      options.help = true;
      continue;
    }

    throw new Error(`Unknown argument: ${arg}`);
  }

  return options;
}

async function pathExists(path) {
  try {
    await stat(path);
    return true;
  } catch {
    return false;
  }
}

function resolveTargets(target) {
  if (target === 'all') {
    return ['codex', 'claude'];
  }
  if (target === 'codex' || target === 'claude' || target === 'claude-project') {
    return [target];
  }
  throw new Error(
    '--target must be one of: all, codex, claude, claude-project',
  );
}

function targetDestination(target, options) {
  if (target === 'codex') {
    const codexHome =
      process.env.CODEX_HOME && process.env.CODEX_HOME.trim().length > 0
        ? resolve(process.env.CODEX_HOME)
        : resolve(os.homedir(), '.codex');
    const skillsDir = options.codexSkillsDir
      ? resolve(options.codexSkillsDir)
      : options.skillsDir
        ? resolve(options.skillsDir)
        : resolve(codexHome, 'skills');
    return {
      label: 'Codex',
      skillsDir,
      destination: resolve(skillsDir, skillName),
    };
  }

  if (target === 'claude') {
    const skillsDir = options.claudeSkillsDir
      ? resolve(options.claudeSkillsDir)
      : options.skillsDir
        ? resolve(options.skillsDir)
        : resolve(os.homedir(), '.claude', 'skills');
    return {
      label: 'Claude Code',
      skillsDir,
      destination: resolve(skillsDir, skillName),
    };
  }

  const skillsDir = options.claudeSkillsDir
    ? resolve(options.claudeSkillsDir)
    : options.skillsDir
      ? resolve(options.skillsDir)
      : resolve(process.cwd(), '.claude', 'skills');
  return {
    label: 'Claude Code project',
    skillsDir,
    destination: resolve(skillsDir, skillName),
  };
}

async function main() {
  const options = parseArgs(process.argv.slice(2));
  if (options.help) {
    printHelp();
    return;
  }

  const packageRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');
  const source = resolve(packageRoot, 'skills', skillName);
  if (!(await pathExists(source))) {
    throw new Error(`Cannot find bundled skill at ${source}`);
  }

  const targets = resolveTargets(options.target);
  if (options.skillsDir && targets.length > 1) {
    throw new Error(
      '--skills-dir can only be used with one target. Use --codex-skills-dir and --claude-skills-dir for --target all.',
    );
  }
  const destinations = targets.map((target) => targetDestination(target, options));

  if (options.dryRun) {
    console.log(`From: ${source}`);
    for (const destination of destinations) {
      console.log(`Would install ${destination.label}: ${destination.destination}`);
    }
    return;
  }

  for (const destination of destinations) {
    await mkdir(destination.skillsDir, { recursive: true });
    await rm(destination.destination, { recursive: true, force: true });
    await cp(source, destination.destination, { recursive: true });
    console.log(`Installed ${skillName} for ${destination.label}`);
    console.log(`To: ${destination.destination}`);
  }

  console.log('Restart Codex or Claude Code to load the new skill.');
  console.log(
    'Try: $easy-ui-view-builder 帮我用 Easy UI 做一个带筛选、表格、分页和详情抽屉的订单管理页面',
  );
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});

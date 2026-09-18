#!/usr/bin/env python3
"""Fail-closed certificate gate for the first-party Bend sandbox."""
from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
PUBLIC_LAWS = frozenset({
    'heat_closed', 'geom_sum', 'heat_step_increment',
    'cool_contracts_deficit', 'cheb_two_of_recurrence',
    'heat_capped_lane_below_one', 'convex_avg_le_max', 'markov_finset',
    'heat_fixture_four', 'heat_crossing_fixture', 'chi_tv_transfer_rat',
})
IMPORT = re.compile(r'import (\./[A-Za-z0-9_./-]+\.bend) as ([A-Za-z][A-Za-z0-9_]*)')
TOKENS = re.compile(r'"(?:\\.|[^"\\])*"|#[^\n]*')

class VerificationError(RuntimeError):
    pass

def source_without_comments(text: str) -> str:
    return TOKENS.sub(lambda m: ' ' if m[0].startswith('#') else m[0], text)

def inspect_sources(entry: Path, root: Path = ROOT) -> dict[Path, str]:
    """Inspect the complete local import closure, including unused declarations."""
    root = root.resolve()
    pending = [entry]
    found = {}
    while pending:
        path = pending.pop().resolve()
        if not path.is_relative_to(root) or path.suffix != '.bend':
            raise VerificationError(f'Import escapes the certificate root: {path}')
        if path in found:
            continue
        try:
            code = source_without_comments(path.read_text())
        except OSError as exc:
            raise VerificationError(f'Cannot read {path}: {exc}') from exc
        tokens = TOKENS.sub(' ', code)
        if re.search(r'@\s*unsafe\b|\?|\b(?:F32|IO)\b', tokens):
            raise VerificationError(f'Unsafe, open, floating-point, or effectful certificate: {path}')
        if re.search(r'^\s*def\s+(?:[\w.]+\.)?main\s*\(', tokens, re.M):
            raise VerificationError(f'Proof roots must not execute main: {path}')
        found[path] = code
        for line in code.splitlines():
            statement = line.strip()
            if not statement.startswith('import'):
                continue
            if statement == 'import Base':
                continue
            match = IMPORT.fullmatch(statement)
            if not match:
                raise VerificationError(f'Only local Bend imports and pinned Base are allowed: {path}: {statement}')
            pending.append(path.parent / match[1])
    return found

def run_checker(entry: Path, executable: str = 'bend') -> None:
    try:
        result = subprocess.run([executable, str(entry)], capture_output=True, text=True, timeout=120)
    except (OSError, subprocess.TimeoutExpired) as exc:
        raise VerificationError(f'Cannot run Bend: {exc}') from exc
    # Bend 2.0.5 exits zero for @unsafe code. Exit status alone is NOT a certificate.
    if result.returncode != 0 or result.stdout.strip() != 'All terms check.' or result.stderr.strip():
        output = (result.stdout + result.stderr).strip()
        raise VerificationError(f'Bend did not issue a clean certificate (exit {result.returncode}):\n{output}')

def verify(root: Path = ROOT, executable: str = 'bend') -> tuple[int, int]:
    root = root.resolve()
    expected = (root / 'bend-version').read_text().strip()
    try:
        version = subprocess.run([executable, '--version'], capture_output=True, text=True, timeout=15)
    except (OSError, subprocess.TimeoutExpired) as exc:
        raise VerificationError(f'Install Bend {expected}: {exc}') from exc
    if version.returncode or version.stdout.strip() != f'bend {expected}' or version.stderr.strip():
        raise VerificationError(f'Expected Bend {expected}; observed {version.stdout.strip()!r}')
    sources = inspect_sources(root / 'PROOF.bend', root)
    laws = sources.get(root / 'LAWS.bend', '')
    declared = re.findall(r'^law ([A-Za-z0-9_]+):', laws, re.M)
    definitions = re.findall(r'^def Laws\.([A-Za-z0-9_]+)\(', sources[root / 'PROOF.bend'], re.M)
    if set(declared) != PUBLIC_LAWS or len(declared) != len(PUBLIC_LAWS):
        raise VerificationError('Public law inventory changed; review the mathematical contract and update the gate explicitly.')
    if set(definitions) != PUBLIC_LAWS or len(definitions) != len(PUBLIC_LAWS):
        raise VerificationError('Every public law must have exactly one paired proof in PROOF.bend.')
    production = set((root / 'Exact').glob('*.bend')) | set(root.glob('*.bend'))
    if production - sources.keys():
        missing = ', '.join(str(p.relative_to(root)) for p in sorted(production - sources.keys()))
        raise VerificationError(f'Production modules outside the certificate closure: {missing}')
    run_checker(root / 'PROOF.bend', executable)
    return len(declared), len(sources)

def main() -> int:
    try:
        laws, modules = verify()
    except (VerificationError, OSError) as exc:
        print(f'FAIL: {exc}', file=sys.stderr)
        return 1
    print(f'Verified {laws} public laws across {modules} Bend modules. No open or unsafe certificates.')
    return 0

if __name__ == '__main__':
    raise SystemExit(main())

"""Behavioral and rejection tests. Uses only Python's standard library."""
from __future__ import annotations

import hashlib
import random
import shutil
import subprocess
import sys
import tempfile
import unittest
from fractions import Fraction
from pathlib import Path
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import check


def positive(n: int) -> str:
    assert n > 0
    if n == 1:
        return 'B.One{}'
    return f'B.Bit{n % 2}' + '{' + positive(n // 2) + '}'


def whole(n: int) -> str:
    assert n >= 0
    return 'B.Zero{}' if n == 0 else 'B.Pos{' + positive(n) + '}'


def rational(value: Fraction) -> str:
    p, n = max(value.numerator, 0), max(-value.numerator, 0)
    return f'Q.Fraction{{{whole(p)}, {whole(n)}, {positive(value.denominator)}}}'


class ProofGate(unittest.TestCase):
    def test_public_certificates(self):
        laws, modules = check.verify()
        self.assertEqual(laws, 11)
        self.assertGreater(modules, 20)

    def test_finite_certificate_examples(self):
        check.run_checker(ROOT / "tests" / "certificates.bend")

    def test_rejects_bad_proofs(self):
        cases = {
            'false': 'law bad:\n  {0n == 1n : Nat}\ndef bad():\n  {==}\n',
            'hole': 'law bad:\n  {0n == 1n : Nat}\ndef bad():\n  ?TODO\n',
            'open': 'law bad:\n  {0n == 1n : Nat}\n',
            'recursive': 'def loop() -> Empty:\n  loop()\n',
            'unsafe': '@unsafe def loop() -> Empty:\n  loop()\n',
        }
        with tempfile.TemporaryDirectory() as tmp:
            for name, body in cases.items():
                with self.subTest(name=name):
                    path = Path(tmp) / f'{name}.bend'
                    path.write_text('import Base\n' + body)
                    with self.assertRaises(check.VerificationError):
                        check.run_checker(path)
            result = subprocess.run(['bend', str(Path(tmp) / 'unsafe.bend')], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, 'Exercise the warning-with-success-exit regression.')
            self.assertIn('unsafe', result.stdout)

    def test_large_reflected_equality_and_invalid_rationals(self):
        a = Fraction(2**80 + 7, 31)
        lhs = f'Q.add({rational(a)}, {rational(a)})'
        rhs = rational(2*a)
        prelude = ('import Base\nimport ../Exact/Binary.bend as B\n'
                   'import ../Exact/Rational.bend as Q\nimport ../Exact/Decision.bend as D\n')
        with tempfile.TemporaryDirectory(prefix='.runtime-', dir=ROOT) as tmp:
            source = Path(tmp) / 'proof.bend'
            source.write_text(prelude + f'def large() -> Q.Eq({lhs}, {rhs}):\n  D.eq({lhs}, {rhs}, {{==}})\n')
            check.run_checker(source)
            for body in [
                'def bad() -> Q.Number:\n  Q.Fraction{B.Zero{}, B.Zero{}, B.Zero{}}\n',
                'def bad() -> Q.Eq(Q.zero(), Q.one()):\n  D.eq(Q.zero(), Q.one(), {==})\n',
            ]:
                with self.subTest(body=body):
                    source.write_text(prelude + body)
                    with self.assertRaises(check.VerificationError):
                        check.run_checker(source)

    def test_inventory_and_unreferenced_modules(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / 'bend'
            shutil.copytree(ROOT, root, ignore=shutil.ignore_patterns('__pycache__', '.runtime-*'))
            laws = root / 'LAWS.bend'
            original = laws.read_text()
            laws.write_text(original.replace('law heat_closed:', 'law weakened_name:'))
            with self.assertRaisesRegex(check.VerificationError, 'inventory changed'):
                check.verify(root)
            laws.write_text(original)
            (root / 'Unverified.bend').write_text('import Base\nlaw open_claim:\n  Empty\n')
            with self.assertRaisesRegex(check.VerificationError, 'outside the certificate closure'):
                check.verify(root)

    def test_source_policy_and_import_closure(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            entry = root / 'PROOF.bend'
            bad = ['@unsafe def bad() -> Unit:\n  Unit{}', 'def bad() -> Unit:\n  ?TODO',
                   'def bad() -> F32:\n  0.0', 'def main() -> Unit:\n  Unit{}',
                   'import 0x123/main.bend as Remote', 'import "./host.js"',
                   'import ./../outside.bend as Outside']
            for body in bad:
                with self.subTest(body=body):
                    entry.write_text('import ./helper.bend as H\n')
                    (root / 'helper.bend').write_text(body + '\n')
                    with self.assertRaises(check.VerificationError):
                        check.inspect_sources(entry, root)
            entry.write_text('import Base # allowed\n# @unsafe ?TODO F32\ndef label() -> String:\n  "# ?TODO @unsafe"\n')
            self.assertEqual(len(check.inspect_sources(entry, root)), 1)

    def test_gate_rejects_warning_noise_and_wrong_version(self):
        for output in ['All terms check.\n1 term annotated as unsafe.\n', '', 'All terms check.\nextra\n']:
            with self.subTest(output=output), patch('check.subprocess.run', return_value=subprocess.CompletedProcess([], 0, output, '')):
                with self.assertRaises(check.VerificationError):
                    check.run_checker(ROOT / 'PROOF.bend')
        with patch('check.subprocess.run', return_value=subprocess.CompletedProcess([], 0, 'bend 0.0.0\n', '')):
            with self.assertRaises(check.VerificationError):
                check.verify()

    def test_generator_reproducibility_and_false_identity(self):
        with tempfile.TemporaryDirectory() as tmp:
            copy = Path(tmp) / 'bend'
            shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('__pycache__', '.runtime-*'))
            before = {p.name: hashlib.sha256(p.read_bytes()).digest() for p in (copy / 'Exact').glob('*.bend')}
            for script in sorted((copy / 'tools').glob('build_*_proofs.py')):
                subprocess.run([sys.executable, str(script)], check=True, capture_output=True, text=True, timeout=60)
            after = {p.name: hashlib.sha256(p.read_bytes()).digest() for p in (copy / 'Exact').glob('*.bend')}
            self.assertEqual(before, after)
        sys.path.insert(0, str(ROOT / 'tools'))
        import ring
        import semiring
        with self.assertRaises(ValueError):
            ring.Generator().prove(ring.atom('a') + ring.atom('b'), ring.atom('a') * ring.atom('b'))
        with self.assertRaises(ValueError):
            semiring.proof(semiring.atom('a') + semiring.ONE, semiring.atom('a'))


class ExactRuntime(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory(prefix='.runtime-', dir=ROOT)
        cls.directory = Path(cls.tmp.name)
        cls.source = cls.directory / 'probe.bend'
        rng = random.Random(42)
        expressions = []
        expected = []
        def add(expr, value):
            expressions.append(expr)
            expected.append(value)
        samples = [Fraction(0), Fraction(-3, 2), Fraction(2**80 + 123, 2**63 + 1), Fraction(-(2**65 + 7), 31)]
        samples += [Fraction(rng.randint(-100, 100), rng.randint(1, 30)) for _ in range(8)]
        for i, a in enumerate(samples):
            b = samples[(i + 1) % len(samples)]
            for op, value in [('add', a+b), ('sub', a-b), ('mul', a*b)]:
                add(f'Q.{op}({rational(a)}, {rational(b)})', value)
            add(f'Q.neg({rational(a)})', -a)
        for n, s, rho in [(0,Fraction(-3,2),Fraction(7,3)), (4,Fraction(1),Fraction(1,2)),
                          (25,Fraction(1),Fraction(1,2)), (80,Fraction(1),Fraction(1,2)),
                          (5,Fraction(-7,3),Fraction(-2,3)), (3,Fraction(2),Fraction(3,2))]:
            add(f'F.heat({n}n, {rational(s)}, {rational(rho)})', s*(1-rho**n))
        for a in [Fraction(-7,3),Fraction(0),Fraction(5,4)]:
            add(f'Q.of_nonnegative(M.magnitude({rational(a)}))', abs(a))
        div = 'Q.Positive{' + positive(3) + ', ' + positive(5) + '}'
        add(f'Q.div_positive({rational(Fraction(-7,4))}, {div})', Fraction(-35,12))
        cls.expected = expected
        cls.source.write_text('''import Base
import ../Exact/Binary.bend as B
import ../Exact/Rational.bend as Q
import ../Exact/Magnitude.bend as M
import ../Frontier.bend as F

def show(a: Q.Number) -> String:
  match a:
    case Q.Fraction{p, n, d}:
      B.show(p) ++ ":" ++ B.show(n) ++ ":" ++ B.positive_show(d)

def main() -> IO(Unit):
  do IO<Unit>:
''' + ''.join(f'    IO.print(show({expr}))\n' for expr in expressions))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def assert_values(self, output):
        rows = output.strip().splitlines()
        self.assertEqual(len(rows), len(self.expected), output[:1000])
        actual = []
        for line in rows:
            p,n,d = (int(x,2) for x in line.split(':'))
            self.assertGreater(d,0)
            actual.append(Fraction(p-n,d))
        self.assertEqual(actual, self.expected)
        # The strict bound survives far beyond F32's failure at n=25.
        self.assertLess(actual[51], 1)

    def test_javascript_exact_arithmetic(self):
        result = subprocess.run(['bend', str(self.source)], capture_output=True, text=True, timeout=120)
        self.assertEqual(result.returncode,0,result.stdout+result.stderr)
        self.assert_values(result.stdout)

    @unittest.skipUnless(shutil.which('clang'), 'clang is required for the native backend')
    def test_native_exact_arithmetic(self):
        binary = self.directory / 'probe'
        build = subprocess.run(['bend', str(self.source), '-o', str(binary)], capture_output=True, text=True, timeout=120)
        diagnostic = build.stdout + build.stderr
        if build.returncode and "bend needs clang 14 or newer" in diagnostic and "found no clang" in diagnostic:
            self.skipTest("Bend cannot find a working clang 14+; native behavior is unverified.")
        self.assertEqual(build.returncode,0,build.stdout+build.stderr)
        result = subprocess.run([str(binary)], capture_output=True, text=True, timeout=30)
        self.assertEqual(result.returncode,0,result.stdout+result.stderr)
        self.assert_values(result.stdout)

if __name__ == '__main__':
    unittest.main()

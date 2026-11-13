"""Tests for update_formula.py. Run: python3 -m unittest scripts/test_update_formula.py"""

from pathlib import Path
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))
import update_formula as update  # noqa: E402

CLI_TARGETS = ("darwin_arm64", "darwin_amd64", "linux_arm64", "linux_amd64")


def sums(directory, lines):
    path = Path(directory, "SHA256SUMS")
    path.write_text("".join(f"{digest}  {name}\n" for name, digest in lines))
    return path


def cli_sums(directory, version, digest):
    return sums(directory, [(f"rc-cli_{version}_{target}.tar.gz", digest) for target in CLI_TARGETS])


class RcCliTests(unittest.TestCase):
    def test_the_version_and_four_hashes_are_updated_and_nothing_else(self):
        with tempfile.TemporaryDirectory() as directory:
            formula = Path(directory, "rc-cli.rb")
            original = (ROOT / "Formula/rc-cli.rb").read_text()
            formula.write_text(original)
            update.update_formula("rc-cli", formula, "v9.9.9", cli_sums(directory, "9.9.9", "7" * 64))
            changed = formula.read_text()
        self.assertIn('version "9.9.9"', changed)
        self.assertEqual(changed.count("7" * 64), 4)
        before, after = original.splitlines(), changed.splitlines()
        self.assertEqual(len(before), len(after))
        self.assertEqual(sum(a != b for a, b in zip(before, after)), 5)

    def test_a_missing_archive_hash_is_an_error(self):
        with tempfile.TemporaryDirectory() as directory:
            formula = Path(directory, "rc-cli.rb")
            formula.write_text((ROOT / "Formula/rc-cli.rb").read_text())
            partial = sums(directory, [(f"rc-cli_9.9.9_{target}.tar.gz", "7" * 64) for target in CLI_TARGETS[:3]])
            with self.assertRaises(KeyError):
                update.update_formula("rc-cli", formula, "v9.9.9", partial)


class TypeScriptProfilerTests(unittest.TestCase):
    template = ROOT / "templates/rc-profiler-typescript.rb"

    def test_the_formula_is_created_from_the_template_on_the_first_release(self):
        with tempfile.TemporaryDirectory() as directory:
            formula = Path(directory, "rc-profiler-typescript.rb")
            checksums = sums(directory, [("rc-profiler-typescript_0.3.0.tar.gz", "a" * 64), ("rc-profiler-typescript_0.3.0-1_amd64.deb", "b" * 64)])
            update.update_formula("rc-profiler-typescript", formula, "v0.3.0", checksums, self.template)
            created = formula.read_text()
        self.assertIn('version "0.3.0"', created)
        self.assertIn('sha256 "' + "a" * 64 + '"', created)
        self.assertNotIn("b" * 64, created)
        self.assertIn('depends_on "node"', created)

    def test_later_releases_change_only_the_version_and_hash_in_place(self):
        with tempfile.TemporaryDirectory() as directory:
            formula = Path(directory, "rc-profiler-typescript.rb")
            update.update_formula("rc-profiler-typescript", formula, "v0.3.0",
                                  sums(directory, [("rc-profiler-typescript_0.3.0.tar.gz", "a" * 64)]), self.template)
            first = formula.read_text()
            formula.write_text(first.replace("depends_on", "# edited in the tap\n  depends_on"))
            update.update_formula("rc-profiler-typescript", formula, "v0.4.0",
                                  sums(directory, [("rc-profiler-typescript_0.4.0.tar.gz", "c" * 64)]), None)
            second = formula.read_text()
        self.assertIn('version "0.4.0"', second)
        self.assertIn('sha256 "' + "c" * 64 + '"', second)
        self.assertIn("# edited in the tap", second, "install code edited in the tap must be kept")

    def test_a_missing_formula_without_a_template_is_an_error(self):
        with tempfile.TemporaryDirectory() as directory:
            checksums = sums(directory, [("rc-profiler-typescript_0.3.0.tar.gz", "a" * 64)])
            with self.assertRaisesRegex(ValueError, "no template"):
                update.update_formula("rc-profiler-typescript", Path(directory, "missing.rb"), "v0.3.0", checksums, Path(directory, "none.rb"))


class SharedChecksTests(unittest.TestCase):
    def test_only_stable_release_tags_are_accepted(self):
        with tempfile.TemporaryDirectory() as directory:
            checksums = sums(directory, [("rc-profiler-typescript_0.3.0.tar.gz", "a" * 64)])
            for tag in ("0.3.0", "v0.3", "v0.3.0-rc1", "main"):
                with self.assertRaisesRegex(ValueError, "stable"):
                    update.update_formula("rc-profiler-typescript", Path(directory, "f.rb"), tag, checksums, TypeScriptProfilerTests.template)

    def test_a_malformed_or_duplicate_checksum_line_is_an_error(self):
        with tempfile.TemporaryDirectory() as directory:
            bad = Path(directory, "SHA256SUMS")
            bad.write_text("not a checksum line\n")
            with self.assertRaisesRegex(ValueError, "malformed"):
                update.read_checksums(bad, "0.3.0", ["rc-profiler-typescript_{version}.tar.gz"])
            twice = sums(directory, [("rc-profiler-typescript_0.3.0.tar.gz", "a" * 64)] * 2)
            with self.assertRaisesRegex(ValueError, "duplicate"):
                update.read_checksums(twice, "0.3.0", ["rc-profiler-typescript_{version}.tar.gz"])

    def test_each_formula_follows_its_own_repository(self):
        self.assertEqual(update.PACKAGES["rc-cli"]["repository"], "runtimeconditions/rc-cli")
        self.assertEqual(update.PACKAGES["rc-profiler-typescript"]["repository"], "runtimeconditions/ts-rc-profiler")


if __name__ == "__main__":
    unittest.main()

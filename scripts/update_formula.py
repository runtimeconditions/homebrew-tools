"""Update only the version and archive hashes in the tap-owned rc-cli formula."""

import argparse
import os
from pathlib import Path
import re


VERSION_RE = re.compile(r"^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$")
TARGETS = ("darwin_arm64", "darwin_amd64", "linux_arm64", "linux_amd64")


def read_checksums(path, version):
    found = {}
    for line in Path(path).read_text().splitlines():
        match = re.fullmatch(r"([0-9a-f]{64})  ([A-Za-z0-9._-]+)", line)
        if not match:
            raise ValueError("malformed SHA256SUMS line")
        digest, name = match.groups()
        if name in found:
            raise ValueError(f"duplicate checksum entry: {name}")
        found[name] = digest
    return {target: found[f"rc-cli_{version}_{target}.tar.gz"] for target in TARGETS}


def update_formula(formula_path, tag, checksums_path):
    if not VERSION_RE.fullmatch(tag):
        raise ValueError("expected a stable vMAJOR.MINOR.PATCH release tag")
    version = tag[1:]
    checksums = read_checksums(checksums_path, version)
    formula = Path(formula_path).read_text()
    formula, count = re.subn(r'(?m)^  version "[^"]+"$', f'  version "{version}"', formula)
    if count != 1:
        raise ValueError("formula must contain exactly one version field")

    for target, digest in checksums.items():
        url = f"https://github.com/runtimeconditions/rc-cli/releases/download/v#{{version}}/rc-cli_#{{version}}_{target}.tar.gz"
        pattern = re.compile(
            r'(url "' + re.escape(url) + r'"\n\s+sha256 ")[0-9a-f]{64}(")'
        )
        formula, count = pattern.subn(lambda match: match.group(1) + digest + match.group(2), formula)
        if count != 1:
            raise ValueError(f"formula must contain exactly one archive URL and checksum for {target}")

    path = Path(formula_path)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(formula)
    os.replace(temporary, path)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--tag", required=True)
    parser.add_argument("--checksums", required=True)
    parser.add_argument("--formula", default="Formula/rc-cli.rb")
    args = parser.parse_args()
    update_formula(args.formula, args.tag, args.checksums)


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, KeyError) as error:
        raise SystemExit(f"update_formula: {error}")

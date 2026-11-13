"""Update only the version and archive hashes in a tap-owned formula."""

import argparse
import os
from pathlib import Path
import re


VERSION_RE = re.compile(r"^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$")
# Each formula follows the releases of one repository. The archives are the release files whose
# hashes the formula carries, with {version} standing for the release version.
PACKAGES = {
    "rc-cli": {
        "repository": "runtimeconditions/rc-cli",
        "archives": [f"rc-cli_{{version}}_{target}.tar.gz"
                     for target in ("darwin_arm64", "darwin_amd64", "linux_arm64", "linux_amd64")],
    },
    "rc-profiler-typescript": {
        "repository": "runtimeconditions/ts-rc-profiler",
        "archives": ["rc-profiler-typescript_{version}.tar.gz"],
    },
}


def read_checksums(path, version, archives):
    found = {}
    for line in Path(path).read_text().splitlines():
        match = re.fullmatch(r"([0-9a-f]{64})  ([A-Za-z0-9._-]+)", line)
        if not match:
            raise ValueError("malformed SHA256SUMS line")
        digest, name = match.groups()
        if name in found:
            raise ValueError(f"duplicate checksum entry: {name}")
        found[name] = digest
    return {archive: found[archive.format(version=version)] for archive in archives}


def update_formula(name, formula_path, tag, checksums_path, template_path=None):
    """Write the version and hashes of a release into the formula.

    The formula is created from the tap's template when it does not exist yet, so a formula
    is only added once its package has a release to install.
    """
    if not VERSION_RE.fullmatch(tag):
        raise ValueError("expected a stable vMAJOR.MINOR.PATCH release tag")
    package = PACKAGES[name]
    version = tag[1:]
    checksums = read_checksums(checksums_path, version, package["archives"])
    path = Path(formula_path)
    if path.exists():
        formula = path.read_text()
    elif template_path is not None and Path(template_path).exists():
        formula = Path(template_path).read_text()
    else:
        raise ValueError(f"{formula_path} does not exist and there is no template to create it from")
    formula, count = re.subn(r'(?m)^  version "[^"]+"$', f'  version "{version}"', formula)
    if count != 1:
        raise ValueError("formula must contain exactly one version field")

    for archive, digest in checksums.items():
        url = f"https://github.com/{package['repository']}/releases/download/v#{{version}}/{archive.replace('{version}', '#{version}')}"
        pattern = re.compile(
            r'(url "' + re.escape(url) + r'"\n\s+sha256 ")[0-9a-f]{64}(")'
        )
        formula, count = pattern.subn(lambda match: match.group(1) + digest + match.group(2), formula)
        if count != 1:
            raise ValueError(f"formula must contain exactly one archive URL and checksum for {archive}")

    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(formula)
    os.replace(temporary, path)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--name", default="rc-cli", choices=sorted(PACKAGES))
    parser.add_argument("--print-repository", action="store_true", help="print the repository whose releases the formula follows")
    parser.add_argument("--tag")
    parser.add_argument("--checksums")
    parser.add_argument("--formula", help="default: Formula/<name>.rb")
    args = parser.parse_args()
    if args.print_repository:
        print(PACKAGES[args.name]["repository"])
        return
    if not args.tag or not args.checksums:
        parser.error("--tag and --checksums are required")
    update_formula(args.name, args.formula or f"Formula/{args.name}.rb", args.tag, args.checksums,
                   template_path=f"templates/{args.name}.rb")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, KeyError) as error:
        raise SystemExit(f"update_formula: {error}")

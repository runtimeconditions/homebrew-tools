# Runtime Conditions Homebrew tap

```sh
brew install runtimeconditions/tools/rc-cli
```

The `rc-cli` formula installs the `rc` command, its binding schemas, and shell completions. Go
profiling is linked into `rc`, so the separate `rc-profiler-go` formula is not a dependency. Optional
language profilers are installed with their own package managers; for example,
`npm install --save-dev @runtimeconditions/typescript-profiler`.

After [`rc-cli`](https://github.com/runtimeconditions/rc-cli) publishes a stable GitHub release, its
release workflow dispatches that exact tag to the `Update formulas` workflow. The tap downloads that
release's `SHA256SUMS` file and updates only the version and four archive checksums in the formula
stored here. Formula installation code stays in this repository. You can run the workflow manually
from the Actions tab to recover a missed dispatch; leave the tag blank to use the latest stable release.

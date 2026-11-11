# Runtime Conditions Homebrew tap

```sh
brew tap runtimeconditions/tools
brew install rc-cli
```

The `rc-cli` formula installs the `rc` command, its binding schemas, and shell completions. Go
profiling is linked into `rc`, so the separate `rc-profiler-go` formula is not a dependency. Optional
language profilers are installed with their own package managers; for example,
`npm install --save-dev @runtimeconditions/typescript-profiler`.

The `Update formulas` workflow reads the latest stable release's `SHA256SUMS` file from
[`rc-cli`](https://github.com/runtimeconditions/rc-cli) every hour, or on demand from the Actions tab.
It updates only the version and four archive checksums in the formula stored in this tap. Formula
installation code stays in this repository.

# Runtime Conditions Homebrew tap

```sh
brew install runtimeconditions/tools/rc-cli
```

The `rc-cli` formula installs the `rc` command, its binding schemas, and shell completions. Go
profiling is linked into `rc`, so the separate `rc-profiler-go` formula is not a dependency. The TypeScript
profiler is its own formula, `brew install runtimeconditions/tools/rc-profiler-typescript`, and `rc profile
typescript` runs it. It is also on npm, for projects that want it in their npm scripts.

After [`rc-cli`](https://github.com/runtimeconditions/rc-cli) or the
[TypeScript profiler](https://github.com/runtimeconditions/ts-rc-profiler) publishes a stable GitHub
release, its release workflow dispatches that exact tag to the `Update formulas` workflow. The tap
downloads that release's `SHA256SUMS` file and updates only the version and archive checksums in the
formula stored here. Formula installation code stays in this repository; the first release of the
TypeScript profiler creates its formula from `templates/rc-profiler-typescript.rb`. You can run the workflow manually
from the Actions tab to recover a missed dispatch; choose the formula, and leave the tag blank to use the latest
stable release.

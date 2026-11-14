# Template for Formula/rc-profiler-typescript.rb. scripts/update_formula.py creates the formula from it
# when the first release is published, and from then on edits only the version and checksum in place.
class RcProfilerTypescript < Formula
  desc "Runtime Conditions profiler for TypeScript codebases"
  homepage "https://github.com/runtimeconditions/ts-rc-profiler"
  version "0.0.0"
  url "https://github.com/runtimeconditions/ts-rc-profiler/releases/download/v#{version}/rc-profiler-typescript_#{version}.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  depends_on "node"

  def install
    libexec.install Dir["app/*"]
    (bin/"rc-profiler-typescript").write <<~SH
      #!/bin/sh
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/src/main.js" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rc-profiler-typescript --version")
  end
end

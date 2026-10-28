class RcProfilerGo < Formula
  desc "Runtime Conditions profiler for Go codebases"
  homepage "https://github.com/runtimeconditions/go-rc-profiler"
  version "0.6.0"

  on_macos do
    on_arm do
      url "https://github.com/runtimeconditions/go-rc-profiler/releases/download/v0.6.0/go-rc-profiler_v0.6.0_darwin_arm64.tar.gz"
      sha256 "d82a66ef901e39695d4e563cee9cb61bb43a7917e6c7b94eacc35424dbff1e78"
    end
    on_intel do
      url "https://github.com/runtimeconditions/go-rc-profiler/releases/download/v0.6.0/go-rc-profiler_v0.6.0_darwin_amd64.tar.gz"
      sha256 "1b1dcd4a3c441dba32996eab91a7414f715c11789c18f739c7054e1fa5f331c3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/runtimeconditions/go-rc-profiler/releases/download/v0.6.0/go-rc-profiler_v0.6.0_linux_arm64.tar.gz"
      sha256 "7707f08046f6d0c95f19f6b308e3adfd1a48c94ae11059ce29374a68a3be7dac"
    end
    on_intel do
      url "https://github.com/runtimeconditions/go-rc-profiler/releases/download/v0.6.0/go-rc-profiler_v0.6.0_linux_amd64.tar.gz"
      sha256 "e35ef96832608445d0651118551e563c6ce2d19a8c239d172c301bd759bd5b75"
    end
  end

  def install
    bin.install "go-rc-profiler"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-rc-profiler --version")
  end
end

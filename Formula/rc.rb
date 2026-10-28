class Rc < Formula
  desc "Runtime Conditions command line"
  homepage "https://github.com/runtimeconditions/go-rc-cli"
  version "0.2.0"
  license "MIT"

  depends_on "rc-profiler-go"

  on_macos do
    on_arm do
      url "https://github.com/runtimeconditions/go-rc-cli/releases/download/v0.2.0/rc_0.2.0_darwin_arm64.tar.gz"
      sha256 "685a12d844319bbae02abd4875c8fd489eca174c8f2130e661afb6bf49462a5c"
    end
    on_intel do
      url "https://github.com/runtimeconditions/go-rc-cli/releases/download/v0.2.0/rc_0.2.0_darwin_amd64.tar.gz"
      sha256 "fc0326a4dce8e089774eb3d2630e094f40ccef54e497b380435a48eff2cdab6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/runtimeconditions/go-rc-cli/releases/download/v0.2.0/rc_0.2.0_linux_arm64.tar.gz"
      sha256 "96df47d2a8974f9bf240060a4b7e43e0df008fbcb04dcb0fcf30241286699406"
    end
    on_intel do
      url "https://github.com/runtimeconditions/go-rc-cli/releases/download/v0.2.0/rc_0.2.0_linux_amd64.tar.gz"
      sha256 "6bc35ffcd340f67c73b67bd20c04aaf9c874bcdf8561708955d30947b9f5d34e"
    end
  end

  def install
    bin.install "rc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rc --version")
  end
end

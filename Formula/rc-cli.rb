class RcCli < Formula
  desc "Runtime Conditions command line"
  homepage "https://github.com/runtimeconditions/rc-cli"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_darwin_arm64.tar.gz"
      sha256 "1d39938bdc77191e14aaae681761a7e5fd9b16e95fa74ece1d87191b4f4dec26"
    end
    on_intel do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_darwin_amd64.tar.gz"
      sha256 "ded9d287c9ebaf6572ce02109282f22c8c1e5a26aed2d4b57a433fe022086235"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_linux_arm64.tar.gz"
      sha256 "8921ee5d8fe561bdea074cdd95ab4c378eddee876ab0fd6405eb9eddfefa9498"
    end
    on_intel do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_linux_amd64.tar.gz"
      sha256 "137dfa14e95413348698a25571b3dcdaf6d578e79a94e3b25207103a72c6fcbf"
    end
  end

  def install
    bin.install "bin/rc"
    bash_completion.install "share/bash-completion/completions/rc"
    zsh_completion.install "share/zsh/site-functions/_rc"
    fish_completion.install "share/fish/vendor_completions.d/rc.fish"
    prefix.install "share"
  end

end

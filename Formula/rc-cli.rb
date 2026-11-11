class RcCli < Formula
  desc "Runtime Conditions command line"
  homepage "https://github.com/runtimeconditions/rc-cli"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_darwin_arm64.tar.gz"
      sha256 "dde2ec49fa2d15eab765ccc8c344db9e7257823def499059b43998fecce8929d"
    end
    on_intel do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_darwin_amd64.tar.gz"
      sha256 "fc1303ab78594dd69f68997f19cac9de49f497507fb81e8688c4c447591058b8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_linux_arm64.tar.gz"
      sha256 "ea6e85463bb074f5ce405fcc9fe7bb33f2e00e7e5a9c42f558308ee1d170d25b"
    end
    on_intel do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_linux_amd64.tar.gz"
      sha256 "1633fc07602df10c8b07806d02ef1718e332fe053120b4391f3a663e9054b459"
    end
  end

  def install
    bin.install "bin/rc"
    prefix.install "share"
    bash_completion.install "share/bash-completion/completions/rc"
    zsh_completion.install "share/zsh/site-functions/_rc"
    fish_completion.install "share/fish/vendor_completions.d/rc.fish"
  end

end

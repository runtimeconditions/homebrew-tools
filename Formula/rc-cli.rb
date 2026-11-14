class RcCli < Formula
  desc "Runtime Conditions command line"
  homepage "https://github.com/runtimeconditions/rc-cli"
  version "0.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_darwin_arm64.tar.gz"
      sha256 "cd1518427b26638a72ddb98620b521744a0b751e9284e007dcd2b68cc934d72e"
    end
    on_intel do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_darwin_amd64.tar.gz"
      sha256 "3d8a7592f419b06fb4cd1e6240188c3bbc94c42f16e49b92bc2355dca2362a23"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_linux_arm64.tar.gz"
      sha256 "ef2772a859bbf206289c50d93f6c44a5c98c80a0767907721c5353f93580bea7"
    end
    on_intel do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_linux_amd64.tar.gz"
      sha256 "be17ca9be18a6f442f108ae98a6a0c51ae3e529abb46387b49bebdab3e260d3f"
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

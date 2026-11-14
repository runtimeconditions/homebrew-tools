class RcCli < Formula
  desc "Runtime Conditions command line"
  homepage "https://github.com/runtimeconditions/rc-cli"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_darwin_arm64.tar.gz"
      sha256 "57d9084b46fbdbfb33dc1e919dc54e4a6a5a18135c91701b7b1aca8601a623a2"
    end
    on_intel do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_darwin_amd64.tar.gz"
      sha256 "675fa646448d430f3f2fb8ff08d7d5340297e07dd6dae3a9a6d0be47294e851f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_linux_arm64.tar.gz"
      sha256 "ba39c23b75b38d4f00465941cf7d3c83af84af7a4d5b3b403ef453bab5e8925a"
    end
    on_intel do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_linux_amd64.tar.gz"
      sha256 "77e0a95ee4c5a8bde4470905b1cb5c09a2f4ddfcba95cf0c178225bc9f9b15f9"
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

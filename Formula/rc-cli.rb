class RcCli < Formula
  desc "Runtime Conditions command line"
  homepage "https://github.com/runtimeconditions/rc-cli"
  version "0.5.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_darwin_arm64.tar.gz"
      sha256 "2881b15e00fd182ef21b6792b8c4c43d590197d120bb608ea75ee0147a1139db"
    end
    on_intel do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_darwin_amd64.tar.gz"
      sha256 "c67d4798f28ad763c491ab9047bcab374f150847d23ef014fb42404e92aa1f45"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_linux_arm64.tar.gz"
      sha256 "294a2f0427cbaa17ef1b97f701b6887570e6e7fa88ed87d2009a3835a631a9cf"
    end
    on_intel do
      url "https://github.com/runtimeconditions/rc-cli/releases/download/v#{version}/rc-cli_#{version}_linux_amd64.tar.gz"
      sha256 "3be4dc9f5ba436ee508aa33cd9adc47e48203905a941f82c56fb8b1c2b7cd5c5"
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

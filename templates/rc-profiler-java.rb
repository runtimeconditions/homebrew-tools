# Template for Formula/rc-profiler-java.rb. scripts/update_formula.py creates the formula from it
# when the first release is published, and from then on edits only the version and checksum in place.
class RcProfilerJava < Formula
  desc "Runtime Conditions profiler for Java codebases"
  homepage "https://github.com/runtimeconditions/java-rc-profiler"
  version "0.0.0"
  url "https://github.com/runtimeconditions/java-rc-profiler/releases/download/v#{version}/rc-profiler-java_#{version}.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  depends_on "openjdk@21"

  def install
    libexec.install "rc-profiler-java", "runtimeconditions-java-profiler.jar"
    # The launcher uses JAVA_HOME when it is set and otherwise this JDK.
    (bin/"rc-profiler-java").write_env_script libexec/"rc-profiler-java",
                                                Language::Java.overridable_java_home_env("21")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rc-profiler-java --version")
  end
end

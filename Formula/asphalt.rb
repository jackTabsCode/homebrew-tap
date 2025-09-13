class Asphalt < Formula
  desc "Upload and reference Roblox assets in code"
  homepage "https://github.com/jacktabscode/asphalt"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacktabscode/asphalt/releases/download/v1.1.0/asphalt-aarch64-apple-darwin.tar.xz"
      sha256 "3567a7b5a7ac797ea878ec2a1ed46d0e3dde58194198f18723e395979564505a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacktabscode/asphalt/releases/download/v1.1.0/asphalt-x86_64-apple-darwin.tar.xz"
      sha256 "167e730093ace2cc6ae07fe93a9ea0377484918a14ad77ac863983493bbc4fe8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jacktabscode/asphalt/releases/download/v1.1.0/asphalt-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2a844d719cd8a7f1fae9e07edc180d59a0304b574a3e6589a56394c98b357344"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "asphalt" if OS.mac? && Hardware::CPU.arm?
    bin.install "asphalt" if OS.mac? && Hardware::CPU.intel?
    bin.install "asphalt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

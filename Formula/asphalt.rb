class Asphalt < Formula
  desc "Upload and reference Roblox assets in code"
  homepage "https://github.com/jacktabscode/asphalt"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacktabscode/asphalt/releases/download/v1.2.0/asphalt-aarch64-apple-darwin.tar.xz"
      sha256 "58afda4705a286fcb8e800eaa3387246b15a8f1a8351a3929c0ec73a905155e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacktabscode/asphalt/releases/download/v1.2.0/asphalt-x86_64-apple-darwin.tar.xz"
      sha256 "d09bd57690942f5ee4ec1f144564edb5826a46c19e8087e9cb5d401009fba065"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacktabscode/asphalt/releases/download/v1.2.0/asphalt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5e40830683ad1819e835993134968175fc13c9c374f7dda209458534acaa5ab5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacktabscode/asphalt/releases/download/v1.2.0/asphalt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4d636548826dd826e1c01aa6bf27a3a9d76dfd6a3efc0c5731de09a3bdcc9410"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "asphalt" if OS.linux? && Hardware::CPU.arm?
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

class Asphalt < Formula
  desc "Upload and reference Roblox assets in code"
  homepage "https://github.com/jacktabscode/asphalt"
  version "2.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacktabscode/asphalt/releases/download/v2.0.0/asphalt-aarch64-apple-darwin.tar.xz"
      sha256 "fcb5c21553d4c9882e8dce80c1cd88e465a0f50e5d1303d4bdce14c6329cb580"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacktabscode/asphalt/releases/download/v2.0.0/asphalt-x86_64-apple-darwin.tar.xz"
      sha256 "9118b7973634e289cc01df3bc8685fc29119b9162ad0da85b93f683188679750"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacktabscode/asphalt/releases/download/v2.0.0/asphalt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0fdc0a54500b6c3cc1da662e84f2f214fd1fbf2ec140ee1e9073d5a8dfa47eca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacktabscode/asphalt/releases/download/v2.0.0/asphalt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e86f10d3ddaafb8ef86f1e2c6700283806b5b281b3c358c4b1fc20b88f5e434"
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

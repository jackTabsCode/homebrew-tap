class Asphalt < Formula
  desc "Upload and reference Roblox assets in code"
  homepage "https://github.com/jacktabscode/asphalt"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacktabscode/asphalt/releases/download/v0.8.4/asphalt-aarch64-apple-darwin.zip"
      sha256 "8e5191953e848d68afb4d0680b09f7158122e6b0061a1b7b77d7b5f71c09a092"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacktabscode/asphalt/releases/download/v0.8.4/asphalt-x86_64-apple-darwin.zip"
      sha256 "75d33483d03a224da9d6158828ce686f1f6eb910c31065f52181521003e46340"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jacktabscode/asphalt/releases/download/v0.8.4/asphalt-x86_64-unknown-linux-gnu.zip"
    sha256 "f298f3a669f63ea69b2af38aa2069f65db4bbe3f3cd01dd4819a50ca5499564a"
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

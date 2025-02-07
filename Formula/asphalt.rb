class Asphalt < Formula
  desc "Upload and reference Roblox assets in code"
  homepage "https://github.com/jacktabscode/asphalt"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacktabscode/asphalt/releases/download/v0.9.0/asphalt-aarch64-apple-darwin.zip"
      sha256 "ee89791a82d7ad7d5abd98208b839650c3eea229cdb0a648ef9b9253dda65bf5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacktabscode/asphalt/releases/download/v0.9.0/asphalt-x86_64-apple-darwin.zip"
      sha256 "59d10245275a3f3539cbd4ae07f3a4abf622edd372e2a573cfe42b50d0cf887b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jacktabscode/asphalt/releases/download/v0.9.0/asphalt-x86_64-unknown-linux-gnu.zip"
    sha256 "9332776f89a0f53332b6a6fe2aded78b6b73f9aa3a761f6d54cd43e0904c4971"
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

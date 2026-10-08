class Postbode < Formula
  desc "A fast, simple mail client with automatic mailbox rules"
  homepage "https://postbode.pataar.nl/"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pataar/postbode/releases/download/v0.2.0/postbode-aarch64-apple-darwin.tar.xz"
      sha256 "000e8eaebfcc3fcdc93967b1c1196ea2ea3a5468afef2969e72633b469a32d5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pataar/postbode/releases/download/v0.2.0/postbode-x86_64-apple-darwin.tar.xz"
      sha256 "b4d6d4aeb1ebaee1f0ff305eff15711d6937191d85bf767ec59e16e8c748b23d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pataar/postbode/releases/download/v0.2.0/postbode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "de9448fdf10eaefe004d109f339013c6ac89429a8a21491b65b105949a37b1e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pataar/postbode/releases/download/v0.2.0/postbode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b53f858c802d101afdac183ed0907c11823da1ca7489f617b7320e857f651197"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "postbode"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "postbode"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "postbode"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "postbode"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

class Postbode < Formula
  desc "A fast, simple mail client with automatic mailbox rules"
  homepage "https://github.com/pataar/postbode"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pataar/postbode/releases/download/v0.1.0/postbode-aarch64-apple-darwin.tar.xz"
      sha256 "e7f1af018191341b567dca4d75ccb98639a0cba172c5aeca97f46dce04934481"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pataar/postbode/releases/download/v0.1.0/postbode-x86_64-apple-darwin.tar.xz"
      sha256 "b25465300a9dcf6ac689ffcfdbc60d2399aa48ff9c1b71783d5eb150735115aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pataar/postbode/releases/download/v0.1.0/postbode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fea6789bdd4144b2dcb9c9fc52c920787fc446c76ef9cd22b80947ff4cf8a019"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pataar/postbode/releases/download/v0.1.0/postbode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "253014245698e4139278ec5789ae898d38d0800cabf4900de34ea5037f5986e8"
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

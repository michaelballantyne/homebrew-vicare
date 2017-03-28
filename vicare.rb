require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Vicare < Formula
  homepage "http://marcomaggi.github.io/vicare.html"
  url "https://github.com/marcomaggi/vicare/archive/08bd828acfa9382324150b41f4e86c540c10a886.tar.gz"
  sha256 "ac7ed64b79a96bafa2f994b4c75a14dba18b11101bb90bc6db9641c97b91b6b8"

  depends_on "gsl"
  depends_on "libffi"
  depends_on "gmp"
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    libffi = Formula["libffi"]
    ffi_include_path = "-I#{libffi.lib}/libffi-#{libffi.version}/include"

    inreplace "scheme/Makefile.am", "pkglib_DATA", "pkgdata_DATA"

    system "sh", "BUILD-THE-INFRASTRUCTURE.sh"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-libffi",
                          "LDFLAGS=-lgsl -lgslcblas",
                          "CPPFLAGS=#{ffi_include_path}"
    system "make"
    system "make install"

    cp "scheme/vicare.boot", "#{lib}/vicare/"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test vicare`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

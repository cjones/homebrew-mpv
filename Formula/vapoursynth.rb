require "formula"

class Vapoursynth < Formula
  url  'https://github.com/vapoursynth/vapoursynth/archive/R27.tar.gz'
  sha256 '3af82faf8c085ff25b2ad87c2d7e56d31247227d0b291de7769362ac6629b43d'
  homepage "http://www.vapoursynth.com"
  head "https://github.com/vapoursynth/vapoursynth.git"

  needs :cxx11
  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'yasm' => :build
  depends_on :python3

  depends_on 'ffmpeg'
  depends_on 'tesseract'
  depends_on 'libass'

  resource 'cython' do
    url 'https://pypi.python.org/packages/source/C/Cython/Cython-0.21.2.tar.gz'
    md5 'd21adb870c75680dc857cd05d41046a4'
    sha1 'b01af23102143515e6138a4d5e185c2cfa588e0df61c0827de4257bac3393679'
  end

  def install
    add_python_paths
    ohai "installing Cython to: #{libexec}"
    resource('cython').stage { system "python3", "setup.py", "install", "--prefix=#{libexec}" }
    args = [ "--prefix=#{prefix}" ]
    system "./autogen.sh"
    system "./configure", *args
    system "make install"
  end

  private
  def add_python_paths
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python#{pyver}/site-packages"
    ENV.prepend_create_path 'PATH', libexec/'bin'
    python_prefix = Pathname.new(`python3-config --prefix`.chomp)
    ENV.append_path "PKG_CONFIG_PATH", python_prefix / 'lib' / 'pkgconfig'
  end

  def pyver
    Language::Python.major_minor_version Formula['python3'].bin/'python3'
  end
end

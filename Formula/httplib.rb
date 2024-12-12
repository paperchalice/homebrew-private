class Httplib < Formula
  desc "C++ header-only HTTP/HTTPS server and client library"
  homepage "https://github.com/yhirose/cpp-httplib"
  url "https://github.com/yhirose/cpp-httplib/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "405abd8170f2a446fc8612ac635d0db5947c0d2e156e32603403a4496255ff00"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python" => :build

  depends_on "brotli"
  depends_on "openssl"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args + %w[
      -D BUILD_SHARED_LIBS=ON
      -D HTTPLIB_COMPILE=ON
      -S .
      -B build
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    meson_args = %w[
      setup
      meson_build
      -Dcpp-httplib_compile=true
    ] + std_meson_args
    system "meson", *meson_args
    system "meson", "compile", "-C", "meson_build"
    system "meson", "install", "-C", "meson_build"
  end

  test do
    (testpath/"server.cpp").write <<~CPP
      #include <httplib.h>
      using namespace httplib;

      int main(void) {
        Server svr;

        svr.Get("/hi", [](const Request &, Response &res) {
          res.set_content("Hello World!", "text/plain");
        });

        svr.listen("0.0.0.0", 8080);
      }
    CPP
    (testpath/"client.cpp").write <<~CPP
      #include <httplib.h>
      #include <iostream>
      using namespace httplib;
      using namespace std;

      int main(void) {
        Client cli("localhost", 8080);
        if (auto res = cli.Get("/hi")) {
          cout << res->status << endl;
          cout << res->get_header_value("Content-Type") << endl;
          cout << res->body << endl;
          return 0;
        } else {
          return 1;
        }
      }
    CPP
    cxx_args = %W[
      -I#{include}
      -L#{lib}
      -lcpp-httplib
      -std=c++11
    ]
    system ENV.cxx, "server.cpp", *cxx_args, "-o", "server"
    system ENV.cxx, "client.cpp", *cxx_args, "-o", "client"

    fork do
      exec "./server"
    end
    sleep 3
    assert_match "Hello World!", shell_output("./client")
  end
end

class QtCharts < Formula
  desc "State Machine Notation compiler and related tools"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.0/submodules/qtcharts-everywhere-src-6.3.0.tar.xz"
  sha256 "672762c5f641ccc88a30aeedefb63f03c0f837649b334f46eea57592e87e36cd"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtcharts.git", branch: "dev"

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-charts-6.3.0"
    sha256 cellar: :any, monterey: "6ceaa5bd38c910a77748373ad5add12a1c8bc25da191fdd204abf842cf0bbb0e"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "qt-base"
  depends_on "qt-declarative"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    lib.glob("*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
      lib.install_symlink f/f.stem => shared_library("lib#{f.stem}")
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test_project VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Widgets REQUIRED)
      find_package(Qt6Charts)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Widgets Qt6::Charts)
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QtWidgets/QApplication>
      #include <QtWidgets/QMainWindow>
      #include <QtCharts/QChartView>
      #include <QtCharts/QLineSeries>

      QT_USE_NAMESPACE

      int main(int argc, char *argv[])
      {
          QApplication a(argc, argv);

          QLineSeries *series = new QLineSeries();

          series->append(0, 6);
          series->append(2, 4);
          series->append(3, 8);
          series->append(7, 4);
          series->append(10, 5);
          *series << QPointF(11, 1) << QPointF(13, 3) << QPointF(17, 6) << QPointF(18, 3) << QPointF(20, 2);

          QChart *chart = new QChart();
          chart->legend()->hide();
          chart->addSeries(series);
          chart->createDefaultAxes();
          chart->setTitle("Simple line chart example");

          QChartView *chartView = new QChartView(chart);
          chartView->setRenderHint(QPainter::Antialiasing);

          QMainWindow window;
          window.setCentralWidget(chartView);
          window.resize(400, 300);
          window.show();

          return 0;
      }
    EOS

    system "cmake", "."
    system "cmake", "--build", "."
    system "./test"
  end
end

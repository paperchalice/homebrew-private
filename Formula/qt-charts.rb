class QtCharts < Formula
  desc "State Machine Notation compiler and related tools"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.2/submodules/qtcharts-everywhere-src-6.1.2.tar.xz"
  sha256 "872f786ef497d6e3c89e93ef758d9532c502a94db3005631a2fe0bd5fc2adddc"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtcharts.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-charts-6.1.2"
    sha256 cellar: :any, big_sur: "58fc4ac04686002371aeb9f22e0e4a19b221a63b20ee28eb63cb9c7c393088b3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "perl" => :build

  depends_on "qt-base"
  depends_on "qt-declarative"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    Pathname.glob(lib/"*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.basename
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

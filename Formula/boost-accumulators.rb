class BoostAccumulators < Formula
  desc "Library for incremental statistical computation"
  homepage "https://boost.org/libs/accumulators/"
  url "https://github.com/boostorg/accumulators.git",
    tag:      "boost-1.77.0",
    revision: "14c13370602fe86d134a948943958cab0921ce9c"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-accumulators-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "42a3b13709ef85b159ba67e7cddbb4b8939ce2df42d551e46503a34146c6da08"
  end

  depends_on "boost-assert"        => :test
  depends_on "boost-concept-check" => :test
  depends_on "boost-config"        => :test
  depends_on "boost-core"          => :test
  depends_on "boost-fusion"        => :test
  depends_on "boost-mp11"          => :test
  depends_on "boost-mpl"           => :test
  depends_on "boost-parameter"     => :test
  depends_on "boost-preprocessor"  => :test
  depends_on "boost-static-assert" => :test
  depends_on "boost-type-traits"   => :test
  depends_on "boost-typeof"        => :test
  depends_on "boost-utility"       => :test

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <boost/accumulators/accumulators.hpp>
      #include <boost/accumulators/statistics/stats.hpp>
      #include <boost/accumulators/statistics/mean.hpp>
      #include <boost/accumulators/statistics/moment.hpp>
      using namespace boost::accumulators;

      int main()
      {
          // Define an accumulator set for calculating the mean and the
          // 2nd moment ...
          accumulator_set<double, stats<tag::mean, tag::moment<2> > > acc;

          // push in some data ...
          acc(1.2);
          acc(2.3);
          acc(3.4);
          acc(4.5);

          // Display the results ...
          std::cout << "Mean:   " << mean(acc) << std::endl;
          std::cout << "Moment: " << moment<2>(acc) << std::endl;

          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp"
    system "./a.out"
  end
end

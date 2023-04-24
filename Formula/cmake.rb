class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.26.3/cmake-3.26.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.26.3.tar.gz"
  sha256 "bbd8d39217509d163cb544a40d6428ac666ddc83e22905d3e52c925781f0f659"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/cmake-3.25.2"
    sha256 cellar: :any, monterey: "1bd00d83a0c9f5a1c0af32d7e5721396a992ae5925d1eb1cae7a96d1cf53e30e"
  end

  depends_on "pkgconf" => :build

  # nghttp2 is for curl
  depends_on "jsoncpp"
  depends_on "libarchive"
  depends_on "libuv"
  depends_on "qt-base"
  depends_on "rhash"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  patch :DATA

  def install
    bootstrap_args = %W[
      --prefix=#{prefix}
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man

      --system-libs
      --qt-gui

      --
      -D CMAKE_USE_SYSTEM_LIBRARIES=ON
      -D CMake_INSTALL_EMACS_DIR=#{elisp.relative_path_from prefix}
      -D CMake_BUILD_LTO=ON
    ]

    system "./bootstrap", *bootstrap_args
    system "make"
    system "make", "install"

    libexec.install prefix/"CMake.app"
    %w[bin share].each do |p|
      prefix.install libexec/"CMake.app/contents"/p
      (libexec/"CMake.app/Contents/").install_symlink prefix/p
    end
    rm bin/"cmake-gui"
    prefix.write_exec_script libexec/"CMake.app/Contents/MacOS/CMake"
    bin.install prefix/"CMake" => "cmake-gui"
    (bin/"cmake-app").write <<~SH
      #! /bin/sh
      open #{opt_libexec}/CMake.app
    SH
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{version})

      project(Template
              VERSION      0.0.0.0
              DESCRIPTION  "CMake template project"
              HOMEPAGE_URL https://www.example.com/
              LANGUAGES    C CXX)

      set(CMAKE_C_STANDARD 17)
      set(CMAKE_CXX_STANDARD 17)
    CMAKE
    system bin/"cmake", "."
  end
end

__END__
diff --git a/Source/CPack/cpack.cxx b/Source/CPack/cpack.cxx
index 6c6d0ca7bbc2f64683988bb4632271c7b2cccce5..f9e5701294f7f62a3b8c99cc05e4bd36afcd887e 100644
--- a/Source/CPack/cpack.cxx
+++ b/Source/CPack/cpack.cxx
@@ -278,7 +278,7 @@ int main(int argc, char const* const* argv)
     }
 
     if (cmSystemTools::FileExists(cpackConfigFile)) {
-      cpackConfigFile = cmSystemTools::CollapseFullPath(cpackConfigFile);
+      cpackConfigFile = cmSystemTools::CollapseLogicalPath(cpackConfigFile);
       cmCPack_Log(&log, cmCPackLog::LOG_VERBOSE,
                   "Read CPack configuration file: " << cpackConfigFile
                                                     << std::endl);
@@ -330,7 +330,7 @@ int main(int argc, char const* const* argv)
     cpackProjectDirectory =
       globalMF.GetSafeDefinition("CPACK_PACKAGE_DIRECTORY");
     cpackProjectDirectory =
-      cmSystemTools::CollapseFullPath(cpackProjectDirectory);
+      cmSystemTools::CollapseLogicalPath(cpackProjectDirectory);
     globalMF.AddDefinition("CPACK_PACKAGE_DIRECTORY", cpackProjectDirectory);
 
     cmValue cpackModulesPath = globalMF.GetDefinition("CPACK_MODULE_PATH");
diff --git a/Source/CTest/cmCTestScriptHandler.cxx b/Source/CTest/cmCTestScriptHandler.cxx
index 16c0a0ec54b1a473fec31221f10c4e8aaefc03fe..26abbe891e52407410cccf22f6eda80349d39bf1 100644
--- a/Source/CTest/cmCTestScriptHandler.cxx
+++ b/Source/CTest/cmCTestScriptHandler.cxx
@@ -378,10 +378,6 @@ int cmCTestScriptHandler::ExtractVariables()
   this->BinaryDir =
     this->Makefile->GetSafeDefinition("CTEST_BINARY_DIRECTORY");
 
-  // add in translations for src and bin
-  cmSystemTools::AddKeepPath(this->SourceDir);
-  cmSystemTools::AddKeepPath(this->BinaryDir);
-
   this->CTestCmd = this->Makefile->GetSafeDefinition("CTEST_COMMAND");
   this->CVSCheckOut = this->Makefile->GetSafeDefinition("CTEST_CVS_CHECKOUT");
   this->CTestRoot = this->Makefile->GetSafeDefinition("CTEST_DASHBOARD_ROOT");
diff --git a/Source/CTest/cmCTestStartCommand.cxx b/Source/CTest/cmCTestStartCommand.cxx
index 84d12d77b088f0026c58550df9b5127c85035421..6548da530848d6ac4284aef748d43841d052acf0 100644
--- a/Source/CTest/cmCTestStartCommand.cxx
+++ b/Source/CTest/cmCTestStartCommand.cxx
@@ -88,9 +88,6 @@ bool cmCTestStartCommand::InitialPass(std::vector<std::string> const& args,
     return false;
   }
 
-  cmSystemTools::AddKeepPath(*src_dir);
-  cmSystemTools::AddKeepPath(*bld_dir);
-
   this->CTest->EmptyCTestConfiguration();
 
   std::string sourceDir = cmSystemTools::CollapseFullPath(*src_dir);
diff --git a/Source/QtDialog/CMakeSetup.cxx b/Source/QtDialog/CMakeSetup.cxx
index 8ffa3e728dbca162407b361692278bc867cf89c7..698475a22fb74dcfb3fe5586095294ed7fce942f 100644
--- a/Source/QtDialog/CMakeSetup.cxx
+++ b/Source/QtDialog/CMakeSetup.cxx
@@ -172,8 +172,7 @@ int main(int argc, char** argv)
       }
 
       sourceDirectory =
-        cmSystemTools::CollapseFullPath(path.toLocal8Bit().data());
-      cmSystemTools::ConvertToUnixSlashes(sourceDirectory);
+        cmSystemTools::CollapseLogicalPath(path.toLocal8Bit().data());
     } else if (arg.startsWith("-B")) {
       QString path = arg.mid(2);
       if (path.isEmpty()) {
@@ -190,7 +189,7 @@ int main(int argc, char** argv)
       }
 
       binaryDirectory =
-        cmSystemTools::CollapseFullPath(path.toLocal8Bit().data());
+        cmSystemTools::CollapseLogicalPath(path.toLocal8Bit().data());
       cmSystemTools::ConvertToUnixSlashes(binaryDirectory);
     } else if (arg.startsWith("--preset=")) {
       QString preset = arg.mid(cmStrLen("--preset="));
@@ -220,7 +219,7 @@ int main(int argc, char** argv)
   } else {
     if (args.count() == 2) {
       std::string filePath =
-        cmSystemTools::CollapseFullPath(args[1].toLocal8Bit().data());
+        cmSystemTools::CollapseLogicalPath(args[1].toLocal8Bit().data());
 
       // check if argument is a directory containing CMakeCache.txt
       std::string buildFilePath = cmStrCat(filePath, "/CMakeCache.txt");
@@ -240,7 +239,7 @@ int main(int argc, char** argv)
       } else if (cmSystemTools::FileExists(srcFilePath.c_str())) {
         dialog.setSourceDirectory(QString::fromLocal8Bit(filePath.c_str()));
         dialog.setBinaryDirectory(QString::fromLocal8Bit(
-          cmSystemTools::CollapseFullPath(".").c_str()));
+          cmSystemTools::CollapseLogicalPath(".").c_str()));
       }
     }
   }
diff --git a/Source/cmMakefile.cxx b/Source/cmMakefile.cxx
index 91d7ac5256987598a18b8fc3ad877ece846f89e0..f9a15d2c3443a7c5c5b707a8a248fc1816a4d404 100644
--- a/Source/cmMakefile.cxx
+++ b/Source/cmMakefile.cxx
@@ -1905,7 +1905,7 @@ void cmMakefile::AddCacheDefinition(const std::string& name, const char* value,
       nvalue.clear();
       for (cc = 0; cc < files.size(); cc++) {
         if (!cmIsOff(files[cc])) {
-          files[cc] = cmSystemTools::CollapseFullPath(files[cc]);
+          files[cc] = cmSystemTools::CollapseLogicalPath(files[cc]);
         }
         if (cc > 0) {
           nvalue += ";";
diff --git a/Source/cmOutputRequiredFilesCommand.cxx b/Source/cmOutputRequiredFilesCommand.cxx
index ad276d2f70392ac3cdaa1e719d1e16469c3f3462..011e9dc25b281832ba01e30040be7d5496878655 100644
--- a/Source/cmOutputRequiredFilesCommand.cxx
+++ b/Source/cmOutputRequiredFilesCommand.cxx
@@ -402,7 +402,7 @@ protected:
     }
 
     if (cmSystemTools::FileExists(fname, true)) {
-      std::string fp = cmSystemTools::CollapseFullPath(fname);
+      std::string fp = cmSystemTools::CollapseLogicalPath(fname);
       this->DirectoryToFileToPathMap[extraPath][fname] = fp;
       return fp;
     }
@@ -414,7 +414,7 @@ protected:
       path += fname;
       if (cmSystemTools::FileExists(path, true) &&
           !cmSystemTools::FileIsDirectory(path)) {
-        std::string fp = cmSystemTools::CollapseFullPath(path);
+        std::string fp = cmSystemTools::CollapseLogicalPath(path);
         this->DirectoryToFileToPathMap[extraPath][fname] = fp;
         return fp;
       }
@@ -428,7 +428,7 @@ protected:
       path = path + fname;
       if (cmSystemTools::FileExists(path, true) &&
           !cmSystemTools::FileIsDirectory(path)) {
-        std::string fp = cmSystemTools::CollapseFullPath(path);
+        std::string fp = cmSystemTools::CollapseLogicalPath(path);
         this->DirectoryToFileToPathMap[extraPath][fname] = fp;
         return fp;
       }
diff --git a/Source/cmQtAutoGenerator.cxx b/Source/cmQtAutoGenerator.cxx
index e5c7bda669bc653ebbf0e90bd8d4afcef395414b..ad34620679efb27ad55e3ce1e781cc723a062b7d 100644
--- a/Source/cmQtAutoGenerator.cxx
+++ b/Source/cmQtAutoGenerator.cxx
@@ -435,7 +435,7 @@ bool cmQtAutoGenerator::Run(cm::string_view infoFile, cm::string_view config)
 
   // Info file
   this->InfoFile_ = std::string(infoFile);
-  cmSystemTools::CollapseFullPath(this->InfoFile_);
+  cmSystemTools::CollapseLogicalPath(this->InfoFile_);
   this->InfoDir_ = cmSystemTools::GetFilenamePath(this->InfoFile_);
 
   // Load info file time
diff --git a/Source/cmStateDirectory.cxx b/Source/cmStateDirectory.cxx
index 20e460442519b3a26655f60ba36b9471d2837eb1..0abcec0489b5751fe177df9bd7b4fb1d93cc1ef3 100644
--- a/Source/cmStateDirectory.cxx
+++ b/Source/cmStateDirectory.cxx
@@ -38,8 +38,7 @@ void cmStateDirectory::SetCurrentSource(std::string const& dir)
 {
   std::string& loc = this->DirectoryState->Location;
   loc = dir;
-  cmSystemTools::ConvertToUnixSlashes(loc);
-  loc = cmSystemTools::CollapseFullPath(loc);
+  loc = cmSystemTools::CollapseLogicalPath(loc);
   this->Snapshot_.SetDefinition("CMAKE_CURRENT_SOURCE_DIR", loc);
 }
 
@@ -52,8 +51,7 @@ void cmStateDirectory::SetCurrentBinary(std::string const& dir)
 {
   std::string& loc = this->DirectoryState->OutputLocation;
   loc = dir;
-  cmSystemTools::ConvertToUnixSlashes(loc);
-  loc = cmSystemTools::CollapseFullPath(loc);
+  loc = cmSystemTools::CollapseLogicalPath(loc);
   this->Snapshot_.SetDefinition("CMAKE_CURRENT_BINARY_DIR", loc);
 }
 
diff --git a/Source/cmSystemTools.cxx b/Source/cmSystemTools.cxx
index cb3217249e2177948e00459dc6fd76f4a87e6dd1..8f5d7f21a99ee23b1b633d4d3fa65868593a54cd 100644
--- a/Source/cmSystemTools.cxx
+++ b/Source/cmSystemTools.cxx
@@ -1497,6 +1497,76 @@ std::string cmSystemTools::RelativeIfUnder(std::string const& top,
   return out;
 }
 
+std::string cmSystemTools::CollapseLogicalPath(std::string inbuf)
+{
+  for (std::string::size_type i = 0; i != inbuf.size(); ++i) {
+    if (inbuf[i] == '\\') {
+      inbuf[i] = '/';
+    }
+  }
+  if (!cmSystemTools::FileIsFullPath(inbuf)) {
+    inbuf = cmStrCat(cmSystemTools::GetLogicalWorkingDirectory(), '/', inbuf);
+  }
+
+  cm::string_view in = inbuf;
+
+  // Look for the '/' that starts the first component
+  // not including the machine name on a network path.
+  std::string::size_type in_slash =
+    in.find('/', cmHasLiteralPrefix(in, "//") ? 2 : 0);
+  std::string out{ in.substr(0, in_slash) };
+
+  while (in_slash != std::string::npos) {
+    // Look for the '/' or end-of-input that ends this component.
+    std::string::size_type next_slash = in.find('/', in_slash + 1);
+    cm::string_view in_comp = next_slash != std::string::npos
+      ? in.substr(in_slash, next_slash - in_slash)
+      : in.substr(in_slash, std::string::npos);
+
+    if (in_comp == "/..") {
+      // Compute a path to the destination of '..' that preserves
+      // as much of the original logical path as possible.
+      std::string dest_rp = cmSystemTools::GetRealPath(out + "/..");
+      std::string lp = std::move(out);
+      std::string::size_type lp_base =
+        lp.find('/', cmHasLiteralPrefix(lp, "//") ? 2 : 0);
+      for (;;) {
+        // If the realpath of 'lp' is a prefix of 'dest_rp', replace
+        // that prefix with the logical path 'lp'.
+        std::string const rp = cmSystemTools::GetRealPath(lp);
+        if ((rp.size() == dest_rp.size() ||
+             (rp.size() < dest_rp.size() && dest_rp[rp.size()] == '/')) &&
+            dest_rp.compare(0, rp.size(), rp) == 0) {
+          out = cmStrCat(std::move(lp), dest_rp.substr(rp.size()));
+          break;
+        }
+
+        // If 'lp' has no more components to strip, use original 'dest_lp'.
+        std::string::size_type lp_slash = lp.rfind('/');
+        if (lp_slash == std::string::npos || lp_base == std::string::npos ||
+            lp_slash <= lp_base) {
+          out = std::move(dest_rp);
+          break;
+        }
+
+        // Strip a component off 'lp' to try again.
+        lp.erase(lp_slash);
+      }
+    } else if (in_comp == "/.") {
+      // Skip '.' component.
+    } else if (in_comp == "/") {
+      // Skip empty component.
+    } else {
+      // Accept normal component.
+      out.append(in_comp);
+    }
+
+    in_slash = next_slash;
+  }
+
+  return out;
+}
+
 #ifndef CMAKE_BOOTSTRAP
 bool cmSystemTools::UnsetEnv(const char* value)
 {
@@ -1590,7 +1660,7 @@ bool cmSystemTools::CreateTar(const std::string& outFileName,
                               std::string const& format, int compressionLevel)
 {
 #if !defined(CMAKE_BOOTSTRAP)
-  std::string cwd = cmSystemTools::GetCurrentWorkingDirectory();
+  std::string cwd = cmSystemTools::GetLogicalWorkingDirectory();
   cmsys::ofstream fout(outFileName.c_str(), std::ios::out | std::ios::binary);
   if (!fout) {
     std::string e = cmStrCat("Cannot open output file \"", outFileName,
@@ -2225,6 +2295,22 @@ unsigned int cmSystemTools::RandomSeed()
 #endif
 }
 
+namespace {
+std::string cmSystemToolsLogicalWorkingDirectory;
+void InitLogicalWorkingDirectory()
+{
+  std::string cwd = cmSystemTools::GetCurrentWorkingDirectory();
+  std::string pwd;
+  if (cmSystemTools::GetEnv("PWD", pwd)) {
+    std::string const pwd_real = cmSystemTools::GetRealPath(pwd);
+    if (pwd_real == cwd) {
+      cwd = std::move(pwd);
+    }
+  }
+  cmSystemToolsLogicalWorkingDirectory = std::move(cwd);
+}
+}
+
 static std::string cmSystemToolsCMakeCommand;
 static std::string cmSystemToolsCTestCommand;
 static std::string cmSystemToolsCPackCommand;
@@ -2235,6 +2321,7 @@ static std::string cmSystemToolsCMakeRoot;
 static std::string cmSystemToolsHTMLDoc;
 void cmSystemTools::FindCMakeResources(const char* argv0)
 {
+  InitLogicalWorkingDirectory();
   std::string exe_dir;
 #if defined(_WIN32) && !defined(__CYGWIN__)
   (void)argv0; // ignore this on windows
@@ -2405,6 +2492,20 @@ std::string const& cmSystemTools::GetHTMLDoc()
   return cmSystemToolsHTMLDoc;
 }
 
+std::string const& cmSystemTools::GetLogicalWorkingDirectory()
+{
+  return cmSystemToolsLogicalWorkingDirectory;
+}
+
+cmsys::Status cmSystemTools::SetLogicalWorkingDirectory(std::string const& lwd)
+{
+  cmsys::Status status = cmSystemTools::ChangeDirectory(lwd);
+  if (status) {
+    cmSystemToolsLogicalWorkingDirectory = lwd;
+  }
+  return status;
+}
+
 std::string cmSystemTools::GetCurrentWorkingDirectory()
 {
   return cmSystemTools::CollapseFullPath(
diff --git a/Source/cmSystemTools.h b/Source/cmSystemTools.h
index c17ecbd3c4be72bd45c63fa6ce6a0c462f561f87..55542d4d216a82b7acc8e9cc1ab4fa5df400bb49 100644
--- a/Source/cmSystemTools.h
+++ b/Source/cmSystemTools.h
@@ -367,6 +367,14 @@ public:
   static std::string RelativeIfUnder(std::string const& top,
                                      std::string const& in);
 
+  /** Convert an input path to an absolute path with no '/..' components.
+      Backslashes in the input path are converted to forward slashes.
+      Relative paths are interpreted w.r.t. GetLogicalWorkingDirectory.
+      Input '/..' components, when preceded by symbolic links, may jump
+      to arbitrary destinations.  This transformation preserves as much
+      of the original logical path as possible.  */
+  static std::string CollapseLogicalPath(std::string in);
+
 #ifndef CMAKE_BOOTSTRAP
   /** Remove an environment variable */
   static bool UnsetEnv(const char* value);
@@ -459,6 +467,8 @@ public:
   static std::string const& GetCMClDepsCommand();
   static std::string const& GetCMakeRoot();
   static std::string const& GetHTMLDoc();
+  static std::string const& GetLogicalWorkingDirectory();
+  static cmsys::Status SetLogicalWorkingDirectory(std::string const& lwd);
 
   /** Get the CWD mapped through the KWSys translation map.  */
   static std::string GetCurrentWorkingDirectory();
diff --git a/Source/cmWorkingDirectory.cxx b/Source/cmWorkingDirectory.cxx
index 12fae1278cd0fa7f3c087b49e3c87a6f401bb668..c7bdeed0c259b777d7f59eea50f420419bbdd970 100644
--- a/Source/cmWorkingDirectory.cxx
+++ b/Source/cmWorkingDirectory.cxx
@@ -8,7 +8,7 @@
 
 cmWorkingDirectory::cmWorkingDirectory(std::string const& newdir)
 {
-  this->OldDir = cmSystemTools::GetCurrentWorkingDirectory();
+  this->OldDir = cmSystemTools::GetLogicalWorkingDirectory();
   this->SetDirectory(newdir);
 }
 
@@ -19,11 +19,12 @@ cmWorkingDirectory::~cmWorkingDirectory()
 
 bool cmWorkingDirectory::SetDirectory(std::string const& newdir)
 {
-  if (cmSystemTools::ChangeDirectory(newdir)) {
+  cmsys::Status status = cmSystemTools::SetLogicalWorkingDirectory(newdir);
+  if (status) {
     this->ResultCode = 0;
     return true;
   }
-  this->ResultCode = errno;
+  this->ResultCode = status.GetPOSIX();
   return false;
 }
 
diff --git a/Source/cmake.cxx b/Source/cmake.cxx
index 1c027adaa3312b17735a0eeedb7030ee869a26c2..f89a1bee898e0b4f73c7ce198a480edb85041db9 100644
--- a/Source/cmake.cxx
+++ b/Source/cmake.cxx
@@ -160,7 +160,7 @@ static void cmWarnUnusedCliWarning(const std::string& variable, int /*unused*/,
 #endif
 
 cmake::cmake(Role role, cmState::Mode mode, cmState::ProjectKind projectKind)
-  : CMakeWorkingDirectory(cmSystemTools::GetCurrentWorkingDirectory())
+  : CMakeWorkingDirectory(cmSystemTools::GetLogicalWorkingDirectory())
   , FileTimeCache(cm::make_unique<cmFileTimeCache>())
 #ifndef CMAKE_BOOTSTRAP
   , VariableWatch(cm::make_unique<cmVariableWatch>())
@@ -498,8 +498,8 @@ bool cmake::SetCacheArgs(const std::vector<std::string>& args)
     GetProjectCommandsInScriptMode(state->GetState());
     // Documented behavior of CMAKE{,_CURRENT}_{SOURCE,BINARY}_DIR is to be
     // set to $PWD for -P mode.
-    state->SetHomeDirectory(cmSystemTools::GetCurrentWorkingDirectory());
-    state->SetHomeOutputDirectory(cmSystemTools::GetCurrentWorkingDirectory());
+    state->SetHomeDirectory(cmSystemTools::GetLogicalWorkingDirectory());
+    state->SetHomeOutputDirectory(cmSystemTools::GetLogicalWorkingDirectory());
     state->ReadListFile(args, path);
     seenScriptOption = true;
     return true;
@@ -549,9 +549,8 @@ bool cmake::SetCacheArgs(const std::vector<std::string>& args)
           return false;
         }
         cmSystemTools::Stdout("loading initial cache file " + value + "\n");
-        // Resolve script path specified on command line
-        // relative to $PWD.
-        auto path = cmSystemTools::CollapseFullPath(value);
+        // Resolve script path specified on command line relative to $PWD.
+        auto path = cmSystemTools::CollapseLogicalPath(value);
         state->ReadListFile(args, path);
         return true;
       } },
@@ -640,7 +639,7 @@ void cmake::ReadListFile(const std::vector<std::string>& args,
     snapshot.SetDefaultDefinitions();
     cmMakefile mf(gg, snapshot);
     if (this->GetWorkingMode() != NORMAL_MODE) {
-      std::string file(cmSystemTools::CollapseFullPath(path));
+      std::string file(cmSystemTools::CollapseLogicalPath(path));
       cmSystemTools::ConvertToUnixSlashes(file);
       mf.SetScriptModeFile(file);
 
@@ -654,16 +653,16 @@ void cmake::ReadListFile(const std::vector<std::string>& args,
 
 bool cmake::FindPackage(const std::vector<std::string>& args)
 {
-  this->SetHomeDirectory(cmSystemTools::GetCurrentWorkingDirectory());
-  this->SetHomeOutputDirectory(cmSystemTools::GetCurrentWorkingDirectory());
+  this->SetHomeDirectory(cmSystemTools::GetLogicalWorkingDirectory());
+  this->SetHomeOutputDirectory(cmSystemTools::GetLogicalWorkingDirectory());
 
   this->SetGlobalGenerator(cm::make_unique<cmGlobalGenerator>(this));
 
   cmStateSnapshot snapshot = this->GetCurrentSnapshot();
   snapshot.GetDirectory().SetCurrentBinary(
-    cmSystemTools::GetCurrentWorkingDirectory());
+    cmSystemTools::GetLogicalWorkingDirectory());
   snapshot.GetDirectory().SetCurrentSource(
-    cmSystemTools::GetCurrentWorkingDirectory());
+    cmSystemTools::GetLogicalWorkingDirectory());
   // read in the list file to fill the cache
   snapshot.SetDefaultDefinitions();
   auto mfu = cm::make_unique<cmMakefile>(this->GetGlobalGenerator(), snapshot);
@@ -813,9 +812,7 @@ void cmake::SetArgs(const std::vector<std::string>& args)
       cmSystemTools::Error("No source directory specified for -S");
       return false;
     }
-    std::string path = cmSystemTools::CollapseFullPath(value);
-    cmSystemTools::ConvertToUnixSlashes(path);
-
+    std::string path = cmSystemTools::CollapseLogicalPath(value);
     state->SetHomeDirectoryViaCommandLine(path);
     return true;
   };
@@ -825,8 +822,7 @@ void cmake::SetArgs(const std::vector<std::string>& args)
       cmSystemTools::Error("No build directory specified for -B");
       return false;
     }
-    std::string path = cmSystemTools::CollapseFullPath(value);
-    cmSystemTools::ConvertToUnixSlashes(path);
+    std::string path = cmSystemTools::CollapseLogicalPath(value);
     state->SetHomeOutputDirectory(path);
     haveBArg = true;
     return true;
@@ -932,8 +928,7 @@ void cmake::SetArgs(const std::vector<std::string>& args)
                      CommandArgument::Values::One,
                      [](std::string const& value, cmake* state) -> bool {
                        std::string path =
-                         cmSystemTools::CollapseFullPath(value);
-                       cmSystemTools::ConvertToUnixSlashes(path);
+                         cmSystemTools::CollapseLogicalPath(value);
                        state->GraphVizFile = path;
                        return true;
                      } },
@@ -1109,8 +1104,7 @@ void cmake::SetArgs(const std::vector<std::string>& args)
     "--profiling-output", "No path specified for --profiling-output",
     CommandArgument::Values::One,
     [&](std::string const& value, cmake*) -> bool {
-      profilingOutput = cmSystemTools::CollapseFullPath(value);
-      cmSystemTools::ConvertToUnixSlashes(profilingOutput);
+      profilingOutput = cmSystemTools::CollapseLogicalPath(value);
       return true;
     });
   arguments.emplace_back("--preset", "No preset specified for --preset",
@@ -1267,10 +1261,10 @@ void cmake::SetArgs(const std::vector<std::string>& args)
   }
 
   if (!haveSourceDir) {
-    this->SetHomeDirectory(cmSystemTools::GetCurrentWorkingDirectory());
+    this->SetHomeDirectory(cmSystemTools::GetLogicalWorkingDirectory());
   }
   if (!haveBinaryDir) {
-    this->SetHomeOutputDirectory(cmSystemTools::GetCurrentWorkingDirectory());
+    this->SetHomeOutputDirectory(cmSystemTools::GetLogicalWorkingDirectory());
   }
 
 #if !defined(CMAKE_BOOTSTRAP)
@@ -1495,8 +1489,7 @@ bool cmake::SetDirectoriesFromFile(const std::string& arg)
   bool is_source_dir = false;
   bool is_empty_directory = false;
   if (cmSystemTools::FileIsDirectory(arg)) {
-    std::string path = cmSystemTools::CollapseFullPath(arg);
-    cmSystemTools::ConvertToUnixSlashes(path);
+    std::string path = cmSystemTools::CollapseLogicalPath(arg);
     std::string cacheFile = cmStrCat(path, "/CMakeCache.txt");
     std::string listFile = cmStrCat(path, "/CMakeLists.txt");
 
@@ -1511,7 +1504,7 @@ bool cmake::SetDirectoriesFromFile(const std::string& arg)
       is_source_dir = true;
     }
   } else if (cmSystemTools::FileExists(arg)) {
-    std::string fullPath = cmSystemTools::CollapseFullPath(arg);
+    std::string fullPath = cmSystemTools::CollapseLogicalPath(arg);
     std::string name = cmSystemTools::GetFilenameName(fullPath);
     name = cmSystemTools::LowerCase(name);
     if (name == "cmakecache.txt"_s) {
@@ -1522,7 +1515,7 @@ bool cmake::SetDirectoriesFromFile(const std::string& arg)
   } else {
     // Specified file or directory does not exist.  Try to set things
     // up to produce a meaningful error message.
-    std::string fullPath = cmSystemTools::CollapseFullPath(arg);
+    std::string fullPath = cmSystemTools::CollapseLogicalPath(arg);
     std::string name = cmSystemTools::GetFilenameName(fullPath);
     name = cmSystemTools::LowerCase(name);
     if (name == "cmakecache.txt"_s || name == "cmakelists.txt"_s) {
@@ -1562,14 +1555,14 @@ bool cmake::SetDirectoriesFromFile(const std::string& arg)
     if (is_source_dir) {
       this->SetHomeDirectoryViaCommandLine(listPath);
       if (no_build_tree) {
-        std::string cwd = cmSystemTools::GetCurrentWorkingDirectory();
-        this->SetHomeOutputDirectory(cwd);
+        this->SetHomeOutputDirectory(
+          cmSystemTools::GetLogicalWorkingDirectory());
       }
     } else if (no_source_tree && no_build_tree) {
       this->SetHomeDirectory(listPath);
 
-      std::string cwd = cmSystemTools::GetCurrentWorkingDirectory();
-      this->SetHomeOutputDirectory(cwd);
+      this->SetHomeOutputDirectory(
+        cmSystemTools::GetLogicalWorkingDirectory());
     } else if (no_build_tree) {
       this->SetHomeOutputDirectory(listPath);
     }
@@ -1577,18 +1570,18 @@ bool cmake::SetDirectoriesFromFile(const std::string& arg)
     if (no_source_tree) {
       // We didn't find a CMakeLists.txt and it wasn't specified
       // with -S. Assume it is the path to the source tree
-      std::string full = cmSystemTools::CollapseFullPath(arg);
+      std::string full = cmSystemTools::CollapseLogicalPath(arg);
       this->SetHomeDirectory(full);
     }
     if (no_build_tree && !no_source_tree && is_empty_directory) {
       // passed `-S <path> <build_dir> when build_dir is an empty directory
-      std::string full = cmSystemTools::CollapseFullPath(arg);
+      std::string full = cmSystemTools::CollapseLogicalPath(arg);
       this->SetHomeOutputDirectory(full);
     } else if (no_build_tree) {
       // We didn't find a CMakeCache.txt and it wasn't specified
       // with -B. Assume the current working directory as the build tree.
-      std::string cwd = cmSystemTools::GetCurrentWorkingDirectory();
-      this->SetHomeOutputDirectory(cwd);
+      this->SetHomeOutputDirectory(
+        cmSystemTools::GetLogicalWorkingDirectory());
       used_provided_path = false;
     }
   }
@@ -2088,7 +2081,6 @@ int cmake::Configure()
 int cmake::ActualConfigure()
 {
   // Construct right now our path conversion table before it's too late:
-  this->UpdateConversionPathTable();
   this->CleanupCommandsAndMacros();
 
   int res = this->DoPreConfigureChecks();
@@ -2806,31 +2798,6 @@ void cmake::PrintGeneratorList()
 #endif
 }
 
-void cmake::UpdateConversionPathTable()
-{
-  // Update the path conversion table with any specified file:
-  cmValue tablepath =
-    this->State->GetInitializedCacheValue("CMAKE_PATH_TRANSLATION_FILE");
-
-  if (tablepath) {
-    cmsys::ifstream table(tablepath->c_str());
-    if (!table) {
-      cmSystemTools::Error("CMAKE_PATH_TRANSLATION_FILE set to " + *tablepath +
-                           ". CMake can not open file.");
-      cmSystemTools::ReportLastSystemError("CMake can not open file.");
-    } else {
-      std::string a;
-      std::string b;
-      while (!table.eof()) {
-        // two entries per line
-        table >> a;
-        table >> b;
-        cmSystemTools::AddTranslationPath(a, b);
-      }
-    }
-  }
-}
-
 int cmake::CheckBuildSystem()
 {
   // We do not need to rerun CMake.  Check dependency integrity.
@@ -3077,7 +3044,7 @@ int cmake::GetSystemInformation(std::vector<std::string>& args)
 {
   // so create the directory
   std::string resultFile;
-  std::string cwd = cmSystemTools::GetCurrentWorkingDirectory();
+  std::string cwd = cmSystemTools::GetLogicalWorkingDirectory();
   std::string destPath = cwd + "/__cmake_systeminformation";
   cmSystemTools::RemoveADirectory(destPath);
   if (!cmSystemTools::MakeDirectory(destPath)) {
@@ -3307,8 +3274,8 @@ int cmake::Build(int jobs, std::string dir, std::vector<std::string> targets,
 
 #if !defined(CMAKE_BOOTSTRAP)
   if (!presetName.empty() || listPresets) {
-    this->SetHomeDirectory(cmSystemTools::GetCurrentWorkingDirectory());
-    this->SetHomeOutputDirectory(cmSystemTools::GetCurrentWorkingDirectory());
+    this->SetHomeDirectory(cmSystemTools::GetLogicalWorkingDirectory());
+    this->SetHomeOutputDirectory(cmSystemTools::GetLogicalWorkingDirectory());
 
     cmCMakePresetsGraph settingsFile;
     auto result = settingsFile.ReadProjectPresets(this->GetHomeDirectory());
diff --git a/Source/cmake.h b/Source/cmake.h
index c2bbff7b41c424aa598185e6179b5fd5bc04798b..8896d2ffe2947146f3266153ad21dca950f6a86f 100644
--- a/Source/cmake.h
+++ b/Source/cmake.h
@@ -737,8 +737,6 @@ private:
 
   std::unique_ptr<cmGlobalGenerator> GlobalGenerator;
 
-  void UpdateConversionPathTable();
-
   //! Print a list of valid generators to stderr.
   void PrintGeneratorList();
 
diff --git a/Source/cmakemain.cxx b/Source/cmakemain.cxx
index 41c6c125aaccb0e87e2fbd9a1aca4cd6419ad32b..e222663dc0e3c1bdcd6b77a36e1a7e5948396b9e 100644
--- a/Source/cmakemain.cxx
+++ b/Source/cmakemain.cxx
@@ -195,7 +195,7 @@ void cmakemainProgressCallback(const std::string& m, float prog, cmake* cm)
 
 int do_cmake(int ac, char const* const* av)
 {
-  if (cmSystemTools::GetCurrentWorkingDirectory().empty()) {
+  if (cmSystemTools::GetLogicalWorkingDirectory().empty()) {
     std::cerr << "Current working directory cannot be established."
               << std::endl;
     return 1;
@@ -534,7 +534,7 @@ int do_build(int ac, char const* const* av)
       inputArgs.reserve(ac - 2);
       cm::append(inputArgs, av + 2, av + ac);
     } else {
-      dir = cmSystemTools::CollapseFullPath(av[2]);
+      dir = cmSystemTools::CollapseLogicalPath(av[2]);
 
       inputArgs.reserve(ac - 3);
       cm::append(inputArgs, av + 3, av + ac);
@@ -813,7 +813,7 @@ int do_install(int ac, char const* const* av)
   };
 
   if (ac >= 3) {
-    dir = cmSystemTools::CollapseFullPath(av[2]);
+    dir = cmSystemTools::CollapseLogicalPath(av[2]);
 
     std::vector<std::string> inputArgs;
     inputArgs.reserve(ac - 3);
@@ -926,7 +926,7 @@ int do_open(int ac, char const* const* av)
   for (int i = 2; i < ac; ++i) {
     switch (doing) {
       case DoingDir:
-        dir = cmSystemTools::CollapseFullPath(av[i]);
+        dir = cmSystemTools::CollapseLogicalPath(av[i]);
         doing = DoingNone;
         break;
       default:
diff --git a/Source/cmcmd.cxx b/Source/cmcmd.cxx
index df740c9c20203836324906585bb5fe48a6e0e0cd..036739a380a2a66ee44f63150a88b795194816fc 100644
--- a/Source/cmcmd.cxx
+++ b/Source/cmcmd.cxx
@@ -1268,10 +1268,10 @@ int cmcmd::ExecuteCMakeCommand(std::vector<std::string> const& args,
 
       // Create a local generator configured for the directory in
       // which dependencies will be scanned.
-      homeDir = cmSystemTools::CollapseFullPath(homeDir);
-      startDir = cmSystemTools::CollapseFullPath(startDir);
-      homeOutDir = cmSystemTools::CollapseFullPath(homeOutDir);
-      startOutDir = cmSystemTools::CollapseFullPath(startOutDir);
+      homeDir = cmSystemTools::CollapseLogicalPath(homeDir);
+      startDir = cmSystemTools::CollapseLogicalPath(startDir);
+      homeOutDir = cmSystemTools::CollapseLogicalPath(homeOutDir);
+      startOutDir = cmSystemTools::CollapseLogicalPath(startOutDir);
       cm.SetHomeDirectory(homeDir);
       cm.SetHomeOutputDirectory(homeOutDir);
       cm.GetCurrentSnapshot().SetDefaultDefinitions();
@@ -2336,7 +2336,7 @@ int cmVSLink::LinkIncremental()
 
   // Create a resource file referencing the manifest.
   std::string absManifestFile =
-    cmSystemTools::CollapseFullPath(this->ManifestFile);
+    cmSystemTools::CollapseLogicalPath(this->ManifestFile);
   if (this->Verbose) {
     std::cout << "Create " << this->ManifestFileRC << "\n";
   }
diff --git a/Source/kwsys/CMakeLists.txt b/Source/kwsys/CMakeLists.txt
index 2253a83a9e1d80eebea782aef65e2ad702740868..731e704da2d43b30cdbf4d132ddb9b31d283bc64 100644
--- a/Source/kwsys/CMakeLists.txt
+++ b/Source/kwsys/CMakeLists.txt
@@ -432,14 +432,6 @@ if(KWSYS_USE_DynamicLoader)
 endif()
 
 if(KWSYS_USE_SystemTools)
-  if (NOT DEFINED KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP)
-    set(KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP 1)
-  endif ()
-  if (KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP)
-    set(KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP 1)
-  else ()
-    set(KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP 0)
-  endif ()
   KWSYS_PLATFORM_CXX_TEST(KWSYS_CXX_HAS_SETENV
     "Checking whether CXX compiler has setenv" DIRECT)
   KWSYS_PLATFORM_CXX_TEST(KWSYS_CXX_HAS_UNSETENV
diff --git a/Source/kwsys/Configure.hxx.in b/Source/kwsys/Configure.hxx.in
index 8d47340594560cee3e1505d7915ce6e58ccee0b5..b4b0efaa94d7c78da01b894b3d403faddcac748f 100644
--- a/Source/kwsys/Configure.hxx.in
+++ b/Source/kwsys/Configure.hxx.in
@@ -11,9 +11,6 @@
 /* Whether <ext/stdio_filebuf.h> is available. */
 #define @KWSYS_NAMESPACE@_CXX_HAS_EXT_STDIO_FILEBUF_H                         \
   @KWSYS_CXX_HAS_EXT_STDIO_FILEBUF_H@
-/* Whether the translation map is available or not. */
-#define @KWSYS_NAMESPACE@_SYSTEMTOOLS_USE_TRANSLATION_MAP                     \
-  @KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP@
 
 #if defined(__SUNPRO_CC) && __SUNPRO_CC > 0x5130 && defined(__has_attribute)
 #  define @KWSYS_NAMESPACE@_has_cpp_attribute(x) __has_attribute(x)
@@ -58,8 +55,6 @@
 #  define KWSYS_CXX_HAS_EXT_STDIO_FILEBUF_H                                   \
     @KWSYS_NAMESPACE@_CXX_HAS_EXT_STDIO_FILEBUF_H
 #  define KWSYS_FALLTHROUGH @KWSYS_NAMESPACE@_FALLTHROUGH
-#  define KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP                               \
-    @KWSYS_NAMESPACE@_SYSTEMTOOLS_USE_TRANSLATION_MAP
 #endif
 
 #endif
diff --git a/Source/kwsys/SystemTools.cxx b/Source/kwsys/SystemTools.cxx
index c38b456441d260c0b9af8d65c0e5785f6b204951..99954e19171111b9366a2b3290c1f7f3dc02a76c 100644
--- a/Source/kwsys/SystemTools.cxx
+++ b/Source/kwsys/SystemTools.cxx
@@ -521,13 +521,6 @@ class SystemToolsStatic
 {
 public:
   using StringMap = std::map<std::string, std::string>;
-#if KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP
-  /**
-   * Path translation table from dir to refdir
-   * Each time 'dir' will be found it will be replace by 'refdir'
-   */
-  StringMap TranslationMap;
-#endif
 #ifdef _WIN32
   static std::string GetCasePathName(std::string const& pathIn);
   static std::string GetActualCaseForPathCached(std::string const& path);
@@ -3373,72 +3366,6 @@ bool SystemTools::FindProgramPath(const char* argv0, std::string& pathOut,
   return true;
 }
 
-#if KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP
-void SystemTools::AddTranslationPath(const std::string& a,
-                                     const std::string& b)
-{
-  std::string path_a = a;
-  std::string path_b = b;
-  SystemTools::ConvertToUnixSlashes(path_a);
-  SystemTools::ConvertToUnixSlashes(path_b);
-  // First check this is a directory path, since we don't want the table to
-  // grow too fat
-  if (SystemTools::FileIsDirectory(path_a)) {
-    // Make sure the path is a full path and does not contain no '..'
-    // Ken--the following code is incorrect. .. can be in a valid path
-    // for example  /home/martink/MyHubba...Hubba/Src
-    if (SystemTools::FileIsFullPath(path_b) &&
-        path_b.find("..") == std::string::npos) {
-      // Before inserting make sure path ends with '/'
-      if (!path_a.empty() && path_a.back() != '/') {
-        path_a += '/';
-      }
-      if (!path_b.empty() && path_b.back() != '/') {
-        path_b += '/';
-      }
-      if (!(path_a == path_b)) {
-        SystemToolsStatics->TranslationMap.insert(
-          SystemToolsStatic::StringMap::value_type(std::move(path_a),
-                                                   std::move(path_b)));
-      }
-    }
-  }
-}
-
-void SystemTools::AddKeepPath(const std::string& dir)
-{
-  std::string cdir;
-  Realpath(SystemTools::CollapseFullPath(dir), cdir);
-  SystemTools::AddTranslationPath(cdir, dir);
-}
-
-void SystemTools::CheckTranslationPath(std::string& path)
-{
-  // Do not translate paths that are too short to have meaningful
-  // translations.
-  if (path.size() < 2) {
-    return;
-  }
-
-  // Always add a trailing slash before translation.  It does not
-  // matter if this adds an extra slash, but we do not want to
-  // translate part of a directory (like the foo part of foo-dir).
-  path += '/';
-
-  // In case a file was specified we still have to go through this:
-  // Now convert any path found in the table back to the one desired:
-  for (auto const& pair : SystemToolsStatics->TranslationMap) {
-    // We need to check of the path is a substring of the other path
-    if (path.compare(0, pair.first.size(), pair.first) == 0) {
-      path = path.replace(0, pair.first.size(), pair.second);
-    }
-  }
-
-  // Remove the trailing slash we added before.
-  path.pop_back();
-}
-#endif
-
 static void SystemToolsAppendComponents(
   std::vector<std::string>& out_components,
   std::vector<std::string>::iterator first,
@@ -3501,23 +3428,6 @@ std::string CollapseFullPathImpl(std::string const& in_path,
   // Transform the path back to a string.
   std::string newPath = SystemTools::JoinPath(out_components);
 
-#if KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP
-  // Update the translation table with this potentially new path.  I am not
-  // sure why this line is here, it seems really questionable, but yet I
-  // would put good money that if I remove it something will break, basically
-  // from what I can see it created a mapping from the collapsed path, to be
-  // replaced by the input path, which almost completely does the opposite of
-  // this function, the only thing preventing this from happening a lot is
-  // that if the in_path has a .. in it, then it is not added to the
-  // translation table. So for most calls this either does nothing due to the
-  // ..  or it adds a translation between identical paths as nothing was
-  // collapsed, so I am going to try to comment it out, and see what hits the
-  // fan, hopefully quickly.
-  // Commented out line below:
-  // SystemTools::AddTranslationPath(newPath, in_path);
-
-  SystemTools::CheckTranslationPath(newPath);
-#endif
 #ifdef _WIN32
   newPath = SystemToolsStatics->GetActualCaseForPathCached(newPath);
   SystemTools::ConvertToUnixSlashes(newPath);
@@ -4840,51 +4750,6 @@ void SystemTools::ClassInitialize()
 
   // Create statics singleton instance
   SystemToolsStatics = new SystemToolsStatic;
-
-#if KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP
-// Add some special translation paths for unix.  These are not added
-// for windows because drive letters need to be maintained.  Also,
-// there are not sym-links and mount points on windows anyway.
-#  if !defined(_WIN32) || defined(__CYGWIN__)
-  // The tmp path is frequently a logical path so always keep it:
-  SystemTools::AddKeepPath("/tmp/");
-
-  // If the current working directory is a logical path then keep the
-  // logical name.
-  std::string pwd_str;
-  if (SystemTools::GetEnv("PWD", pwd_str)) {
-    char buf[2048];
-    if (const char* cwd = Getcwd(buf, 2048)) {
-      // The current working directory may be a logical path.  Find
-      // the shortest logical path that still produces the correct
-      // physical path.
-      std::string cwd_changed;
-      std::string pwd_changed;
-
-      // Test progressively shorter logical-to-physical mappings.
-      std::string cwd_str = cwd;
-      std::string pwd_path;
-      Realpath(pwd_str, pwd_path);
-      while (cwd_str == pwd_path && cwd_str != pwd_str) {
-        // The current pair of paths is a working logical mapping.
-        cwd_changed = cwd_str;
-        pwd_changed = pwd_str;
-
-        // Strip off one directory level and see if the logical
-        // mapping still works.
-        pwd_str = SystemTools::GetFilenamePath(pwd_str);
-        cwd_str = SystemTools::GetFilenamePath(cwd_str);
-        Realpath(pwd_str, pwd_path);
-      }
-
-      // Add the translation to keep the logical path name.
-      if (!cwd_changed.empty() && !pwd_changed.empty()) {
-        SystemTools::AddTranslationPath(cwd_changed, pwd_changed);
-      }
-    }
-  }
-#  endif
-#endif
 }
 
 void SystemTools::ClassFinalize()
diff --git a/Source/kwsys/SystemTools.hxx.in b/Source/kwsys/SystemTools.hxx.in
index acce01570d2d01bb122dfe3400157da52a3ba8b1..b99760d98caa101de6c5e39a4e8410dd02e34a74 100644
--- a/Source/kwsys/SystemTools.hxx.in
+++ b/Source/kwsys/SystemTools.hxx.in
@@ -917,25 +917,6 @@ public:
    */
   static int GetTerminalWidth();
 
-#if @KWSYS_NAMESPACE@_SYSTEMTOOLS_USE_TRANSLATION_MAP
-  /**
-   * Add an entry in the path translation table.
-   */
-  static void AddTranslationPath(const std::string& dir,
-                                 const std::string& refdir);
-
-  /**
-   * If dir is different after CollapseFullPath is called,
-   * Then insert it into the path translation table
-   */
-  static void AddKeepPath(const std::string& dir);
-
-  /**
-   * Update path by going through the Path Translation table;
-   */
-  static void CheckTranslationPath(std::string& path);
-#endif
-
   /**
    * Delay the execution for a specified amount of time specified
    * in milliseconds
diff --git a/bootstrap b/bootstrap
index 98b59599122c30b0c27ca77cf474c19e932af174..259087ba7fa24a17cdf4a7f203c83f6a4351f355 100755
--- a/bootstrap
+++ b/bootstrap
@@ -792,7 +792,6 @@ cmake_kwsys_config_replace_string ()
               s/@KWSYS_NAME_IS_KWSYS@/${KWSYS_NAME_IS_KWSYS}/g;
               s/@KWSYS_STL_HAS_WSTRING@/${KWSYS_STL_HAS_WSTRING}/g;
               s/@KWSYS_CXX_HAS_EXT_STDIO_FILEBUF_H@/${KWSYS_CXX_HAS_EXT_STDIO_FILEBUF_H}/g;
-              s/@KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP@/${KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP}/g;
              }" "${INFILE}" >> "${OUTFILE}${_tmp}"
     if test -f "${OUTFILE}${_tmp}"; then
       if "${_diff}" "${OUTFILE}" "${OUTFILE}${_tmp}" > /dev/null 2> /dev/null ; then
@@ -1490,7 +1489,6 @@ KWSYS_CXX_HAS_UNSETENV=0
 KWSYS_CXX_HAS_ENVIRON_IN_STDLIB_H=0
 KWSYS_CXX_HAS_UTIMENSAT=0
 KWSYS_CXX_HAS_UTIMES=0
-KWSYS_SYSTEMTOOLS_USE_TRANSLATION_MAP=1
 
 if cmake_try_run "${cmake_cxx_compiler}" \
   "${cmake_cxx_flags} ${cmake_ld_flags} -DTEST_KWSYS_CXX_HAS_SETENV" \

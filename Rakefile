def discover_latest_sdk_version
  latest_iphone_sdk = `xcodebuild -showsdks | grep -o "iphoneos.*$"`.chomp
  version_part = latest_iphone_sdk[/iphoneos(.*)/,1]
  version_part
end

PRODUCT_NAME="Shelley"
PROJECT_PATH="#{PRODUCT_NAME}.xcodeproj"
SCHEME=PRODUCT_NAME
TEST_SCHEME="Shelley"

def build_project_for(arch)
  sdk = discover_latest_sdk_for(arch)
end

def build_project_for(arch)
  sdk = arch+discover_latest_sdk_version
  sh "xcodebuild -project #{PROJECT_PATH} -scheme #{SCHEME} -configuration Release -sdk #{sdk} BUILD_DIR=build clean build"
end

def build_osx_lib
  sh "xcodebuild -project #{PROJECT_PATH} -target ShelleyMac -configuration Release BUILD_DIR=build clean build"
end

desc "Build the arm library"
task :build_iphone_lib do
  build_project_for('iphoneos')
end

desc "Build the i386 library"
task :build_simulator_lib do
  build_project_for('iphonesimulator')
end

desc "Build the Mac library"
task :build_osx_lib do
    build_osx_lib
end

task :combine_libraries do
  lib_name = "lib#{PRODUCT_NAME}.a"
  `lipo -create -output "build/#{lib_name}" "build/Release-iphoneos/#{lib_name}" "build/Release-iphonesimulator/#{lib_name}"`
end

desc "clean build artifacts"
task :clean do
  rm_rf 'build'
end

desc "create build directory"
task :prep_build do
  mkdir_p 'build'
end

desc "Build a univeral library for both iphone and iphone simulator"
task :build_lib => [:clean, :prep_build, :build_iphone_lib,:build_simulator_lib,:combine_libraries,:build_osx_lib]

task :test do
  sh %Q|xctool ONLY_ACTIVE_ARCH=NO -project #{PROJECT_PATH} -scheme "#{TEST_SCHEME}" -sdk iphonesimulator test|
end

task :travis => [:test]

task :default => [:test, :build_lib]

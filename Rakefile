def discover_latest_sdk_version
  latest_iphone_sdk = `xcodebuild -showsdks | grep -o "iphoneos.*$"`.chomp
  version_part = latest_iphone_sdk[/iphoneos(.*)/,1]
  version_part
end

PRODUCT_NAME="Shelley"
PRODUCT_VERSION=File.read("version").strip
VERSION_FLAGS="OTHER_CFLAGS='-DPRODUCT_NAME=#{PRODUCT_NAME} -DPRODUCT_VERSION=#{PRODUCT_VERSION}'"
WORKSPACE_PATH="#{PRODUCT_NAME}.xcodeproj/project.xcworkspace"
PROJECT_PATH="#{PRODUCT_NAME}.xcodeproj"
SCHEME=PRODUCT_NAME

def build_project_for(arch)
  sdk = discover_latest_sdk_for(arch)
end

def build_project_for(arch)
  sdk = arch+discover_latest_sdk_version
  sh "xcodebuild -project #{PROJECT_PATH} -scheme #{SCHEME} -configuration Release -sdk #{sdk} #{VERSION_FLAGS} BUILD_DIR=build clean build"
end

desc "Build the arm library"
task :build_iphone_lib do
  build_project_for('iphoneos')
end

desc "Build the i386 library"
task :build_simulator_lib do
  build_project_for('iphonesimulator')
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
task :build_lib => [:clean, :prep_build, :build_iphone_lib,:build_simulator_lib,:combine_libraries]

task :default => :build_lib

$generator ="Visual Studio 15 2017"

function RecreateDir([string] $path)
{
	If (Test-Path $path) {
		Remove-Item -Recurse -Force $path
	}

	mkdir $path -force | Out-Null
}

function CMakeBuild([string]$lib, [string]$platform, [string]$config)
{
	$gen = $generator
	if($platform -eq "x64")  {
		$gen = $generator + " Win64"
	}

	$current_dir = $PWD
	$build_dir = "$PWD\build\$platform\$config\$lib\"
	$install_dir = "$PWD\$platform\$config\$lib\"
	$source_dir = "$PWD\sources\$lib\"
	RecreateDir $build_dir
	RecreateDir $install_dir

	# cmake gen
	cd $build_dir
	cmake -G "$gen" -DCMAKE_INSTALL_PREFIX="$install_dir" $args $source_dir

	# cmake build & install
	cmake --build . --config $config --target INSTALL

	cd $current_dir
}

# zlib
CMakeBuild zlib x64 release
CMakeBuild zlib x64 debug
CMakeBuild zlib x86 release
CMakeBuild zlib x86 debug

# libpng
CMakeBuild libpng x64 release -DZLIB_LIBRARY="$PWD\x64\release\zlib\lib\zlib.lib" -DZLIB_INCLUDE_DIR="$PWD\x64\release\zlib\include\"
CMakeBuild libpng x64 debug -DZLIB_LIBRARY="$PWD\x64\debug\zlib\lib\zlibd.lib" -DZLIB_INCLUDE_DIR="$PWD\x64\debug\zlib\include\"
CMakeBuild libpng x86 release -DZLIB_LIBRARY="$PWD\x86\release\zlib\lib\zlib.lib" -DZLIB_INCLUDE_DIR="$PWD\x86\release\zlib\include\"
CMakeBuild libpng x86 debug -DZLIB_LIBRARY="$PWD\x86\debug\zlib\lib\zlibd.lib" -DZLIB_INCLUDE_DIR="$PWD\x86\debug\zlib\include\"

# libjpeg
cp jpeg_build\* sources\jpeg\
CMakeBuild jpeg x64 release
CMakeBuild jpeg x64 debug
CMakeBuild jpeg x86 release
CMakeBuild jpeg x86 debug

# tiff
CMakeBuild tiff x64 release -DZLIB_LIBRARY="$PWD\x64\release\zlib\lib\zlib.lib" -DZLIB_INCLUDE_DIR="$PWD\x64\release\zlib\include\" -DJPEG_LIBRARY="$PWD\x64\release\jpeg\lib\libjpeg.lib" -DJPEG_INCLUDE_DIR="$PWD\x64\release\jpeg\include\"
CMakeBuild tiff x64 debug -DZLIB_LIBRARY="$PWD\x64\debug\zlib\lib\zlibd.lib" -DZLIB_INCLUDE_DIR="$PWD\x64\debug\zlib\include\" -DJPEG_LIBRARY="$PWD\x64\debug\jpeg\lib\libjpeg.lib" -DJPEG_INCLUDE_DIR="$PWD\x64\debug\jpeg\include\"
CMakeBuild tiff x86 release -DZLIB_LIBRARY="$PWD\x86\release\zlib\lib\zlib.lib" -DZLIB_INCLUDE_DIR="$PWD\x86\release\zlib\include\" -DJPEG_LIBRARY="$PWD\x86\release\jpeg\lib\libjpeg.lib" -DJPEG_INCLUDE_DIR="$PWD\x86\release\jpeg\include\"
CMakeBuild tiff x86 debug -DZLIB_LIBRARY="$PWD\x86\debug\zlib\lib\zlibd.lib" -DZLIB_INCLUDE_DIR="$PWD\x86\debug\zlib\include\" -DJPEG_LIBRARY="$PWD\x86\debug\jpeg\lib\libjpeg.lib" -DJPEG_INCLUDE_DIR="$PWD\x86\debug\jpeg\include\"

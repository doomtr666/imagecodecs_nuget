# unzip function
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

# download
function Download
{
	param([string]$url, [string]$path)
	Invoke-WebRequest -Uri $url -OutFile $path -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox
}

# create build dir
If (Test-Path sources) {
	Remove-Item -Recurse -Force sources
}

mkdir sources | Out-Null
cd sources

# zlib 1.2.11
echo "Fetching zlib 1.2.11"
Download "https://zlib.net/zlib1211.zip" "zlib1211.zip"
Unzip "$PWD\zlib1211.zip" "$PWD"
rni zlib-1.2.11 zlib
rm zlib1211.zip

# libpng 1.6.30
echo "Fetching libpng 1.6.30"
Download "http://prdownloads.sourceforge.net/libpng/lpng1630.zip?download" "lpng1630.zip"
Unzip "$PWD\lpng1630.zip" "$PWD"
rni lpng1630 libpng
rm lpng1630.zip

# jpeg v9b
echo "Fetching jpeg v9b"
Download "http://www.ijg.org/files/jpegsr9b.zip" "jpegsr9b.zip"
Unzip "$PWD\jpegsr9b.zip" "$PWD"
rni jpeg-9b jpeg
rm jpegsr9b.zip

# tiff 4.0.8
echo "Fetching tiff 4.0.8"
Download "ftp://download.osgeo.org/libtiff/tiff-4.0.8.zip" tiff-4.0.8.zip
Unzip "$PWD\tiff-4.0.8.zip" "$PWD"
rni tiff-4.0.8 tiff
rm tiff-4.0.8.zip

cd ..


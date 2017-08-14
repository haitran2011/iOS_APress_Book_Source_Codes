=====================================================================
= Your Own Content Pipeline: Importing 3D Art Assets into Your      =
=                            iPhone Game                            =
= More iPhone Cool Projects                                         =
= by Claus Hšfele <claus@claushoefele.com>                          =
=                                                                   =
= Content Pipeline Demo v1.2 (April 4, 2010)                        =
=====================================================================

For up-to-date information regarding this chapter, please visit the publisher's web site (http://www.apress.com/) and my homepage (http://www.claushoefele.com).

1. Welcome
============================

This code package is the demo application for the above mentioned chapter in More iPhone Cool Projects. The demo contains a converter tool for Mac OS X to turn art assets into an efficient in-game format and an iPhone demo that renders some sample 3D models converted with this tool. The code was developed using Xcode 3.2.1, iPhone SDK 3.1.2, and FBX SDK 2010.2.

I hope you find this project useful.

2. Directory structure
============================

assets      -> Original art assets exported from content creation tools
\-converted -> Art assets in iPhone format
converter   -> Command-line tool to convert FBX and PNG files
lib         -> External libraries
\-fbx       -> FBX SDK 2010.2 (http://www.autodesk.com/fbx)
\-libpng    -> PNG encoding/decoding library v1.2.40 (http://www.libpng.org/pub/png/libpng.html)
\-pvrtexlib -> PVRTexLib POWERVR SDK 2.05.25.0803 (http://www.imgtec.com/powervr/insider/sdkdownloads/index.asp)
\-zlib      -> zlib compression v1.2.3 (http://www.zlib.net/)
opengl      -> iPhone demo that displays 3D models
src         -> Reusable C++ code for file conversion  

3. Building from source
============================

Before building this project, you need to install the latest Xcode and iPhone SDK (http://developer.apple.com/iphone/).

- converter: command-line tool to convert FBX and PNG files into in-game format.

For licensing reasons, the demo project doesn't come with the FBX SDK included (it's also a fairly large file). Instead, you'll have to download the latest FBX SDK from http://www.autodesk.com/fbx. After installing the FBX SDK, its contents will be in the folder /Applications/Autodesk/<FBX SDK>.

Copy /Applications/Autodesk/<FBX SDK>/lib/libfbxsdk_gcc4_ub.a to lib/fbx in the demo project. Also copy all header files from /Applications/Autodesk/<FBX SDK>/include to lib/fbx/include.

You'll find the Xcode project file in converter/converter.xcodeproj. After the build process is complete, the tool can be run from the command line in Mac OS X and takes an output directory and the input files as options. The Xcode project is setup to convert the files in the assets directory and write the result to the directory assets/converted (right click on the executable in Xcode and select Arguments to see the command line options used).

- opengl: iPhone demo that renders converted art assets.

The project file is in opengl/opengl.xcodeproj and the app reads the art assets from assets/converted by default. Note: because of a bug in Xcode, newly converted art assets in subfolders are not always copied to the iPhone app's target directory. To make sure that all files are up-to-date, select Build > Clean All Targets in Xcode and rebuild the project.

4. License & Acknowledgments
============================

I release the code in this demo into the public domain. I'd be happy if you credited me as the original author when using the code, but it's up to you.

The art assets are copyright Dimitri Kanis (http://sydneystripe.com/).

libpng is Copyright (c) 2004, 2006-2007 Glenn Randers-Pehrson under distributed under the libpng license (http://www.libpng.org/pub/png/src/libpng-LICENSE.txt).

zlib is Copyright (C) 1995-2005 Jean-loup Gailly and Mark Adler and distributed under the zlib license (http://www.zlib.net/zlib_license.html).

Autodesk FBX SDK 2010.2 is Copyright (C) Autodesk; see lib/fbx/License.rtf for details.

PVRTexLib 2.05.25.0803 is Copyright (C) Imagination Technologies Ltd; see lib/pvrtexlib/LegalNotice.txt for details.

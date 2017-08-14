//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#include "PvrtcResourceWriter.h"

#include <resource/Image.h>
#include <system/Assert.h>

#include <PVRTexLib.h>

using namespace pvrtexlib;

namespace
{
  //------------------------------------------------------------------------------
  size_t ComputeMaxMipmaps(size_t width, size_t height)
  {
    size_t maxNumMipmaps = 0;
    do
    {
      width >>= 1;
      height >>= 1;
      maxNumMipmaps++;
    } while (width || height);
    
    return --maxNumMipmaps;
  }
}

//------------------------------------------------------------------------------
bool PvrtcResourceWriter::open(const char* fileName)
{
  bool result = (strlen(fileName) <= (sizeof(m_FileName) - 1));
  ASSERT_M(result, "File name too long.");
  if (result)
  {
    strncpy(m_FileName, fileName, sizeof(m_FileName));
  }

  return result;
}

//------------------------------------------------------------------------------
void PvrtcResourceWriter::close()
{
}

//------------------------------------------------------------------------------
bool PvrtcResourceWriter::write(const Image& image)
{
  ASSERT_M(image.getFormat() == Image::R8G8B8A8, "Input image must be RGBA.");
  ASSERT_M(image.getHeight() == image.getWidth(), "Input image must be square.");
  ASSERT_M(image.getHeight() >= 32, "Input image must be at least 32x32 pixels.");
  
  bool result = true;
  PVRTRY
  {
    // Wrap RGBA data in PVR structure.
    CPVRTexture originalTexture(image.getWidth(), image.getHeight(), 
      0 /*num mipmaps*/, 1 /*num surfaces*/, false /*border*/, 
      false /*twiddled*/, false /*cube map*/, false /*volume*/,
      false /*false mips*/, false /*has alpha*/, m_FlipVertically /*vertically flipped*/,
      eInt8StandardPixelType, 0.0f /*normal map*/, (uint8*)image.getData());
    
    // Apply transformations
    CPVRTextureHeader processHeader(originalTexture.getHeader());
    const size_t maxMipmaps = m_GenerateMipMaps ? ComputeMaxMipmaps(image.getWidth(), 
      image.getHeight()) : 0;
    processHeader.setMipMapCount(maxMipmaps);
    PVRTextureUtilities* pvrTextureUtilities = PVRTextureUtilities::getPointer();
    pvrTextureUtilities->ProcessRawPVR(originalTexture, processHeader);
    
    // Compress to PVRTC
    CPVRTexture compressedTexture(originalTexture.getHeader());
    compressedTexture.setPixelType(m_TwoBppEnabled ? OGL_PVRTC2 : OGL_PVRTC4);
    pvrTextureUtilities->CompressPVR(originalTexture, compressedTexture);
    compressedTexture.setAlpha(m_AlphaModeEnabled);
    compressedTexture.setTwiddled(true);
    compressedTexture.writeToFile(m_FileName);
  }
  PVRCATCH(exception)
  {
    // Handle any exceptions here
    result = false;
  }

  return result;
}
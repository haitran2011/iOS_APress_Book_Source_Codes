//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#include "Image.h"

#include <system/Assert.h>

#include <cmath>

//------------------------------------------------------------------------------
void Image::init(ImageFormat format, size_t width, size_t height, int numMipmaps)
{
  if (format == YUV420p)
  {
    ASSERT_M((width % 2 == 0) && (height % 2 == 0), 
             "YUV420p: width/height must be even so that chroma samples line up.");
    ASSERT_M((width >= 4) && (height >= 4), 
             "YUV420p: minimum width/height is 4.");
  }

  size_t oldNumBytes = m_Data ? getNumBytes() : 0; // only valid before overwriting members
  m_Height = height;
  m_Width = width;
  m_Format = format;

  // Find maximum number of mipmaps for the given width and height.
  size_t maxNumMipmaps = 0;
  do
  {
    width >>= 1;
    height >>= 1;
    maxNumMipmaps++;
  } while (width || height);
  maxNumMipmaps--;
  
  if (numMipmaps < 0)
  {
    // Automatically use max number of mip maps.
    m_NumMipmaps = maxNumMipmaps;
  }
  else 
  {
    // Clamp to max number of mipmaps.
    size_t numMipmapsU = static_cast<size_t>(numMipmaps);
    m_NumMipmaps = (numMipmapsU > maxNumMipmaps) ? maxNumMipmaps : numMipmapsU;
  }

  // Only allocate memory if the new data won't fit into the existing memory.
  size_t newNumBytes = getNumBytes();
  if (newNumBytes > oldNumBytes)
  {
    delete[] m_Data;
    m_Data = new uint8_t[newNumBytes];
  }
}

//------------------------------------------------------------------------------
uint8_t* Image::getData(size_t mipMapLevel)
{
  ASSERT_M(mipMapLevel <= getNumMipmaps(), "Invalid mip map level.");
  
  size_t numBytesOffset = 0;
  size_t width = m_Width;
  size_t height = m_Height;
  while (mipMapLevel--)
  {
    numBytesOffset += static_cast<size_t>(ceil(width * height * 
      getBytesPerPixel()));
    width = (width == 1) ? 1 : width >> 1;
    height = (height == 1) ? 1 : height >> 1;
  }
 
  return m_Data + numBytesOffset;
}

//------------------------------------------------------------------------------
const uint8_t* Image::getData(size_t /*mipMapLevel*/) const 
{ 
  return m_Data;
}

//------------------------------------------------------------------------------
size_t Image::getNumBytes() const 
{ 
  size_t width = m_Width;
  size_t height = m_Height;
  float bytesPerPixel = getBytesPerPixel();
  int numMipmaps = m_NumMipmaps;
  float numBytes = 0.0f;
  do
  {
    numBytes += width * height * bytesPerPixel;
    width = (width == 1) ? 1 : width >> 1;
    height = (height == 1) ? 1 : height >> 1;
  }
  while((width != 1 || height != 1) && numMipmaps--);
  
  if (numMipmaps > 0)
  {
    numBytes += 1;
  }
  
  return static_cast<size_t>(ceil(numBytes));
}

//------------------------------------------------------------------------------
float Image::getBytesPerPixel() const 
{
  const float bytesPerPixel[] = {
    1.0f,  // L8
    2.0f,  // L8A8
    3.0f,  // R8G8B8
    4.0f,  // R8G8B8A8
    3.0f,  // B8G8R8
    4.0f,  // B8G8R8A8
    1.5f,  // YUV420p
    0.5f,  // PVRTC_4BPP
    0.25f, // PVRTC_2BPP,
    0.5f,  // PVRTC_4BPPA,
    0.25f  // PVRTC_2BPPA
  };
  
  return bytesPerPixel[m_Format];
}

//------------------------------------------------------------------------------
uint8_t Image::getNumChannels() const
{
  const uint8_t numChannels[] = {
    1,  // L8
    2,  // L8A8
    3,  // R8G8B8
    4,  // R8G8B8A8
    3,  // B8G8R8
    4,  // B8G8R8A8
    3,  // YUV420p
    3,  // PVRTC_4BPP
    3,  // PVRTC_2BPP,
    4,  // PVRTC_4BPPA,
    4   // PVRTC_2BPPA
  };
  
  return numChannels[m_Format];
}

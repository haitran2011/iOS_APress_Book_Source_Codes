//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#include "PvrtcResourceReader.h"
#include "../Image.h"

#include <system/Assert.h>

#include <cstdio>
#include <stdint.h>

using namespace std;

// http://developer.apple.com/iPhone/library/samplecode/PVRTextureLoader/listing8.html

//------------------------------------------------------------------------------
namespace 
{
  const char PVRTC_IDENTIFIER[4] = { 'P', 'V', 'R', '!' };
  
  enum
  {
    PVRTC_FLAG_TYPE_2 = 24,
    PVRTC_FLAG_TYPE_4
  };
  
  struct PvrtcHeader
  {
    uint32_t headerLength;
    uint32_t height;
    uint32_t width;
    uint32_t numMipmaps;
    uint32_t flags;
    uint32_t dataLength;
    uint32_t bpp;
    uint32_t bitmaskRed;
    uint32_t bitmaskGreen;
    uint32_t bitmaskBlue;
    uint32_t bitmaskAlpha;
    uint32_t pvrTag;
    uint32_t numSurfs;
  };
}

//------------------------------------------------------------------------------
bool PvrtcResourceReader::open(const char* fileName)
{
  // This code assumes it runs on a little endian system.
  PvrtcHeader header;
  memset(&header, 0, sizeof(PvrtcHeader));
  m_File = fopen(fileName, "rb");
  bool result = (m_File != NULL);
  if (result)
  {
    fread(&header, sizeof(PvrtcHeader), 1, m_File);
    
    // Check it's a PVR texture.
    int idCheck = memcmp(&header.pvrTag, PVRTC_IDENTIFIER, sizeof(PVRTC_IDENTIFIER));
    result = (idCheck == 0);
    
    // Cubemaps not yet supported.
    result &= (header.numSurfs == 1);

    // PVRTC 2 + 4 only
    int format = header.flags & 0xff;
    bool hasAlpha = (header.bitmaskAlpha != 0);
    if (format == PVRTC_FLAG_TYPE_2)
    {
      m_ImageFormat = hasAlpha ? Image::PVRTC_2BPPA : Image::PVRTC_2BPP;
    }
    else if (format == PVRTC_FLAG_TYPE_4)
    {
      m_ImageFormat = hasAlpha ? Image::PVRTC_4BPPA : Image::PVRTC_4BPP;      
    }
    else 
    {
      result = false;
    }
  }
  
  if (result)
  {
    m_Width = header.width;
    m_Height = header.height;
    m_NumMipMaps = header.numMipmaps;
    m_DataSize = header.dataLength;
  }
  
  return result;
}

//------------------------------------------------------------------------------
bool PvrtcResourceReader::read(Image& image)
{
  ASSERT_M(m_File != NULL, "Invalid file.");
  ASSERT_M(image.getFormat() == Image::PVRTC_2BPPA ||
           image.getFormat() == Image::PVRTC_2BPP ||
           image.getFormat() == Image::PVRTC_4BPPA ||
           image.getFormat() == Image::PVRTC_4BPP, "Invalid image format.");
  
  uint8_t* data = image.getData();
//  fread(data, m_DataSize, 1, m_File);
  fread(data, image.getNumBytes(), 1, m_File);
  
  return true;  
}

//------------------------------------------------------------------------------
void PvrtcResourceReader::close()
{
  if (m_File != NULL) 
  {
    fclose(m_File);
    m_File = NULL;
  }
}

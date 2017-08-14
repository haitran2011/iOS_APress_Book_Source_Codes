//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#ifndef RESOURCE_IMAGE_H
#define RESOURCE_IMAGE_H

#include <stdint.h>
#include <cstdio>

//==============================================================================
// Declarations
//==============================================================================

/** Origin: lower, left corner */
class Image
{
public:
  
  /** Image format. */
  enum ImageFormat
  {
    L8 = 0,       ///< 8 bit grayscale.
    L8A8,         ///< 8 bit grayscale + 8 bit alpha interleaved.
    R8G8B8,       ///< 8 bit RGB interleaved.
    R8G8B8A8,     ///< 8 bit RGBA interleaved
    B8G8R8,       ///< 8 bit BGR interleaved
    B8G8R8A8,     ///< 8 bit BGRA interleaved
    YUV420p,      ///< 8 bit YUV planar, subsampled to 4:2:0.
    PVRTC_4BPP,   ///< Imagination PowerVR 4 BPP.
    PVRTC_2BPP,   ///< Imagination PowerVR 2 BPP.
    PVRTC_4BPPA,  ///< Imagination PowerVR 4 BPP (alpha).
    PVRTC_2BPPA   ///< Imagination PowerVR 2 BPP (alpha).
  };

  /** Constructor. */
  inline Image();
  
  /** 
   * Allocates memory for a new image.
   * @param format image format.
   * @param width width.
   * @param height height.
   * @param numMipmaps number of mipmaps (in addition to the base level). A 
   *                   negative value will result in the maximum number of mip
   *                   maps achievable with the width and height settings. 
   *                   Positive values will be clamped to this maximum. 
   */
  inline Image(ImageFormat format, size_t width, size_t height, int numMipmaps = 0);

  /** Destructor. */
  inline ~Image();

  /** 
   * Allocates memory for a new image.
   * @param format image format.
   * @param width width.
   * @param height height.
   * @param numMipmaps number of mipmaps (in addition to the base level). A 
   *                   negative value will result in the maximum number of mip
   *                   maps achievable with the width and height settings. 
   *                   Positive values will be clamped to this maximum. 
   */
  void init(ImageFormat format, size_t width, size_t height, int numMipmaps = 0);

  //@{
  /** Getter/setter. */
  inline size_t getNumMipmaps() const;
  inline size_t getWidth() const;
  inline size_t getHeight() const;
  inline ImageFormat getFormat() const;
  //@}

  /**
   * Returns data for the given mip map level.
   * @param mipMapLevel mip map level (0 = base data).
   * @return data
   */
  uint8_t* getData(size_t mipMapLevel = 0);
  
  /**
   * Returns data for the given mip map level.
   * @param mipMapLevel mip map level (0 = base data).
   * @return data
   */
  const uint8_t* getData(size_t mipMapLevel = 0) const;

  /**
   * Returns the number bytes the image occupies in memory.
   * @return number of bytes.
   */
  size_t getNumBytes() const;

  /**
   * Returns the number bytes a pixel occupies in memory.
   * @return number of bytes.
   */
  float getBytesPerPixel() const;

  /**
   * Returns the number of bitplanes of the image.
   * @return number of bitplanes.
   */
  uint8_t getNumChannels() const;
  
private:

  uint8_t* m_Data;      ///< Memory for image data.
  size_t m_Width;       ///< The image's width.
  size_t m_Height;      ///< The image's height.
  size_t m_NumMipmaps;  ///< Number of mipmaps in addition to base texture.
  ImageFormat m_Format; ///< Image format.
};

//==============================================================================
// Inline Methods
//==============================================================================

//------------------------------------------------------------------------------
inline Image::Image()
  : m_Data(NULL)
  , m_Width(0)
  , m_Height(0)
  , m_NumMipmaps(0)
  , m_Format(Image::L8)
{
}

//------------------------------------------------------------------------------
inline Image::Image(ImageFormat format, size_t width, size_t height, int numMipmaps)
  : m_Data(NULL)
  , m_Width(width)
  , m_Height(height)
  , m_NumMipmaps(0)
  , m_Format(format)
{
  init(format, width, height, numMipmaps);
}

//------------------------------------------------------------------------------
inline Image::~Image()
{ 
  delete[] m_Data; 
}

//------------------------------------------------------------------------------
inline size_t Image::getNumMipmaps() const 
{ 
  return m_NumMipmaps; 
}

//------------------------------------------------------------------------------
inline size_t Image::getWidth() const 
{ 
  return m_Width; 
}

//------------------------------------------------------------------------------
inline size_t Image::getHeight() const 
{ 
  return m_Height; 
}

//------------------------------------------------------------------------------
inline Image::ImageFormat Image::getFormat() const
{ 
  return m_Format; 
}

#endif // RESOURCE_IMAGE_H

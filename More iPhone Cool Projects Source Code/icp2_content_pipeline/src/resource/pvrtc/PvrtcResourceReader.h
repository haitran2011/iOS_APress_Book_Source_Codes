//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#ifndef RESOURCE_PVRTC_RESOURCE_READER_H
#define RESOURCE_PVRTC_RESOURCE_READER_H

#include <string>
#include "../Image.h"

//==============================================================================
// Declarations
//==============================================================================

/** Reader for Imagination's PVRTC image format. */
class PvrtcResourceReader
{

public:

  /** Constructor. */
  inline PvrtcResourceReader();
  
  /** Destructor. */
  inline ~PvrtcResourceReader();

  /**
   * Opens the file with the given name for reading.
   * @param fileName file name.
   * @return true if successful; false otherwise.
   */
  bool open(const char* fileName);
  
  /**
   * Reads image.
   * @param image image data.
   * @return true if successful; false otherwise.
   */
  bool read(Image& image);
  
  /** Closes file and ends reading. */
  void close();

  //@{
  /** Getter/setter. */
  inline size_t getWidth() const;
  inline size_t getHeight() const;
  inline size_t getNumMipMaps() const;
  inline Image::ImageFormat getImageFormat() const;
  //@}

private:

  FILE* m_File;                         ///< File handle.
  size_t m_Width;                       ///< Width of image.
  size_t m_Height;                      ///< Height of image.
  size_t m_NumMipMaps;                  ///< Number of mip maps.
  size_t m_DataSize;                    ///< Data size.
  Image::ImageFormat m_ImageFormat;     ///< Image format.
};

//==============================================================================
// Inline Methods
//==============================================================================

//------------------------------------------------------------------------------
inline PvrtcResourceReader::PvrtcResourceReader()
  : m_File(NULL)
  , m_Width(0)
  , m_Height(0)
  , m_NumMipMaps(0)
  , m_DataSize(0)
  , m_ImageFormat(Image::PVRTC_2BPP)
{
  
}

//------------------------------------------------------------------------------
inline PvrtcResourceReader::~PvrtcResourceReader()
{
  close();
}

//------------------------------------------------------------------------------
inline size_t PvrtcResourceReader::getWidth() const
{
  return m_Width;
}

//------------------------------------------------------------------------------
inline size_t PvrtcResourceReader::getHeight() const
{
  return m_Height;
}

//------------------------------------------------------------------------------
inline size_t PvrtcResourceReader::getNumMipMaps() const
{
  return m_NumMipMaps;
}

//------------------------------------------------------------------------------
inline Image::ImageFormat PvrtcResourceReader::getImageFormat() const
{
  return m_ImageFormat;
}

#endif // RESOURCE_PVRTC_RESOURCE_READER_H

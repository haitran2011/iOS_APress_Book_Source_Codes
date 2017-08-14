//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#ifndef RESOURCE_PVRTC_PVRTCRESOURCEWRITER_H
#define RESOURCE_PVRTC_PVRTCRESOURCEWRITER_H

#include <fbxfilesdk/fbxfilesdk_def.h>  // defines the namespace for FBX
#include <vector>

//==============================================================================
// Forward Declarations
//==============================================================================

class Image;

//==============================================================================
// Declarations
//==============================================================================

/** Writes out images in Imagination's PVRTC format. */
class PvrtcResourceWriter
{
public:

  /** Constructor. */
  inline PvrtcResourceWriter();

  /** Destructor. */
  inline ~PvrtcResourceWriter();

  /** 
   * Sets options used when processing images.
   * @param generateMipMaps generate mip maps before writing image.
   * @param 2bppEnabled true for 2 bpp or false for 4 bpp mode.
   * @param alphaModeEnabled alpha mode flag.
   * @param flipVertically true to flip image vertically (set to true for OpenGL).
   */
  inline void setOptions(bool generateMipMaps, bool twoBppEnabled, 
    bool alphaModeEnabled, bool flipVertically);

  /**
   * Opens the file with the given name for writing. Note: file name must end
   * with '.pvr'.
   * @param fileName file name.
   * @return true if successful; false otherwise.
   */
  bool open(const char* fileName);

  /** Closes file and ends writing. */
  void close();

  /** 
   * Writes image. Note: image must be RGBA, square, and at least 32x32 pixels
   * in size.
   * @return true if successful; false otherwise.
   */
  bool write(const Image& image);

private:

  char m_FileName[512];     ///< Current file name.
  bool m_GenerateMipMaps;   ///< Flag to generate mip maps.
  bool m_TwoBppEnabled;     ///< 2 bpp or 4 bpp mode.
  bool m_AlphaModeEnabled;  ///< Alpha mode flag.
  bool m_FlipVertically;    ///< Flip vertically flag.
};

//==============================================================================
// Inline Methods
//==============================================================================

//------------------------------------------------------------------------------
inline PvrtcResourceWriter::PvrtcResourceWriter()
  : m_GenerateMipMaps(true)
  , m_TwoBppEnabled(true)
  , m_AlphaModeEnabled(true)
  , m_FlipVertically(true)
{
  m_FileName[0] = '\0';
}

//------------------------------------------------------------------------------
inline PvrtcResourceWriter::~PvrtcResourceWriter()
{
  close();
}

//------------------------------------------------------------------------------
inline void PvrtcResourceWriter::setOptions(bool generateMipMaps, 
  bool twoBppEnabled, bool alphaModeEnabled, bool flipVertically)
{
  m_GenerateMipMaps = generateMipMaps;
  m_TwoBppEnabled = twoBppEnabled;
  m_AlphaModeEnabled = alphaModeEnabled;
  m_FlipVertically = flipVertically;
}

#endif // RESOURCE_PVRTC_PVRTCRESOURCEWRITER_H

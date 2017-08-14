//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#ifndef RESOURCE_PNG_RESOURCE_READER_H
#define RESOURCE_PNG_RESOURCE_READER_H

#include <string>

//==============================================================================
// Forward Declarations
//==============================================================================

class Image;

//==============================================================================
// Declarations
//==============================================================================
class PngResourceReader
{

public:

  /** Constructor. */
  PngResourceReader();
  
  /** Destructor. */
  ~PngResourceReader();
  
  /**
   * Opens the file with the given name for reading.
   * @param fileName file name.
   * @return true if successful; false otherwise.
   */
  bool open(const std::string& fileName);
  
  /**
   * Decodes a PNG image into RGB or RGBA format.
   * @param image resulting image.
   * @return true if successful; false otherwise.
   */
  bool read(Image& image);

  /** Closes the file and ends decoding. */
  void close();

private:

  FILE* m_File;   ///< File handle.
};

#endif // RESOURCE_PNG_RESOURCE_READER_H

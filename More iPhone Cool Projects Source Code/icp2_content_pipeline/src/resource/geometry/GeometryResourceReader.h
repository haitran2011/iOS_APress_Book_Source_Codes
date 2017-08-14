//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#ifndef RESOURCE_GEOMETRYRESOURCEREADER_H
#define RESOURCE_GEOMETRYRESOURCEREADER_H

#include <stdint.h>

//==============================================================================
// Forward Declarations
//==============================================================================

class Geometry;

//==============================================================================
// Declarations
//==============================================================================

/** Reader for custom geometry format. */
class GeometryResourceReader
{

public:

  /** Constructor. */
  GeometryResourceReader();
  
  /** Destructor. */
  ~GeometryResourceReader();

  /**
   * Opens the file with the given name for reading.
   * @param fileName file name.
   * @return true if successful; false otherwise.
   */  
  bool open(const char* fileName);

  /** Closes file and ends reading. */
  void close();

  //@{
  /** Writes resource. */
  bool read(Geometry& geometry, uint32_t resourceId);
  //@}
  
private:

  char m_FileName[256];   ///< Current file name.
};

//==============================================================================
// Inline Methods
//==============================================================================

#endif // RESOURCE_GEOMETRYRESOURCEREADER_H

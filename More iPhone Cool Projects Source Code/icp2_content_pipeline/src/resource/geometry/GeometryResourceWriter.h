//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#ifndef RESOURCE_GEOMETRYRESOURCEWRITER_H
#define RESOURCE_GEOMETRYRESOURCEWRITER_H

#include <cstdio>
#include <stdint.h>

//==============================================================================
// Forward Declarations
//==============================================================================

class Geometry;

//==============================================================================
// Declarations
//==============================================================================

/** Writer for custom resource format. */
class GeometryResourceWriter
{

public:

  /** Constructor. */
  GeometryResourceWriter();
  
  /** Destructor. */
  ~GeometryResourceWriter();

  /**
   * Opens the file with the given name for writing.
   * @param fileName file name.
   * @return true if successful; false otherwise.
   */  
  bool open(const char* fileName);
  
  /** Closes file and ends writing. */
  void close();

  //@{
  /** Writes resource. */
  bool write(const Geometry& geometry, uint32_t resourceId, const char* comment = NULL);
  //@}

private:

  char m_FileName[256];   ///< Current file name.
};

//==============================================================================
// Inline Methods
//==============================================================================

#endif // RESOURCE_GEOMETRYRESOURCEWRITER_H

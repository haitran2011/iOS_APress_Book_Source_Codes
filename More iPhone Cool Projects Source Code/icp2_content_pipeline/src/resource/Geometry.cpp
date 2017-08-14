//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#include "Geometry.h"

using namespace std;

//------------------------------------------------------------------------------
void Geometry::freeMemory()
{
  // Swap trick to trim excess capacity.
  vector<Vertex>().swap(m_Vertices);
  vector<Index>().swap(m_Indices);
}

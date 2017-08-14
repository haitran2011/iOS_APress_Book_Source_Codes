//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#include "GeometryResourceReader.h"

#include <resource/Geometry.h>
#include <system/Assert.h>

#include <cstdio>
#include <cstring>
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

using namespace std;

//------------------------------------------------------------------------------
namespace
{
  void skipComment(FILE* file, char* buffer, int bufferSize)
  {
    do 
    {
      fgets(buffer, bufferSize, file);
    } while (buffer[0] == '/' && buffer[1] == '/');
  }
}

//------------------------------------------------------------------------------
GeometryResourceReader::GeometryResourceReader()
{
  m_FileName[0] = '\0';
}

//------------------------------------------------------------------------------
GeometryResourceReader::~GeometryResourceReader()
{
  close();
}

//------------------------------------------------------------------------------
bool GeometryResourceReader::open(const char* fileName)
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
void GeometryResourceReader::close()
{
}

//------------------------------------------------------------------------------
bool GeometryResourceReader::read(Geometry& geometry, uint32_t resourceId)
{
  bool result = false;

  char fileName[sizeof(m_FileName) + 16];
  snprintf(fileName, sizeof(fileName), "%s/geometry/%08x", m_FileName, resourceId);
  FILE* file = fopen(fileName, "r");
  ASSERT_M(file != NULL, "Can't open file '%s'.", fileName);
  
  if (file != NULL)
  {
    char buffer[256];

    // Comment (leaves current line in buffer)
    skipComment(file, buffer, sizeof(buffer));
    
    // Geometry data
    uint32_t primitiveType = 0, numVertices = 0, numIndices = 0;
    sscanf(buffer, "geometry %d %d %d\n", &primitiveType, 
      &numVertices, &numIndices);
    geometry.setPrimitiveType(static_cast<Geometry::PrimitiveType>(primitiveType));
    geometry.setNumIndices(numIndices);
    
    // Vertices
    vector<Geometry::Vertex>& vertices = geometry.getVertices();
    vertices.resize(numVertices);
    for (size_t i = 0; i < vertices.size(); i++)
    {
      Geometry::Vertex& vertex = vertices[i];
      fgets(buffer, sizeof(buffer), file);
      sscanf(buffer, "%f %f %f\n", 
        &vertex.position[0], &vertex.position[1], &vertex.position[2]);
      fgets(buffer, sizeof(buffer), file);
      sscanf(buffer, "%f %f %f\n", 
        &vertex.normal[0], &vertex.normal[1], &vertex.normal[2]);
      fgets(buffer, sizeof(buffer), file);
      sscanf(buffer, "%f %f\n", &vertex.uv0[0], &vertex.uv0[1]);
    }

    // Indices
    vector<Geometry::Index>& indices = geometry.getIndices();
    indices.resize(numIndices);
    for (size_t i = 0; i < indices.size(); i++)
    {
      uint32_t index = 0;
      fgets(buffer, sizeof(buffer), file);
      sscanf(buffer, "%d\n", &index);
      indices[i] = index;
    }
    
    fclose(file);
    result = true;
  }
 
  return result;
}

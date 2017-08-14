//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#include "GeometryResourceWriter.h"

#include <resource/Geometry.h>
#include <system/Assert.h>

#include <string>
#include <sys/stat.h>
#include <cerrno>
#include <ctime>
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

using namespace std;

//------------------------------------------------------------------------------
namespace
{
  void writeComment(FILE* file, char* buffer, int bufferSize, const char* comment)
  {
    time_t rawtime;
    time(&rawtime);
    const char* time = ctime(&rawtime);   // ctime appends '\n'
    snprintf(buffer, bufferSize, "// %s", time);
    fputs(buffer, file);
    if (comment != NULL)
    {
      snprintf(buffer, bufferSize, "// %s\n", comment);
      fputs(buffer, file);
    }
  }
  
  bool createDirectory(const string& dirPath)
  {
    // Move by one if the path is absolute.
    size_t pos = 0;
    if (dirPath.find_first_of("/\\", pos, 1) == 0)
    {
      pos++;
    }
    
    // Create each directory in the tree.
    for (;;)
    {
      const size_t end = dirPath.find_first_of("/\\", pos);
      const string dirName(dirPath, 0, end);
      
      const int result = mkdir(dirName.c_str(), S_IRWXU | (S_IRGRP | S_IXGRP) | (S_IROTH | S_IXOTH));
      if (result != 0 && errno != EEXIST)  // existing directory is not a failure
      {
        return false;
      }
      
      if (end == string::npos)
      {
        return true;
      }

      pos = end + 1;
    }
  }
}

//------------------------------------------------------------------------------
GeometryResourceWriter::GeometryResourceWriter()
{
  m_FileName[0] = '\0';
}

//------------------------------------------------------------------------------
GeometryResourceWriter::~GeometryResourceWriter()
{
  close();
}

//------------------------------------------------------------------------------
bool GeometryResourceWriter::open(const char* fileName)
{
  bool result = (strlen(fileName) <= (sizeof(m_FileName) - 1));
  ASSERT_M(result, "File name too long.");
  if (result)
  {
    strncpy(m_FileName, fileName, sizeof(m_FileName));
    result = createDirectory(fileName);
  }

  return result;
}

//------------------------------------------------------------------------------
void GeometryResourceWriter::close()
{
}

//------------------------------------------------------------------------------
bool GeometryResourceWriter::write(const Geometry& geometry, uint32_t resourceId,
  const char* comment)
{
  bool result = false;
  
  char dirName[sizeof(m_FileName) + 16];
  snprintf(dirName, sizeof(dirName), "%s/geometry", m_FileName);
  char fileName[sizeof(dirName) + 16];
  snprintf(fileName, sizeof(fileName), "%s/%08x", dirName, resourceId++);

  FILE* file = NULL;
  createDirectory(dirName);
  file = fopen(fileName, "w");
  result = (file != NULL);
  ASSERT_M(result, "Can't open file '%s'.", fileName);
  
  if (result)
  {
    char buffer[256];

    // Comment
    writeComment(file, buffer, sizeof(buffer), comment);

    // Geometry data
    snprintf(buffer, sizeof(buffer), "geometry %d %d %d\n", 
      geometry.getPrimitiveType(), geometry.getVertices().size(), 
      geometry.getIndices().size());
    fputs(buffer, file);
    
    // Vertices
    const vector<Geometry::Vertex>& vertices = geometry.getVertices();
    for (size_t i = 0; i < vertices.size(); i++)
    {
      const Geometry::Vertex& vertex = vertices[i];
      snprintf(buffer, sizeof(buffer), "%f %f %f\n", 
        vertex.position[0], vertex.position[1], vertex.position[2]);
      fputs(buffer, file);
      snprintf(buffer, sizeof(buffer), "%f %f %f\n", 
        vertex.normal[0], vertex.normal[1], vertex.normal[2]);
      fputs(buffer, file);
      snprintf(buffer, sizeof(buffer), "%f %f\n", 
        vertex.uv0[0], vertex.uv0[1], vertex.uv0[2]);
      fputs(buffer, file);
    }
    
    // Indices
    const vector<Geometry::Index>& indices = geometry.getIndices();
    for (size_t i = 0; i < indices.size(); i++)
    {
      const Geometry::Index& index = indices[i];
      snprintf(buffer, sizeof(buffer), "%d\n", index);
      fputs(buffer, file);
    }

    fclose(file);
    result = true;
  }
  
  return result;
}

//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#ifndef RESOURCE_GEOMETRY_H
#define RESOURCE_GEOMETRY_H

#include <system/Assert.h>

#include <vector>
#include <stdint.h>

//==============================================================================
// Forward Declarations
//==============================================================================

//==============================================================================
// Declarations
//==============================================================================

/** Container for vertex data. */
class Geometry
{
public:
  
  /** Vertex declaration. */
  struct Vertex 
  {
    float position[3];
    float normal[3];
    float uv0[2];
  };
  
  /** Index declaration. */
  typedef uint16_t Index;  

  /** Type of primitives to render. */
  enum PrimitiveType
  {
    PT_TriangleList =  0,   ///< List of triangles.
    PT_LineList,            ///< List of lines.
    PT_PointList,           ///< List of points.
  };
  
  /** Type of vertex data. */
  enum VertexType
  {
    VT_Float = 0,           ///< Float (4 bytes).
    VT_UnsignedByte         ///< Unsigned byte (1 byte).
  };
  
  /** Type of index data. */
  enum IndexType
  {
    IT_UnsignedShort        ///< Unsigned short (2 bytes).
  };

  /** Constructor. */
  inline Geometry();
  
  /** 
   * Releases memory associated with memory buffers, but keeps the buffer 
   * information intact. This can be used to free up memory if a renderer 
   * supports vertex buffers. 
   */
  void freeMemory();

  //@{
  /** Setter/getter for render data attached to a memory buffer. */
  template<typename RenderData>
  inline void setMemoryBufferRenderData(int8_t index, RenderData renderData);
  template<typename RenderData>
  inline RenderData getMemoryBufferRenderData(int8_t index) const;
  //@}

  //@{
  /** Setter/getter. */
  inline std::vector<Vertex>& getVertices();
  inline const std::vector<Vertex>& getVertices() const;
  inline unsigned getVertexBufferId() const;
  inline void setVertexBufferId(unsigned vertexBufferId);
  inline std::vector<Index>& getIndices();
  inline const std::vector<Index>& getIndices() const;
  inline size_t getNumIndices() const;
  inline void setNumIndices(size_t numIndices);
  inline unsigned getIndexBufferId() const;
  inline void setIndexBufferId(unsigned vertexBufferId);
  inline void setPrimitiveType(PrimitiveType primitiveType);
  inline PrimitiveType getPrimitiveType() const;
  //@}
  
private:

  std::vector<Vertex> m_Vertices;       ///< Vertices.
  std::vector<Index> m_Indices;         ///< Indices.
  unsigned m_VertexBufferId;            ///< OpenGL VBO ID.
  unsigned m_IndexBufferId;             ///< OpenGL VBO ID.
  size_t m_NumIndices;                  ///< Number of indices to render.
  PrimitiveType m_PrimitiveType;        ///< Type of primitives to render.
};

//==============================================================================
// Inline Methods
//==============================================================================

//------------------------------------------------------------------------------
inline Geometry::Geometry()
  : m_Vertices()
  , m_Indices()
  , m_VertexBufferId(-1)
  , m_IndexBufferId(-1)
  , m_PrimitiveType(PT_TriangleList)
{
}

//------------------------------------------------------------------------------
inline std::vector<Geometry::Vertex>& Geometry::getVertices()
{
  return m_Vertices;
}

//------------------------------------------------------------------------------
inline const std::vector<Geometry::Vertex>& Geometry::getVertices() const
{
  return m_Vertices;  
}

//------------------------------------------------------------------------------
inline unsigned Geometry::getVertexBufferId() const 
{
  return m_VertexBufferId;
}

//------------------------------------------------------------------------------
inline void Geometry::setVertexBufferId(unsigned vertexBufferId)
{
  m_VertexBufferId = vertexBufferId;
}

//------------------------------------------------------------------------------
inline std::vector<Geometry::Index>& Geometry::getIndices()
{
  return m_Indices;
}

//------------------------------------------------------------------------------
inline const std::vector<Geometry::Index>& Geometry::getIndices() const
{
  return m_Indices;
}

//------------------------------------------------------------------------------
inline unsigned Geometry::getIndexBufferId() const 
{
  return m_IndexBufferId;
}

//------------------------------------------------------------------------------
inline void Geometry::setIndexBufferId(unsigned indexBufferId)
{
  m_IndexBufferId = indexBufferId;
}

//------------------------------------------------------------------------------
inline size_t Geometry::getNumIndices() const 
{
  return m_NumIndices;
}

//------------------------------------------------------------------------------
inline void Geometry::setNumIndices(size_t numIndices)
{
  m_NumIndices = numIndices;
}

//------------------------------------------------------------------------------
inline void Geometry::setPrimitiveType(PrimitiveType primitiveType) 
{
  m_PrimitiveType = primitiveType;
}

//------------------------------------------------------------------------------
inline Geometry::PrimitiveType Geometry::getPrimitiveType() const
{
  return m_PrimitiveType;
}

#endif // RESOURCE_GEOMETRY_H

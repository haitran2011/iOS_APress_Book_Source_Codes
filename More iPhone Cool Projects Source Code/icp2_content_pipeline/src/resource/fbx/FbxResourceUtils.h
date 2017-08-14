//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#ifndef RESOURCE_FBX_FBXRESOURCEUTILS_H
#define RESOURCE_FBX_FBXRESOURCEUTILS_H

#include <resource/Geometry.h>

#include <fbxfilesdk/kfbxmath/kfbxvector4.h>
#include <fbxfilesdk/kfbxmath/kfbxvector2.h>
#include <fbxfilesdk/kfbxmath/kfbxxmatrix.h>
#include <fbxfilesdk/kfbxplugins/kfbxcolor.h>
#include <fbxfilesdk/fbxfilesdk_def.h>  // defines the namespace for FBX
#include <vector>

//==============================================================================
// Forward Declarations
//==============================================================================

namespace FBXFILESDK_NAMESPACE
{
  class KFbxMesh;
}

//==============================================================================
// Declarations
//==============================================================================
namespace FbxResourceUtils
{
  /** Predicate to compare two vertices. */
  struct VertexPredicate
  {
    /** Returns true if two vertices are equal. */
    bool operator()(const Geometry::Vertex& other);

    Geometry::Vertex currentVertex;     ///< Current vertex.
    float epsilon;            ///< Difference that two floating-point values can
                              //   be apart, but still compare equal.
  };

  //@{
  /** Extract information from a polygon. */
  void getPolygonVertexPosition(const FBXFILESDK_NAMESPACE::KFbxMesh& fbxMesh, 
    int polyIndex, int vertexIndex, FBXFILESDK_NAMESPACE::KFbxVector4& position);
  void getPolygonVertexNormal(const FBXFILESDK_NAMESPACE::KFbxMesh& fbxMesh, 
    int polyIndex, int vertexIndex, FBXFILESDK_NAMESPACE::KFbxVector4& normal);
  void getPolygonVertexUv(const FBXFILESDK_NAMESPACE::KFbxMesh& fbxMesh, 
    int layer, int polyIndex, int vertexIndex, FBXFILESDK_NAMESPACE::KFbxVector2& uv);
  //@}

  /**
   * Returns vertex data associated with the given mesh.
   * @param fbxMesh mesh to use.
   * @param vertexPredicate predicate to use.
   * @param vertices resulting vertex data.
   * @param indices resulting vertex indices.
   */
  void processTriangles(const FBXFILESDK_NAMESPACE::KFbxMesh& fbxMesh, 
    std::vector<Geometry::Vertex>& vertices, std::vector<Geometry::Index>& indices);
}

#endif // RESOURCE_FBX_FBXRESOURCEUTILS_H

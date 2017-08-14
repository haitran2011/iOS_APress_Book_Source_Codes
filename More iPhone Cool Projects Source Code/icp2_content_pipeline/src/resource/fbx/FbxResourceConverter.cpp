//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#include "FbxResourceConverter.h"
#include "FbxResourceUtils.h"

#include <system/Assert.h>

#include <cmath>
#include <vector>
#include <algorithm>
#include <functional>

#include <fbxsdk.h>

using namespace std;

//------------------------------------------------------------------------------
bool FbxResourceConverter::convert(KFbxMesh& fbxMeshIn, Geometry& geometry) const
{
  ASSERT_M(fbxMeshIn.GetNode() != NULL, "Invalid mesh.");
  ASSERT_M(fbxMeshIn.GetControlPoints() != NULL, "No position data.");
  ASSERT_M(fbxMeshIn.GetControlPointsCount() <= 65536, 
    "Only 16-bit indices supported.");

  // Reserve memory.
  vector<Geometry::Vertex>& vertices = geometry.getVertices();
  vector<Geometry::Index>& indices = geometry.getIndices();
  vertices.reserve(fbxMeshIn.GetControlPointsCount());
  indices.reserve(fbxMeshIn.GetPolygonCount() * 3);
  
  // Make sure all geometry is converted into triangles.
  KFbxMesh* newFbxMesh = NULL;
  if (!fbxMeshIn.IsTriangleMesh())
  {
    KFbxGeometryConverter geometryConverter(m_SdkManager);
    newFbxMesh = geometryConverter.TriangulateMesh(&fbxMeshIn);
  }
  const KFbxMesh& fbxMesh = newFbxMesh ? *newFbxMesh : fbxMeshIn;
  const int numTrianglesFbx = fbxMesh.GetPolygonCount();
  
  // Extract per-vertex data.
  FbxResourceUtils::processTriangles(fbxMesh, vertices, indices);
  ASSERT_M((int)indices.size() == numTrianglesFbx * 3, "Invalid number of indices.");
  
  if (newFbxMesh != NULL)
  {
    // Release temporary data.
    newFbxMesh->Destroy();
  }
  geometry.setPrimitiveType(Geometry::PT_TriangleList);
  geometry.setNumIndices(indices.size());

  return true;
}

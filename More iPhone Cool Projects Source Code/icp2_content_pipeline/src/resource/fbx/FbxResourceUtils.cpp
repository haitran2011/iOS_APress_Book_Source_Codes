//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#include "FbxResourceUtils.h"

#include <system/Assert.h>

#include <algorithm>
#include <cmath>
#include <fbxsdk.h>
#include <functional>

using namespace std;

//------------------------------------------------------------------------------
bool FbxResourceUtils::VertexPredicate::operator()(const Geometry::Vertex& other)
{
  bool result = 
    fabs(currentVertex.position[0] - other.position[0]) < epsilon &&
    fabs(currentVertex.position[1] - other.position[1]) < epsilon &&
    fabs(currentVertex.position[2] - other.position[2]) < epsilon;
  result &= 
    fabs(currentVertex.normal[0] - other.normal[0]) < epsilon &&
    fabs(currentVertex.normal[1] - other.normal[1]) < epsilon &&
    fabs(currentVertex.normal[2] - other.normal[2]) < epsilon;
  result &= 
    fabs(currentVertex.uv0[0] - other.uv0[0]) < epsilon &&
    fabs(currentVertex.uv0[1] - other.uv0[1]) < epsilon;
  return result;
}

//------------------------------------------------------------------------------
void FbxResourceUtils::getPolygonVertexPosition(const KFbxMesh& fbxMesh, 
  int polyIndex, int vertexIndex, KFbxVector4& position)
{
  int positionIndex = fbxMesh.GetPolygonVertex(polyIndex, vertexIndex);
  const KFbxVector4* fbxPositions = fbxMesh.GetControlPoints();
  position = fbxPositions[positionIndex];
}

//------------------------------------------------------------------------------
void FbxResourceUtils::getPolygonVertexNormal(const KFbxMesh& fbxMesh, 
  int polyIndex, int vertexIndex, KFbxVector4& normal)
{
  normal = KFbxVector4(0.0, 1.0, 0.0, 0.0);
  fbxMesh.GetPolygonVertexNormal(polyIndex, vertexIndex, normal);
}

//------------------------------------------------------------------------------
void FbxResourceUtils::getPolygonVertexUv(const KFbxMesh& fbxMesh, int layer, 
  int polyIndex, int vertexIndex, KFbxVector2 &uv)
{
  const KFbxLayerElementUV* uvSet = fbxMesh.GetLayer(layer)->GetUVs();
  ASSERT_M(uvSet != NULL, "No UV data on layer %d.", layer);
  ASSERT_M(uvSet->GetMappingMode() == KFbxLayerElement::eBY_CONTROL_POINT ||
    uvSet->GetMappingMode() == KFbxLayerElement::eBY_POLYGON_VERTEX, 
    "Invalid mapping mode for UV data on layer %d.", layer);

  switch (uvSet->GetMappingMode())
  {
  case KFbxLayerElement::eBY_CONTROL_POINT:
    {
      int uvIndex = fbxMesh.GetPolygonVertex(polyIndex, vertexIndex);
      uv = uvSet->GetDirectArray().GetAt(uvIndex);
    }
    break;
  case KFbxLayerElement::eBY_POLYGON_VERTEX:
    {
      KFbxMesh fbxMeshNoConst = const_cast<KFbxMesh&>(fbxMesh); // bug?
      int uvIndex = fbxMeshNoConst.GetTextureUVIndex(polyIndex, vertexIndex);
      uv = uvSet->GetDirectArray().GetAt(uvIndex);
    }
    break;
  default:
    break;
  }
}

//------------------------------------------------------------------------------
void FbxResourceUtils::processTriangles(const KFbxMesh& fbxMesh, 
  vector<Geometry::Vertex>& vertices, vector<Geometry::Index>& indices)
{
  // Functor to help compare vertices.
  VertexPredicate vertexPredicate;
  vertexPredicate.epsilon = 0.001f;

  // Loop through triangles to extract a list of vertices with per-vertex
  // data. This normalizes the various ways in which FBX stores mesh data.
  const int numTrianglesFbx = fbxMesh.GetPolygonCount();
  for (int triangleIndex = 0; triangleIndex < numTrianglesFbx; triangleIndex++)
  {
    for(int cornerIndex = 0; cornerIndex < 3; cornerIndex++)
    {
      // Vertex position
      KFbxVector4 position;
      FbxResourceUtils::getPolygonVertexPosition(fbxMesh, triangleIndex, 
        cornerIndex, position);
      vertexPredicate.currentVertex.position[0] = (float)position[0];
      vertexPredicate.currentVertex.position[1] = (float)position[1];
      vertexPredicate.currentVertex.position[2] = (float)position[2];

      KFbxVector4 normal;
      FbxResourceUtils::getPolygonVertexNormal(fbxMesh, triangleIndex, 
        cornerIndex, normal);
      vertexPredicate.currentVertex.normal[0] = (float)normal[0];
      vertexPredicate.currentVertex.normal[1] = (float)normal[1];
      vertexPredicate.currentVertex.normal[2] = (float)normal[2];
      
      // Vertex UV0
      KFbxVector2 uv0;
      FbxResourceUtils::getPolygonVertexUv(fbxMesh, 0, triangleIndex, 
        cornerIndex, uv0);
      vertexPredicate.currentVertex.uv0[0] = (float)uv0[0];
      vertexPredicate.currentVertex.uv0[1] = (float)uv0[1];

      // Re-index vertices to remove duplicate vertices.
      vector<Geometry::Vertex>::iterator existingVertex = 
        find_if(vertices.begin(), vertices.end(), vertexPredicate);
      size_t index = existingVertex - vertices.begin();
      if (index == vertices.size()) // new vertex?
      {
        vertices.push_back(vertexPredicate.currentVertex);
      }
      indices.push_back(index);
    }
  }
}

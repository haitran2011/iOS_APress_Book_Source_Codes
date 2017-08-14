//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#ifndef RESOURCE_FBX_FBXRESOURCECONVERTER_H
#define RESOURCE_FBX_FBXRESOURCECONVERTER_H

#include <resource/Geometry.h>

#include <fbxfilesdk/fbxfilesdk_def.h>  // defines the namespace for FBX
#include <vector>

//==============================================================================
// Forward Declarations
//==============================================================================

namespace FBXFILESDK_NAMESPACE
{
  class KFbxSdkManager;
  class KFbxMesh;
}
namespace FbxResourceUtils
{
  struct VertexPredicate;
}
class Geometry;

//==============================================================================
// Declarations
//==============================================================================

/** Converts FBX scene nodes into data compatible with the 2: Engine. */
class FbxResourceConverter
{
public:

  /** 
   * Creates a new FBX converter. 
   * @param sdkManager FBX SDK manager to use.
   */
  inline FbxResourceConverter(FBXFILESDK_NAMESPACE::KFbxSdkManager* sdkManager);
  
  //@{
  /** Conversion routines. */
  bool convert(FBXFILESDK_NAMESPACE::KFbxMesh& fbxMesh, Geometry& geometry) const;
  //@}

private:

  FBXFILESDK_NAMESPACE::KFbxSdkManager* m_SdkManager; ///< FBX SDK manager.
};

//==============================================================================
// Inline Methods
//==============================================================================

//------------------------------------------------------------------------------
inline FbxResourceConverter::FbxResourceConverter(FBXFILESDK_NAMESPACE::KFbxSdkManager* sdkManager)
  : m_SdkManager(sdkManager)
{
}

#endif // RESOURCE_FBX_FBXRESOURCECONVERTER_H

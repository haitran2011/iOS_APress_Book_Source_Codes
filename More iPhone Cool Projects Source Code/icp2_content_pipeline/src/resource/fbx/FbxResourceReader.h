//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#ifndef RESOURCE_FBX_FBXRESOURCEREADER_H
#define RESOURCE_FBX_FBXRESOURCEREADER_H

#include <fbxfilesdk/fbxfilesdk_def.h>  // defines the namespace for FBX

//==============================================================================
// Forward Declarations
//==============================================================================

namespace FBXFILESDK_NAMESPACE
{
  class KFbxImporter;
  class KFbxScene;
  class KFbxSdkManager;
}

//==============================================================================
// Declarations
//==============================================================================

/** FBX file reader. */
class FbxResourceReader
{
public:

  /** Creates a new resource reader. */
  FbxResourceReader();

  /** Destructor. */
  ~FbxResourceReader();

  /**
   * Opens the given file and reads in the scene contents.
   * @param fileName file name.
   * @return true if the file was read successfully, false otherwise.
   */
  bool open(const char* fileName);

  /** Resets the current scene. */
  void close();

  //@{
  /** Getter/setter. */
  inline FBXFILESDK_NAMESPACE::KFbxSdkManager* getSdkManager();
  inline FBXFILESDK_NAMESPACE::KFbxScene* getScene();
  //@}

private:

  FBXFILESDK_NAMESPACE::KFbxSdkManager* m_SdkManager; ///< SDK manager for FBX API.
  FBXFILESDK_NAMESPACE::KFbxScene* m_Scene;           ///< Current scene.
  FBXFILESDK_NAMESPACE::KFbxImporter* m_Importer;     ///< Importer to load files.
};

//==============================================================================
// Inline Methods
//==============================================================================

//------------------------------------------------------------------------------
inline FBXFILESDK_NAMESPACE::KFbxSdkManager* FbxResourceReader::getSdkManager()
{
  return m_SdkManager;
}

//------------------------------------------------------------------------------
inline FBXFILESDK_NAMESPACE::KFbxScene* FbxResourceReader::getScene()
{
  return m_Scene;
}

#endif // RESOURCE_FBX_FBXRESOURCEREADER_H

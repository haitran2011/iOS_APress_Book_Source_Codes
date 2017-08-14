//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#include "FbxResourceReader.h"
#include "FbxResourceUtils.h"

#include <system/Assert.h>

#include <fbxsdk.h>

//------------------------------------------------------------------------------
FbxResourceReader::FbxResourceReader()
  : m_SdkManager(KFbxSdkManager::Create())
  , m_Scene(KFbxScene::Create(m_SdkManager, ""))
  , m_Importer(KFbxImporter::Create(m_SdkManager, ""))
{
}

//------------------------------------------------------------------------------
FbxResourceReader::~FbxResourceReader()
{
  close();

  // Fixes some memory leaks with 2010.2.
  IOSREF.FreeIOSettings();

  // Delete the FBX SDK manager. All the objects that have been allocated 
  // using the FBX SDK manager and that haven't been explicitly destroyed 
  // are automatically destroyed at the same time.
  if (m_SdkManager != NULL)
  {
    m_SdkManager->Destroy();
  }
}

//------------------------------------------------------------------------------
bool FbxResourceReader::open(const char* fileName)
{
  close();

  // Initialize the importer with a file name.
  bool result = m_Importer->Initialize(fileName);

  if (result)
  {
    // Read in file contents.
    result = m_Importer->Import(m_Scene);
  }
  
  if (result)
  {
    // Convert coordinate system.
    KFbxAxisSystem fbxSceneAxisSystem = m_Scene->GetGlobalSettings().GetAxisSystem();
    KFbxAxisSystem fbxLocalAxisSystem(KFbxAxisSystem::YAxis, 
      KFbxAxisSystem::ParityOdd, KFbxAxisSystem::RightHanded);
    if(fbxSceneAxisSystem != fbxLocalAxisSystem)
    {
      fbxLocalAxisSystem.ConvertScene(m_Scene);
    }

    // Convert units.
    const float centimetersPerUnit = 100.0f;  // "The equivalent number of centimeters in the new system unit"
    KFbxSystemUnit fbxSceneSystemUnit = m_Scene->GetGlobalSettings().GetSystemUnit();
    if(fbxSceneSystemUnit.GetScaleFactor() != centimetersPerUnit)
    {
      KFbxSystemUnit fbxLocalSystemUnit(centimetersPerUnit);
      fbxLocalSystemUnit.ConvertScene(m_Scene);
    }
  }

  return result;
}

//------------------------------------------------------------------------------
void FbxResourceReader::close()
{
  if (m_Scene != NULL)
  {
    // KFbxScene::Clear() causes memory leaks as of 2010.2.
    m_Scene->Destroy();
    m_Scene = KFbxScene::Create(m_SdkManager, "");
  }
}

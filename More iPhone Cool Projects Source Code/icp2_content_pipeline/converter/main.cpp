#include <resource/Geometry.h>
#include <resource/Image.h>
#include <resource/png/PngResourceReader.h>
#include <resource/fbx/FbxResourceConverter.h>
#include <resource/fbx/FbxResourceReader.h>
#include <resource/pvrtc/PvrtcResourceWriter.h>
#include <resource/geometry/GeometryResourceWriter.h>

#include <string>
#include <sys/stat.h>
#include <cerrno>

#include <fbxsdk.h>
#include <PVRTexLib.h>

using namespace std;

//------------------------------------------------------------------------------
void ConvertHierarchy(FbxResourceConverter fbxConverter, 
  GeometryResourceWriter& writer, KFbxNode* fbxNode)
{
  if(fbxNode->GetNodeAttribute() != NULL)
  {
    static uint32_t resourceIdGeometry = 0;
    static uint32_t resourceIdSkeleton = 0;
    const char* fbxNodeName = fbxNode->GetName();
    printf("Processing node '%s'\n", fbxNodeName);
    
    // Find out what type of node we are dealing with.
    KFbxNodeAttribute::EAttributeType attributeType = 
      fbxNode->GetNodeAttribute()->GetAttributeType();
    switch (attributeType)
    {
      case KFbxNodeAttribute::eMESH:
      {
        // Convert mesh geometry.
        KFbxMesh* fbxMesh = static_cast<KFbxMesh*>(fbxNode->GetNodeAttribute());
        Geometry geometry;
        if (fbxConverter.convert(*fbxMesh, geometry))
        {
          const char* fbxMeshName = fbxMesh->GetName();
          printf("Writing geometry '%s' -> %08x\n", fbxMeshName, resourceIdGeometry);
          writer.write(geometry, resourceIdGeometry++, fbxMesh->GetName());
        }
        break;
      }
        
      // no default
    }
  }
  
  // Recurse
  for(int i = 0; i < fbxNode->GetChildCount(); i++)
  {
    ConvertHierarchy(fbxConverter, writer, fbxNode->GetChild(i));
  }
}

//------------------------------------------------------------------------------
bool ConvertFbx(const char* fileName, const char* directory)
{
  // Read FBX file
  FbxResourceReader fbxReader;
  bool result = fbxReader.open(fileName);
  if (result)
  {
    // Traverse hierarchy of scene nodes.
    KFbxSdkManager* sdkManager = fbxReader.getSdkManager();
    KFbxScene* scene = fbxReader.getScene();
    GeometryResourceWriter writer;
    writer.open(directory);
    FbxResourceConverter fbxConverter(sdkManager);
    for(int i = 0; i < scene->GetRootNode()->GetChildCount(); i++)
    {
      ConvertHierarchy(fbxConverter, writer, scene->GetRootNode()->GetChild(i));
    }
  }
  else 
  {
    printf("File not found");
  }

  
  return result;
}

//------------------------------------------------------------------------------
void ConvertRgbToRgba(Image& output, const Image& input, uint8_t alpha)
{
  ASSERT_M(input.getFormat() == Image::R8G8B8, "R8G8B8 input expected.");
  
  size_t width = input.getWidth();
  size_t height = input.getHeight();
  output.init(Image::R8G8B8A8, width, height);
  
  const uint8_t* inputData = input.getData();
  const uint8_t* inputDataEnd = input.getData() + width * height * 3;
  uint8_t* outputData = output.getData();
  while (inputData < inputDataEnd)
  {
    *outputData++ = *inputData++;
    *outputData++ = *inputData++;
    *outputData++ = *inputData++;
    *outputData++ = alpha;
  }
}

//------------------------------------------------------------------------------
bool CreateDirectory(const string& dirPath)
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

//------------------------------------------------------------------------------
bool ConvertPng(const char* fileName, const char* directory)
{
  using namespace pvrtexlib;
  
  // Read PNG image
  PngResourceReader pngReader;
  bool result = pngReader.open(fileName);
  if (result)
  {
    Image imageInput;
    pngReader.read(imageInput);
    
    ASSERT_M(imageInput.getFormat() == Image::R8G8B8 || 
             imageInput.getFormat() == Image::R8G8B8A8, "Invalid format.");
    ASSERT_M(imageInput.getWidth() == imageInput.getHeight(), "Image must be square.");
    
    // Force to 32-bit format (RGBA)
    Image imageConverted;
    const bool hasAlpha = (imageInput.getFormat() == Image::R8G8B8A8);
    unsigned char* pixelData = imageInput.getData();
    if (!hasAlpha)
    {
      ConvertRgbToRgba(imageConverted, imageInput, 255);
      pixelData = imageConverted.getData();
    }
    
    // Target file name (must end with '.pvr').
    static uint32_t resourceIdTexture = 0;
    char targetFileName[512];
    snprintf(targetFileName, sizeof(targetFileName), "%s/texture", directory);
    CreateDirectory(targetFileName);
    snprintf(targetFileName, sizeof(targetFileName), "%s/texture/%08x.pvr", 
      directory, resourceIdTexture);
        
    // Create PVRTC texture.
    printf("Writing texture -> %08x\n", resourceIdTexture++);    
    PvrtcResourceWriter pvrtcWriter;
    pvrtcWriter.setOptions(false /*generateMipMaps*/, false /*twoBppEnabled*/,
      hasAlpha, true /*flipVertically*/);
    result = pvrtcWriter.open(targetFileName);
    result &= pvrtcWriter.write(imageConverted);
  }
  else 
  {
    printf("File not found");
  }
  
  return result;
}

//------------------------------------------------------------------------------
int main(int argc, char * const argv[]) 
{
  int result = EXIT_FAILURE;
  if (argc >= 3)
  {
    const char* directory = argv[1];
    for (unsigned i = 2; i < argc; i++)
    {
      const char* fileName = argv[i];
      printf("File: '%s'\n", fileName);
      
      int fileNameLength = strlen(fileName);
      if (fileNameLength > 4 && strstr(fileName, ".fbx") == &fileName[fileNameLength - 4])
      {
        printf("Detected FBX file\n");
        result = ConvertFbx(fileName, directory) ? EXIT_SUCCESS : EXIT_FAILURE;
      }
      else if (fileNameLength > 4 && strstr(fileName, ".png") == &fileName[fileNameLength - 4])
      {
        printf("Detected PNG file\n");
        result = ConvertPng(fileName, directory) ? EXIT_SUCCESS : EXIT_FAILURE;
      }
      else 
      {
        printf("Unknown file extension\n");
      }
    }
  }
  else
  {
    printf("Usage: converter dir files...\n");
    printf("Converts FBX (file ending .fbx) or PNG files (.png) and writes "
           "the output to the specified directory.\n");  
  }
  
  printf("Conversion %s.\n", result == EXIT_SUCCESS ? "suceeded" : "failed");
  
  return result;
}

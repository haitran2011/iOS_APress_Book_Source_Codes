//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#include "PngResourceReader.h"
#include "../Image.h"

#include <system/Assert.h>

#include <png.h>
#include <cstdio>
#include <stdint.h>

using namespace std;

//------------------------------------------------------------------------------
PngResourceReader::PngResourceReader()
  : m_File(NULL)
{
}

//------------------------------------------------------------------------------
PngResourceReader::~PngResourceReader()
{
  close();
}

//------------------------------------------------------------------------------
bool PngResourceReader::open(const string& fileName)
{
  close();
  m_File = fopen(fileName.c_str(), "rb");

  if (m_File)
  {
    png_byte header[8];
    fread(header, 1, 8, m_File);
    if (png_sig_cmp(header, 0, 8))
    {
      fclose(m_File);
      m_File = NULL;
    }
  }

  return (m_File != NULL);
}

//------------------------------------------------------------------------------
void PngResourceReader::close()
{
  if (m_File != NULL)
  {
    fclose(m_File);
  }
}

//------------------------------------------------------------------------------
bool PngResourceReader::read(Image& image)
{
  if (m_File == NULL)
  {
    return false;
  }

  // Read meta data.
  png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
  ASSERT_M(png_ptr != NULL, "Can't create PNG read struct.");
  png_infop info_ptr = png_create_info_struct(png_ptr);
  ASSERT_M(info_ptr != NULL, "Can't create PNG info struct.");
  
  png_init_io(png_ptr, m_File);
  png_set_sig_bytes(png_ptr, 8);
  png_read_info(png_ptr, info_ptr);

  size_t width = info_ptr->width;
  size_t height = info_ptr->height;
  png_byte bit_depth = info_ptr->bit_depth;
  png_byte color_type = info_ptr->color_type;

  // Convert unusual formats into 8-bit/RGB format.
  if (color_type == PNG_COLOR_TYPE_PALETTE)
  {
    png_set_palette_to_rgb(png_ptr);
  }
  if (color_type == PNG_COLOR_TYPE_GRAY && bit_depth < 8)
  {
    png_set_gray_1_2_4_to_8(png_ptr);
  }
  if (png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS))
  {
    png_set_tRNS_to_alpha(png_ptr);
  }
  if (bit_depth == 16)
  {
    png_set_strip_16(png_ptr);
  }
  if (bit_depth < 8)
  {
    png_set_packing(png_ptr);
  }
  if (color_type == PNG_COLOR_TYPE_GRAY || color_type == PNG_COLOR_TYPE_GRAY_ALPHA)
  {
    png_set_gray_to_rgb(png_ptr);
  }
  int number_of_passes = png_set_interlace_handling(png_ptr);
  png_read_update_info(png_ptr, info_ptr);

  // Create Image
  color_type = info_ptr->color_type;
  Image::ImageFormat format;
  switch (color_type)
  {
  case PNG_COLOR_TYPE_RGB:
    format = Image::R8G8B8;
    break;
  case PNG_COLOR_TYPE_RGBA:
  default:
    format = Image::R8G8B8A8;
    break;
  }
  image.init(format, width, height);

  // Read image
  const png_bytep data = (png_bytep)image.getData();
  const size_t numChannels = image.getNumChannels();
  for (int pass = 0; pass < number_of_passes; pass++)
  {
    for (size_t y = 0; y < height; y++)
    {
      png_bytep row_ptr = &data[y * width * numChannels];
      png_read_rows(png_ptr, &row_ptr, NULL, 1);
    }
  }
  png_read_end(png_ptr, info_ptr);

  // Clean up memory.
  png_destroy_read_struct(&png_ptr, &info_ptr, NULL);

  return true;
}

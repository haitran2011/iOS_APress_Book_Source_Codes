//
//  FaceDetectViewController.m
//  FaceDetect
//

#import "FaceDetectViewController.h"

// Filename where the Haar Cascade is stored.
static const char *CASCADE_NAME = "haarcascade_frontalface_alt_tree.xml";

// Temporary storage for the cascade. Due to its size, it is best to make it static.
static CvMemStorage *cvStorage = NULL;

// Pointer to the cascade, we also only need one.
static CvHaarClassifierCascade *haarCascade = NULL;

@implementation FaceDetectViewController

- (IBAction)detectFaces {
  UIImagePickerController* controller = [[UIImagePickerController alloc] init];
  controller.delegate = self;
  [self presentModalViewController:controller animated:YES];
  [controller release]; 
}

// You should always release the image returned by this method.
- (IplImage *)iplImageFromUIImage:(UIImage *)image {
  CGImageRef imageRef = image.CGImage; 
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  IplImage *iplImage =
  cvCreateImage(cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4);
  CGContextRef contextRef =
      CGBitmapContextCreate(iplImage->imageData, iplImage->width, iplImage->height,
                            iplImage->depth, iplImage->widthStep, colorSpace,
                        kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
  CGRect imageRect = CGRectMake(0, 0,iplImage->width,iplImage->height);
  CGContextDrawImage(contextRef, imageRect, imageRef);
  CGContextRelease(contextRef);
  CGColorSpaceRelease(colorSpace);
  
  return iplImage;
}

- (UIImage *)uiImageFromIplImage:(IplImage *)image {
  NSData *data = [NSData dataWithBytes:image->imageData length: image->imageSize];
  CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGImageRef imageRef =
      CGImageCreate(image->width, image->height, image->depth,
                    image->depth * image->nChannels, image->widthStep,
                    colorSpace, kCGImageAlphaLast|kCGBitmapByteOrderDefault,
                    provider, NULL, false, kCGRenderingIntentDefault);
  UIImage *uiImage = [UIImage imageWithCGImage:imageRef];
  CGColorSpaceRelease(colorSpace);
  CGDataProviderRelease(provider);
  CGImageRelease(imageRef);
  
  return uiImage;
}

//     === Draws red rectangles around faces. ===
//- (void)drawOnFaceAt:(CvRect *)rect inImage:(IplImage *)image {
//  // To draw a rectangle you must input points instead of a rectangle. I know, I know...
//  cvRectangle(image, cvPoint(rect->x, rect->y), 
//              cvPoint(rect->x + rect->width, rect->y + rect->height),
//              cvScalar(255, 0, 0, 255) /* RGBA */, 4, 8, 0);
//}


//     === Blurs faces. ===
- (void)drawOnFaceAt:(CvRect *)rect inImage:(IplImage *)image {
  IplImage* faceImage = cvCreateImage(cvSize(rect->width, rect->height), 8, 4);
  
  // The Region Of Interest acts as a temporary crop of the image.
  cvSetImageROI(image, *rect);
  
  // Create a copy of the face and apply gaussian blur to it.
  cvCopy(image, faceImage, NULL);
  cvSmooth(faceImage, faceImage, CV_GAUSSIAN, 51, 51, 0, 0);
  
  // Let's build a (elliptical) mask to apply blur only around the facial area.
  IplImage *copyMask = cvCreateImage(cvGetSize(faceImage), 8, 1);
  
  // Center of the ellipse.
  CvPoint center = cvPoint(faceImage->width / 2, faceImage->height / 2);
  cvZero(copyMask);
  // Draw the ellipse.
  cvEllipse(copyMask, center, cvSize(faceImage->width * 0.5, faceImage->height * 0.6),
            0, 0, 360, cvScalarAll(255), CV_FILLED, 8, 0);
  
  // Pixels in faceImage will only be copied if their conterpart in copyMask is non-zero.
  cvCopy(faceImage, image, copyMask);
  
  // Clean up.
  cvReleaseImage(&faceImage);
  cvReleaseImage(&copyMask);
  cvResetImageROI(image);
}

//     === Step 1 - Just loading images. ===
//- (void)imagePickerController:(UIImagePickerController *) picker
//    didFinishPickingMediaWithInfo:(NSDictionary *) info { 
//  // Load up the image selected in the picker.
//  UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage]; 
//  IplImage *iplImage = [self iplImageFromUIImage:originalImage];
//  
//  // We will do some CV magic here later.
//  // ...
//  
//  UIImage* newImage = [self uiImageFromIplImage:iplImage];
//  // IplImages must be deallocated manually.
//  cvReleaseImage(&iplImage);
//  
//  [imageView setImage:newImage]; 
//  [[picker parentViewController] dismissModalViewControllerAnimated:YES];
//}

- (void)imagePickerController:(UIImagePickerController *) picker 
didFinishPickingMediaWithInfo:(NSDictionary *) info {  
  UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];  
  IplImage * iplImage = [self iplImageFromUIImage:originalImage];
  
  
  // Clear the memory storage from any previously detected faces.
  cvClearMemStorage(cvStorage);
  
  // Detect the faces and store their rectangles in the sequence.
  CvSeq* faces = cvHaarDetectObjects(iplImage, // Input image
                                     haarCascade, // Cascade to be used
                                     cvStorage, // Temporary storage
                                     1.1, // Size increase for features at each scan
                                     2, // Min number of neighboring rectangle matches
                                     CV_HAAR_DO_CANNY_PRUNING, // Optimization flags
                                     cvSize(30, 30)); // Starting feature size
  // CvSeq is essentially a linked list with tree features. "faces" is a list of
  // bounding rectangles for each face found in iplImage.
  for (int i = 0; i < faces->total; i++) {
    // cvGetSeqElem is used for random access to CvSeqs.
    CvRect* rect = (CvRect*)cvGetSeqElem(faces, i);
    [self drawOnFaceAt:rect inImage:iplImage];
  }  
  
  UIImage* newImage = [self uiImageFromIplImage: iplImage];
  cvReleaseImage(&iplImage);
  
  [imageView setImage:newImage];
  
  // Optional: save image.
  UIImageWriteToSavedPhotosAlbum(newImage, self, nil, nil); 
  
  [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  cvStorage = cvCreateMemStorage(0);
  NSString *resourcePath = 
  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:
   [NSString stringWithUTF8String:CASCADE_NAME]];
  haarCascade = (CvHaarClassifierCascade *)cvLoad([resourcePath UTF8String], 0, 0, 0);
}

@end

//
//  FaceDetectViewController.h
//  FaceDetect
//

#import <UIKit/UIKit.h>

#import "cv.h"

@interface FaceDetectViewController : UIViewController 
    <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  IBOutlet UIImageView *imageView;
}

- (IBAction)detectFaces;
- (IplImage *)iplImageFromUIImage:(UIImage *)image;
- (UIImage *)uiImageFromIplImage:(IplImage *)image;
- (void)drawOnFaceAt:(CvRect *)rect inImage:(IplImage *)image;

@end


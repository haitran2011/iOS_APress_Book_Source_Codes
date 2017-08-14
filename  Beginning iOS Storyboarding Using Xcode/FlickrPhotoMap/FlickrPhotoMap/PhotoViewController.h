//
//  PhotoViewController.h
//  FlickrPhotoMap
//
//  Created by Yulia McCarthy on 5/30/12.
//  Copyright (c) 2012 InspireSmart Solutions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoAnnotation;

@interface PhotoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *photoTitleLabel;
@property (strong, nonatomic) PhotoAnnotation *photoAnnotation;

@end

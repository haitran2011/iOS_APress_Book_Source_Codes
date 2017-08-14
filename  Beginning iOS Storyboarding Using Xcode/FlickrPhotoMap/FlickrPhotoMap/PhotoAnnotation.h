//
//  PhotoAnnotation.h
//  FlickrPhotoMap
//
//  Created by Yulia McCarthy on 5/29/12.
//  Copyright (c) 2012 InspireSmart Solutions, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "PinSelectionDelegateProtocol.h"

@interface PhotoAnnotation : NSObject <MKAnnotation>

// MKAnnotation properties
@property (nonatomic, copy)      NSString *title;
@property (nonatomic, copy)      NSString *subtitle;
@property (nonatomic, assign)    CLLocationCoordinate2D coordinate;

// Other properties
@property (nonatomic, strong)    UIImage *image;
@property (nonatomic, strong)    UIImage *thumbnail;
@property (nonatomic, strong)    NSURL *imageURL;
@property (nonatomic, strong)    NSURL *thumbnailURL;
@property (nonatomic, assign)    AnnotationPinType pinType;
@property (nonatomic, readonly)  NSString *annotationViewImageName;

- (id)initWithImageURL:(NSURL *)anImageURL thumbnailURL:(NSURL *)aThumbnailURL title:(NSString *)aTitle coordinate:(CLLocationCoordinate2D)aCoordinate;
- (void)updateSubtitle;

@end
//
//  PhotoAnnotation.m
//  FlickrPhotoMap
//
//  Created by Yulia McCarthy on 5/29/12.
//  Copyright (c) 2012 InspireSmart Solutions, Inc. All rights reserved.
//

#import "PhotoAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@implementation PhotoAnnotation

@synthesize title, subtitle, coordinate;
@synthesize image, thumbnail;
@synthesize imageURL, thumbnailURL; 
@synthesize pinType;

- (id)initWithImageURL:(NSURL *)anImageURL thumbnailURL:(NSURL *)aThumbnailURL 
                 title:(NSString *)aTitle coordinate:(CLLocationCoordinate2D)aCoordinate
{
    if ((self = [super init])) {
        self.imageURL = anImageURL;
        self.thumbnailURL = aThumbnailURL;
        self.title = aTitle;
        self.coordinate = aCoordinate;
    }
    return self;
}


- (NSString *)annotationViewImageName
{
    switch (self.pinType) {
        case 0:
            return @"BluePin.png";
            break;
        case 1:
            return @"RedPin.png";
            break;
        case 2:
            return @"GreenPin.png";
            break;
        case 3:
            return @"YellowPin.png";
            break;
        default:
            break;
    }
}

- (NSString *)title
{
    return title;
}


- (UIImage *)image
{
    // We don't want to have all the images loaded in memory unnecessarily, so we should 
    // wait to load the image until we actually want to display it 
    if (!image && self.imageURL) {
        NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
        self.image = [UIImage imageWithData:imageData];
    }
    return image;
}


- (UIImage *)thumbnail
{
    // We don't want to have all the images loaded in memory unnecessarily, so we should 
    // wait to load the image until we actually want to display it 
    if (!image && self.thumbnailURL) {
        NSData *imageData = [NSData dataWithContentsOfURL:self.thumbnailURL];
        self.thumbnail = [UIImage imageWithData:imageData];
    }
    return thumbnail;
}

#pragma mark - Reverse geocode subtitle
#pragma mark -

// Returns string of "City, State" format if availbale
- (NSString *)placemarkToString:(CLPlacemark *)placemark
{
    NSMutableString *placemarkString = [[NSMutableString alloc] init];
    if (placemark.locality) {
        [placemarkString appendString:placemark.locality];
    }
    
    if (placemark.administrativeArea) {
        if (placemarkString.length > 0)
            [placemarkString appendString:@", "];
        [placemarkString appendString:placemark.administrativeArea];
    }
    
    if (placemarkString.length == 0 && placemark.name)
        [placemarkString appendString:placemark.name];
    
    return placemarkString;
}


- (void)updateSubtitle
{
    if (self.subtitle != nil)
        return;
    
    // Reverse geocode the annotation's coordinate
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude 
                                                      longitude:self.coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.subtitle = [self placemarkToString:placemark];
        }

    }];
}

@end
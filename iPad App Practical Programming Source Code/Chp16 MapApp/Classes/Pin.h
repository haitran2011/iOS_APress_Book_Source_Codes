//
//  Pin.h
//  MapApp
//
//  Created by Chen Li on 1/2/11.
//  Copyright 2011 Chen Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Pin : NSObject <MKAnnotation> {
	float latitude;
	float longitude;
}

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end

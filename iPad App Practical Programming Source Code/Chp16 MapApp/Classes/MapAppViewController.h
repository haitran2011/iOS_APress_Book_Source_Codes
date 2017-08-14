//
//  MapAppViewController.h
//  MapApp
//
//  Created by Chen Li on 1/2/11.
//  Copyright 2011 Chen Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Pin.h"

@interface MapAppViewController : UIViewController <MKMapViewDelegate> {
	MKMapView *mapView;
}

@end


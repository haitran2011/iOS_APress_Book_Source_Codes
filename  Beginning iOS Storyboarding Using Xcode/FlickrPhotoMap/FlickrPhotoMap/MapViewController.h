//
//  MapViewController.h
//  FlickrPhotoMap
//
//  Created by Yulia McCarthy on 5/28/12.
//  Copyright (c) 2012 InspireSmart Solutions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PinSelectionDelegateProtocol.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, PinSelectionDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

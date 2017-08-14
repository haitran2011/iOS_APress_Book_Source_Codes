//
//  PinSelectionViewController.h
//  FlickrPhotoMap
//
//  Created by Yulia McCarthy on 5/30/12.
//  Copyright (c) 2012 InspireSmart Solutions, Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PinSelectionDelegateProtocol.h"

@interface PinSelectionViewController : UITableViewController

@property (weak, nonatomic) id<PinSelectionDelegate> delegate;
@property (assign, nonatomic) AnnotationPinType currentPinType;

@end
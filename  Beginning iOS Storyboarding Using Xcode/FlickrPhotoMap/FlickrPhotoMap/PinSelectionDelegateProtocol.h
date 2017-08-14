//
//  PinSelectionDelegateProtocol.h
//  FlickrPhotoMap
//
//  Created by Yulia McCarthy on 5/30/12.
//  Copyright (c) 2012 InspireSmart Solutions, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef enum {
    BLUE_PIN,
    RED_PIN,
    GREEN_PIN,
    YELLOW_PIN
} AnnotationPinType;


@protocol PinSelectionDelegate <NSObject>

@required

-(void)userDidSelectPinType:(AnnotationPinType)aPinType;

@end
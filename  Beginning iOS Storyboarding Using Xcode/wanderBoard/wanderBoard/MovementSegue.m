//
//  MovementSegue.m
//  wanderboardTry001
//
//  Created by Stephen Moraco on 12/04/03.
//  Copyright (c) 2012 Iron Sheep Productions, LLC. All rights reserved.
//

#import "MovementSegue.h"

@interface MovementSegue () {
    
}

@end

@implementation MovementSegue

-(void)perform
{
    // departing view will set its tag to value showing direction moved
    // get the value, then determine segue type based on it
    NSInteger nMoveDirection = [[self sourceViewController] view].tag;
    UIViewAnimationTransition eTransition = UIViewAnimationTransitionNone;
    switch(nMoveDirection) {
        case MV_LEFT:
            eTransition = UIViewAnimationTransitionFlipFromLeft;
            break;
        case MV_RIGHT:
            eTransition = UIViewAnimationTransitionFlipFromRight;
            break;
//        case MV_FORWARD:
//            eTransition = UIViewAnimationTransitionFlipFromTop;
//            break;
//        case MV_REVERSE:
//            break;
    }
    // push our destination view (albeit we can't see it yet...)
    UINavigationController *navController = [[self sourceViewController] navigationController];
    [navController pushViewController:[self destinationViewController] animated:NO]; 
    
    // now animate the view into being seen
    [UIView beginAnimations:nil context:nil];   // begins animation block
    [UIView setAnimationDuration:3.0];          // sets animation duration
    //[UIView setAnimationDelegate:self];         // sets delegate for this block
    [UIView setAnimationTransition:eTransition forView:[[self sourceViewController] view] cache:YES];
    [UIView commitAnimations];                  // ends the block and executes it
    
    
    
//    [UIView transitionFromView:(displayingPrimary ? primaryView : secondaryView)
//                        toView:(displayingPrimary ? secondaryView : primaryView)
//                      duration:1.0
//                       options:(displayingPrimary ? UIViewAnimationOptionTransitionFlipFromRight :
//                                UIViewAnimationOptionTransitionFlipFromLeft)
//                    completion:^(BOOL finished) {
//                        if (finished) {
//                            displayingPrimary = !displayingPrimary;
//                        }
//                    }];
}

@end

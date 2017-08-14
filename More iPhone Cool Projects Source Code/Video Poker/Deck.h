//
//  Deck.h
//  HU Poker
//
//  Created by Chuck Smith on 5/7/09.
//  Copyright 2009 Chuck Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface Deck : NSObject {
	NSMutableArray *cards;
	NSUInteger curCard;
}

@property (nonatomic, retain) NSMutableArray *cards;

-(void) shuffle;
-(Card *)nextCard;

@end

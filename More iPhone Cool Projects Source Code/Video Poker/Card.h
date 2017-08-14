//
//  Card.h
//  HU Poker
//
//  Created by Chuck Smith on 5/5/09.
//  Copyright 2009 Chuck Smith. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Card : NSObject
{
	NSUInteger rank;
	NSUInteger suit;
	BOOL locked;
}

@property BOOL locked;

-(id) initWithRank:(NSUInteger)cardRank andSuit:(NSUInteger)cardSuit;
-(id)initWithRandomCard;
-(id)initWithCard:(Card *)myCard;

-(NSString *)humanSuit;
-(NSString *)humanRank;

-(NSComparisonResult) compareDescendingTo:(Card *)anotherCard;

-(NSUInteger)rank;
-(NSUInteger)suit;

-(void)lock;
-(void)unlock;
-(void)toggleLock;

@end

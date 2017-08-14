//
//  Card.m
//  HU Poker
//
//  Created by Chuck Smith on 5/5/09.
//  Copyright 2009 Chuck Smith. All rights reserved.
//

#import "Card.h"
#import "GlobalVariables.h"

@implementation Card

@synthesize locked;

- (void)dealloc {
    [super dealloc];
}


-(id) initWithRandomCard
{
	suit = arc4random() % 4 + 1;
	rank = arc4random() % 13 + 2; // Pick random card between 2 and ACE (14)
	return self;
}


-(id) initWithRank:(NSUInteger)cardRank andSuit:(NSUInteger)cardSuit
{
	rank = cardRank;
	suit = cardSuit;
	return self;
}


-(id)initWithCard:(Card *)myCard;
{
	rank = [myCard rank];
	suit = [myCard suit];
	return self;
}


-(NSString *)description
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	// Increase font size if user is on an iPad
	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
	{
		// The device is an iPad running iPhone 3.2 or later.
		return [NSString stringWithFormat:@"Large-%@%@",
				[self humanRank],
				[self humanSuit]];		
	}
#endif
	
	return [NSString stringWithFormat:@"%@%@",
			[self humanRank],
			[self humanSuit]]; 
}


-(NSComparisonResult) compareDescendingTo:(Card *)anotherCard
{
	if ( rank < [anotherCard rank] ) { return NSOrderedDescending; }
	if ( rank > [anotherCard rank] ) { return NSOrderedAscending; }
	
	// The value is the same
	return NSOrderedSame;
}


-(NSUInteger)rank
{
	return rank;
}


-(NSUInteger)suit
{
	return suit;
}


-(NSString *)humanRank
{
	switch (rank) 
	{
		case 0:     return @"Error";
		case JACK:  return @"J";
		case QUEEN: return @"Q";
		case KING:  return @"K";
		case ACE:   return @"A";
		case 10:    return @"T";
		default:    return [NSString stringWithFormat:@"%d", rank];
	}
}


-(NSString *)humanSuit {
	switch (suit) {
		case 0:        return @"Error";
		case SPADES:   return @"s";
		case HEARTS:   return @"h";
		case CLUBS:    return @"c";
		case DIAMONDS: return @"d";
		default:       return @"Suit >4 Error";
	}
}


-(void)lock {
	locked = true;
}


-(void)unlock {
	locked = false;
}


-(void)toggleLock {
	locked = !locked;
}
	
@end

//
//  Deck.m
//  HU Poker
//
//  Created by Chuck Smith on 5/7/09.
//  Copyright 2009 Chuck Smith. All rights reserved.
//

#import "Deck.h"
#import "Card.h"

@implementation Deck

@synthesize cards;

- (void)dealloc {
    [cards release];
    [super dealloc];
}

-(id) init
{
	cards = [[NSMutableArray alloc] initWithCapacity:52];
	
	for ( int suit = 1; suit <= 4; suit++ )
	{
		for ( int cardRank = 2; cardRank <= 14; cardRank++ )
		{
			Card *myCard = [[Card alloc] initWithRank:cardRank andSuit:suit];
			[cards addObject:myCard];
			[myCard release];
		}
	}
	
	[self shuffle];
		
	return self;
}

-(void) shuffle
{
	// Swap each card with a random card AFTER it to get an even random distribution.
	for ( int i = 0; i < 51; i++ )
	{
		[cards exchangeObjectAtIndex:i withObjectAtIndex:arc4random() % (52 - i) + i];
	}
	
	curCard = 0;
}

-(Card *)nextCard
{
	return [cards objectAtIndex:curCard++];
}

@end

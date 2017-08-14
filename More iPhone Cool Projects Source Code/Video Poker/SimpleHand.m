//
//  SimpleHandRank.m
//  HU Poker
//
//  Created by Chuck Smith on 5/5/09.
//  Copyright 2009 Chuck Smith. All rights reserved.
//

#import "SimpleHand.h"
#import "Card.h"
#import "GlobalVariables.h"

@implementation SimpleHand

@synthesize cards;

- (void)dealloc {
    [cards release];
    [super dealloc];
}

-(id) init
{
	cards = [[NSMutableArray alloc] initWithCapacity:5];
	[super init];
	return self;
}


-(id) copyWithZone:(NSZone *) zone
{
	SimpleHand *simpleHandCopy;
	simpleHandCopy = [[[self class] allocWithZone: zone] initWithHand:cards];
	
	[simpleHandCopy calculate];
	
	return simpleHandCopy;
}


-(id)initWithHand:(NSMutableArray *)myHand
{
	cards = [[NSMutableArray alloc] initWithArray:myHand];
	return self;
}


-(id)initWithHand:(NSMutableArray *)myHand without:(NSUInteger)removal1 andWithout:(NSUInteger)removal2
{
	[self initWithHand:myHand];
	
	[cards removeObjectAtIndex:removal2];
	[cards removeObjectAtIndex:removal1];
		
	return self;
}


-(NSString *)description
{
	NSMutableString *humanHand = [[NSMutableString alloc] initWithString:@""];
	
	if ( [cards count] == 0 )
	{
		[humanHand release];
		return @"None";
	}
	
	for ( int i = 0; i < [cards count]; i++ ) {
		[humanHand appendFormat:@" %@", [cards objectAtIndex:i]];
	}
	
	return [NSString stringWithFormat:@"Hand:%@, Hand rank: %@", humanHand, [self handRankString]];
}


- (NSString *)handRankString
{
	switch ( handRank ) {
		case ROYAL_FLUSH:     return @"Royal Flush";     break;
		case STRAIGHT_FLUSH:  return @"Straight Flush";  break;
		case FOUR_OF_A_KIND:  return @"Four of a Kind";  break;
		case FULL_HOUSE:      return @"Full House";      break;
		case FLUSH:           return @"Flush";           break;
		case STRAIGHT:        return @"Straight";        break;
		case THREE_OF_A_KIND: return @"Three of a Kind"; break;
		case TWO_PAIR:        return @"Two Pair";        break;
		case JACKS_OR_BETTER: return @"Jacks or Better"; break;
		case HIGH_CARD:       return @"Try Again";       break;
		default:              return @"Not yet calculated";
	}
}


-(void)addCard:(Card *)anotherCard
{
	[cards addObject:anotherCard];
}


-(void)replaceCardIndex:(NSUInteger)cardIndex withCard:(Card *)newCard {
	[cards replaceObjectAtIndex:cardIndex withObject:newCard];
}


-(NSComparisonResult)compareTo:(SimpleHand *)myHand
{
	// See if one hand has a better pattern than the other.
	if ( handRank < [myHand handRank] )
	{
		return NSOrderedAscending;
	}
	else if ( handRank > [myHand handRank] )
	{
		return NSOrderedDescending;
	}
	
	// Both have same pattern, determine which has higher cards.
	for ( int i = 0; i < 5; i++ )
	{
		if ( [self cardRankAtIndex:i] < [myHand cardRankAtIndex:i] )
		{
			return NSOrderedAscending;
		}
		else if ( [self cardRankAtIndex:i] > [myHand cardRankAtIndex:i] )
		{
			return NSOrderedDescending;
		}
	}
	
	// Both hands are completely equally valued: split pot.
	return NSOrderedSame;
}


-(NSUInteger)cardRankAtIndex:(NSUInteger)index
{
	return [[cards objectAtIndex:index] rank];
}


-(void)calculate
{
	SimpleHand *sortedHand = [[SimpleHand alloc] initWithHand:cards];
	
	// Sort cards to make hands easier to calculate
	[sortedHand sort];	
	
	if ( [sortedHand isRoyalFlush] )    { handRank = ROYAL_FLUSH;     return; }
	if ( [sortedHand isStraightFlush] ) { handRank = STRAIGHT_FLUSH;  return; }
	if ( [sortedHand isFourOfAKind] )   { handRank = FOUR_OF_A_KIND;  return; }
	if ( [sortedHand isFullHouse] )     { handRank = FULL_HOUSE;      return; }
	if ( [sortedHand isFlush] )         { handRank = FLUSH;           return; }
	if ( [sortedHand isStraight] )      { handRank = STRAIGHT;        return; }
	if ( [sortedHand isThreeOfAKind] )  { handRank = THREE_OF_A_KIND; return; }
	if ( [sortedHand isTwoPair] )       { handRank = TWO_PAIR;        return; }
	if ( [sortedHand isJacksOrBetter] ) { handRank = JACKS_OR_BETTER; return; }
	
	[sortedHand release];
	
	// No hand found
	handRank = HIGH_CARD;
	return;
}


-(void) sort
{
	[cards sortUsingSelector:@selector(compareDescendingTo:)];
}


- (Card *)getCard:(NSUInteger)index
{
	return [cards objectAtIndex:index];
}


-(NSUInteger)handRank
{
	return handRank;
}


-(BOOL)isRoyalFlush
{
	return ( [[cards objectAtIndex:0] rank] == ACE && [[cards objectAtIndex:1] rank] == KING
			&& [self isStraightFlush] );
}


-(BOOL)isStraightFlush
{
	return ( [self isFlush] && [self isStraight] );	
}


-(BOOL)isFourOfAKind
{
	if ( [[cards objectAtIndex:0] rank] == [[cards objectAtIndex:1] rank] )
	{
		// First two cards were same, see if next two also are.
		if ( [[cards objectAtIndex:0] rank] == [[cards objectAtIndex:2] rank] &&
			[[cards objectAtIndex:0] rank] == [[cards objectAtIndex:3] rank] )
		{
			// All first four cards are the same, no reorder necessary
			return true;
		}
	}
	else
	{
		// First two cards were different, see if last three all match 2nd card.
		if ( [[cards objectAtIndex:1] rank] == [[cards objectAtIndex:2] rank] &&
			[[cards objectAtIndex:1] rank] == [[cards objectAtIndex:3] rank] &&
			[[cards objectAtIndex:1] rank] == [[cards objectAtIndex:4] rank] )
		{
			// Last four cards are the same, move last card to beginning
			[cards exchangeObjectAtIndex:0 withObjectAtIndex:4];
			return true;
		}
	}
	
	return false;
}

-(BOOL)isFullHouse
{	
	if ( [[cards objectAtIndex:0] rank] == [[cards objectAtIndex:1] rank] &&
		[[cards objectAtIndex:3] rank] == [[cards objectAtIndex:4] rank] )
	{
		// 1st card matches 2nd and 4th card matches 5th.
		// See if 3rd card matches 2nd or 4th.
		if ( [[cards objectAtIndex:1] rank] == [[cards objectAtIndex:2] rank] )
		{
			return true;
		}
		else if ( [[cards objectAtIndex:2] rank] == [[cards objectAtIndex:3] rank] )
		{
			// Reorder cards to reflect position
			[cards exchangeObjectAtIndex:0 withObjectAtIndex:4];
			[cards exchangeObjectAtIndex:1 withObjectAtIndex:3];
			return true;
		}
	}
		
	return false;
}


-(BOOL)isFlush
{
	for ( int i = 1; i < 5; i++ )
	{
		if ( [[cards objectAtIndex:0] suit] != [[cards objectAtIndex:i] suit] )
		{
			// If any suit doesn't match the 1st card, it's not a flush.
			return false;
		}
	}
	
	// All suits match, this is a bona fide flush!
	return true;
}


-(BOOL)isStraight
{
	// Special boolean to check for A-5-4-3-2 straight -> 5-4-3-2-A
	BOOL aceAndFiveStart = false;

	if ( [[cards objectAtIndex:0] rank] == ACE && [[cards objectAtIndex:1] rank] == 5 )
	{
		aceAndFiveStart = true;
	}
	
	// If 1st card is not exactly one less than the current one and the ace and five don't start, not straight.
	if ( [[cards objectAtIndex:0] rank] != [[cards objectAtIndex:1] rank] + 1 && !aceAndFiveStart )
	{
		return false;
	}
	
	// See if 8-7-6-5-4
	for ( int i = 1; i < 4; i++ )
	{
		if ( [[cards objectAtIndex:i] rank] != [[cards objectAtIndex:i+1] rank] + 1 )
		{
			// The next card is not exactly one less than the current one, so not a straight.
			return false;
		}
	}
	
	if ( aceAndFiveStart ) {
		// Save first card to put at the end.
		Card *aceCard = [[Card alloc] initWithCard:[cards objectAtIndex:0]];
		[cards removeObjectAtIndex:0];
		[cards addObject:aceCard];
		[aceCard release];
	}
		
	// All cards are in order, it's a straight!
	return true;
}


-(BOOL)isThreeOfAKind
{
	if ( [[cards objectAtIndex:0] rank] == [[cards objectAtIndex:1] rank] && 
		[[cards objectAtIndex:1] rank] == [[cards objectAtIndex:2] rank] )
	{
		// 1st, 2nd and 3rd cards are the same.
		return true;
	}
	
	if ( [[cards objectAtIndex:1] rank] == [[cards objectAtIndex:2] rank] &&
		[[cards objectAtIndex:2] rank] == [[cards objectAtIndex:3] rank] )
	{
		// 2nd, 3rd and 4th cards are the same.
		[cards exchangeObjectAtIndex:0 withObjectAtIndex:3];
		return true;
	}
	
	if ( [[cards objectAtIndex:2] rank] == [[cards objectAtIndex:3] rank] &&
		[[cards objectAtIndex:3] rank] == [[cards objectAtIndex:4] rank] )
	{
		[cards exchangeObjectAtIndex:0 withObjectAtIndex:3];
		[cards exchangeObjectAtIndex:1 withObjectAtIndex:4];
		// 3rd, 4th, and 5th cards are the same.
		return true;
	}
											
	return false;
}


-(BOOL)isTwoPair
{
	NSUInteger pairsFound = 0;

	for ( int i = 0; i < 4; i++ ) {
		if ( [[cards objectAtIndex:i] rank] == [[cards objectAtIndex:i+1] rank] )
		{
			if ( pairsFound == 0 ) 
			{
				// No pair found yet, swap to beginning
				[cards exchangeObjectAtIndex:0 withObjectAtIndex:i];
				[cards exchangeObjectAtIndex:1 withObjectAtIndex:i+1];
			}
			else
			{
				// Pair already found, swap to 3rd and 4th positions
				[cards exchangeObjectAtIndex:2 withObjectAtIndex:i];
				[cards exchangeObjectAtIndex:3 withObjectAtIndex:i+1];
			}
				
			pairsFound++;
		}
	}
	
	return ( pairsFound == 2 );
}

// NOTE: This only checks to see if one pair is jacks or better.
-(BOOL)isJacksOrBetter
{
	for ( int i = 0; i < 4; i++ ) {
		if ( [[cards objectAtIndex:i] rank] == [[cards objectAtIndex:i+1] rank] )
		{
			if ( i == 3 ) {
				// Move cards around in a position to keep the same order in the hand 
				[cards exchangeObjectAtIndex:2 withObjectAtIndex:3];
				[cards exchangeObjectAtIndex:3 withObjectAtIndex:4];
				i = 2;
			}
			
			// Move pair to start of hand.
			[cards exchangeObjectAtIndex:0 withObjectAtIndex:i];
			[cards exchangeObjectAtIndex:1 withObjectAtIndex:i+1];
			
			// By removing this if statement, this function will just see if the hand is a pair.
			if ( [[cards objectAtIndex:0] rank] >= JACK ) {
				return true;
			}
		}
	}
	
	return false;	
}


-(BOOL)isOnePair
{
	for ( int i = 0; i < 4; i++ ) {
		if ( [[cards objectAtIndex:i] rank] == [[cards objectAtIndex:i+1] rank] )
		{
			if ( i == 3 ) {
				// Move cards around in a position to keep the same order in the hand 
				[cards exchangeObjectAtIndex:2 withObjectAtIndex:3];
				[cards exchangeObjectAtIndex:3 withObjectAtIndex:4];
				i = 2;
			}
			
			// Move pair to start of hand.
			[cards exchangeObjectAtIndex:0 withObjectAtIndex:i];
			[cards exchangeObjectAtIndex:1 withObjectAtIndex:i+1];
			
			return true;
		}
	}
	
	return false;	
}

@end

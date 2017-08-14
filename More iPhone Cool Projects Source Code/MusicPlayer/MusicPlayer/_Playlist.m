// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Playlist.m instead.

#import "_Playlist.h"

@implementation PlaylistID
@end

@implementation _Playlist

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Playlist" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Playlist";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Playlist" inManagedObjectContext:moc_];
}

- (PlaylistID*)objectID {
	return (PlaylistID*)[super objectID];
}




@dynamic name;






@dynamic songs;

	
- (NSMutableSet*)songsSet {
	[self willAccessValueForKey:@"songs"];
	NSMutableSet *result = [self mutableSetValueForKey:@"songs"];
	[self didAccessValueForKey:@"songs"];
	return result;
}
	



@end

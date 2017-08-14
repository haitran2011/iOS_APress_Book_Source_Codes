#import "Playlist.h"
#import "Song.h"

@implementation Playlist

- (NSTimeInterval) duration
{
	return [[self valueForKeyPath:@"songs.@sum.duration"] doubleValue];
}

@end

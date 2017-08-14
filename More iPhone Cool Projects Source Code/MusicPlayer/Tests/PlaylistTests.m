//
//  PlaylistTests.m
//  MusicPlayer
//
//  Created by Saul Mora.
//  Copyright 2010 Magical Panda Software, LLC. All rights reserved.
//

#import "PlaylistTests.h"
#import "CoreData+ActiveRecordFetching.h"
#import "Playlist.h"
#import "Song.h"

@implementation PlaylistTests


- (void) setUpClass
{
	[ActiveRecordHelpers setupCoreDataStackWithInMemoryStore];
}

- (void) tearDownClass
{
	[ActiveRecordHelpers cleanUp];
}

- (void) testPlaylistIsNotValid
{
	Playlist *testPlaylist = [Playlist newEntity];
	
	NSError *error = nil;
	[[NSManagedObjectContext defaultContext] save:&error];
	
	GHAssertNotNil(error, @"Shouldn't be any errors on save!");
}

- (void) testPlaylistCalculatesDurationBasedOnSongDuration
{
	Playlist *testPlaylist = [Playlist newEntity];
	Song *testSong1 = [Song newEntity];
	[testSong1 setTitle:@"Song 1"];
	[testSong1 setDurationValue:3];
	
	Song *testSong2 = [Song newEntity];
	[testSong2 setTitle:@"Song 2"];
	[testSong2 setDurationValue: 2];
	
	[testPlaylist addSongsObject:testSong1];
	[testPlaylist addSongsObject:testSong2];
	
	GHAssertEquals([testPlaylist duration], 5.0, nil);
}

@end

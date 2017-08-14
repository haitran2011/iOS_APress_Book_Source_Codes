// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Playlist.h instead.

#import <CoreData/CoreData.h>


@class Song;

@interface PlaylistID : NSManagedObjectID {}
@end

@interface _Playlist : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PlaylistID*)objectID;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* songs;
- (NSMutableSet*)songsSet;



@end

@interface _Playlist (CoreDataGeneratedAccessors)

- (void)addSongs:(NSSet*)value_;
- (void)removeSongs:(NSSet*)value_;
- (void)addSongsObject:(Song*)value_;
- (void)removeSongsObject:(Song*)value_;

@end

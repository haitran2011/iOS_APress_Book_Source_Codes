// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Song.h instead.

#import <CoreData/CoreData.h>


@class Playlist;

@interface SongID : NSManagedObjectID {}
@end

@interface _Song : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SongID*)objectID;



@property (nonatomic, retain) NSString *artist;

//- (BOOL)validateArtist:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *duration;

@property double durationValue;
- (double)durationValue;
- (void)setDurationValue:(double)value_;

//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Playlist* playlist;
//- (BOOL)validatePlaylist:(id*)value_ error:(NSError**)error_;



@end

@interface _Song (CoreDataGeneratedAccessors)

@end

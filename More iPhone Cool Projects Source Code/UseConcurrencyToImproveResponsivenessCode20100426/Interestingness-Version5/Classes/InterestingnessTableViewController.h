//
//  InterestingnessTableViewController.h
//  Interestingness - VERSION 5
//
//  Created by Danton Chin on 3/24/10.
//  Copyright 2010  http://iphonedeveloperjournal.com/. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestingnessTableViewController : UITableViewController {
	
	NSMutableArray		*imageTitles;
	NSMutableArray		*imageURLs;
	NSOperationQueue	*workQueue;
	NSMutableDictionary *imageDictionary;
}
-(void)fetchInterestingnessList;
-(void)disaggregateInterestingnessList:(NSDictionary *)results;

-(UIImage *)getImageForURL:(NSURL *)url;
-(void)storeImageForURL:(NSDictionary *)result;

@end

//
//  JobUnit.h
//  HelloOperationQueues
//
//  Created by Danton Chin on 3/29/10.
//  Copyright 2010  http://iphonedeveloperjournal.com/. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JobUnit : NSOperation  {
	NSString *workMsg;
	
}

@property (nonatomic, retain) NSString *workMsg;

-(id)initWithMsg:(NSString *)msg dependency:(id)obj;
-(void)main;


@end
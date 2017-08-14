//
//  HelloOperationQueuesViewController.h
//  HelloOperationQueues
//
//  Created by Danton Chin on 3/28/10.
//  Copyright  http://iphonedeveloperjournal.com/ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JobUnit;

@interface HelloOperationQueuesViewController : UIViewController {

	UILabel *operationCountOutput;
	UILabel *operationOutput;
	
	NSOperationQueue *workQueue;
	
	JobUnit			 *jobA;
	JobUnit			 *jobB;
	JobUnit			 *jobC;
	
}

@property(nonatomic, retain)IBOutlet UILabel *operationCountOutput;
@property(nonatomic, retain)IBOutlet UILabel *operationOutput;

-(IBAction)buttonPressed:(id)sender;
-(void)addOp:(JobUnit *)job;
@end


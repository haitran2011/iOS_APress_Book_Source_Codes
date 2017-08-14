//
//  FetchImageOperation.h
//  Interestingness - Version 5
//
//  Created by Danton Chin on 3/29/10.
//  Copyright 2010  http://iphonedeveloperjournal.com/. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FetchImageOperation : NSOperation {

	NSURL *imageURL;
	id	  targetObject;
	SEL	  targetMethod;
	
}

-(id)initWithImageURL:(NSURL *)url target:(id)targClass targetMethod:(SEL)targClassMethod;


@end

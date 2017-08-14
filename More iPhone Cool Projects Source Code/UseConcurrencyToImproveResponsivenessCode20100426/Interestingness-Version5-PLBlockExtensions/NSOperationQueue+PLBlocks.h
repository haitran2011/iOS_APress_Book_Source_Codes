//
//  NSOperation+Blocks.h
//  NSOperationBlocks
//
//  Created by Landon Fuller on 7/4/09.
//  Copyright 2009 Plausible Labs Cooperative, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLBlockOperation : NSOperation {
@private
    void (^_block)();
}
+ (id) blockOperationWithBlock: (void (^)()) block;
- (id) initWithBlock: (void (^)()) block;
@end


@interface NSOperationQueue (PLBlocks)
- (void) pl_addOperationWithBlock: (void (^)()) block;
@end

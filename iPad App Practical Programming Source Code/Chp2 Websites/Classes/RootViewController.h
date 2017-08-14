//
//  RootViewController.h
//  Websites
//
//  Created by Chen Li on 8/13/10.
//  Copyright Chen Li 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
}

// IBOutlet means: it is managed by an .xib file. 
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end

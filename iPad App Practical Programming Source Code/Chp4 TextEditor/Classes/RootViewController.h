//
//  RootViewController.h
//  TextEditor
//
//  Created by Chen Li on 8/25/10.
//  Copyright Chen Li 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end

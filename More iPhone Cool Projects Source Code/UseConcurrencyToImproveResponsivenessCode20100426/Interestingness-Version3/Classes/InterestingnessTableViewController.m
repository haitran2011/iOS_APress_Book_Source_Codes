//
//  InterestingnessTableViewController.m
//  Interestingness - Version 3
//
//  Created by Danton Chin on 3/24/10.
//  Copyright 2010  http://iphonedeveloperjournal.com/. All rights reserved.
//

#import "InterestingnessTableViewController.h"

#import "JSON.h"

#define API_KEY @"ENTER YOUR API_KEY HERE"

@implementation InterestingnessTableViewController

-(void)fetchInterestingnessList
{
	
	NSAutoreleasePool *localPool;
	
	@try {
		localPool = [[NSAutoreleasePool alloc] init];
		
		if ([NSThread isMainThread]) {
			NSLog(@"fetchInterestingnessList is executing in the main thread");
		} else {
			NSLog(@"fetchInterestingnessList is executing in a background thread");
		}
		
		NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=%@&tags=&per_page=%d&format=json&nojsoncallback=1", API_KEY, 500];
		
		NSURL *url = [NSURL URLWithString:urlString];
		
		NSError *error = nil;
		
		NSString *jsonResultString    = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
		
		NSDictionary *results = [jsonResultString JSONValue];
		
		[self performSelectorOnMainThread:@selector(disaggregateInterestingnessList:) withObject:results waitUntilDone:NO];
		
	}
	@catch (NSException * exception) {
		// handle the error -- do not rethrow it
		NSLog(@"error %@", [exception reason]);
	}
	@finally {
		[localPool release];
	}
	

}


-(void)disaggregateInterestingnessList:(NSDictionary *)results
{
	if ([NSThread isMainThread]) {
		NSLog(@"disaggregateInterestingnessList is executing in the main thread");
	} else {
		NSLog(@"disaggregateInterestingnessList is executing in a background thread");
	}
		
    NSArray *imagesArray = [[results objectForKey:@"photos"] objectForKey:@"photo"];
	
    for (NSDictionary *image in imagesArray) {
        // build the url to the image
        if ([image objectForKey:@"id"] != [NSNull null]) {
            NSString *imageURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg",
                                        [image objectForKey:@"farm"],
                                        [image objectForKey:@"server"],
                                        [image objectForKey:@"id"],
                                        [image objectForKey:@"secret"]];
            
            [imageURLs addObject:[NSURL URLWithString:imageURLString]];
			
            // get the image title
			
            NSString *imageTitle = [image objectForKey:@"title"];
			
            [imageTitles addObject:([imageTitle length] > 0 ? imageTitle : @"Untitled")];
			
        }
		
    }
	
	[[self tableView] reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    if (self = [super initWithStyle:style]) {
		imageTitles = [[NSMutableArray alloc] init];
		imageURLs  = [[NSMutableArray alloc] init];
    }
    return self;
}


/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self performSelectorInBackground:@selector(fetchInterestingnessList) withObject:nil];

}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [imageURLs count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // set the title
	
	[[cell textLabel] setText:[imageTitles objectAtIndex:[indexPath row]]];
	
	// fetch the image
	
	NSData *data = [NSData dataWithContentsOfURL:[imageURLs objectAtIndex:[indexPath row]]];
	
	// set the cell's image
	
	[[cell imageView] setImage:[UIImage imageWithData:data]];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end


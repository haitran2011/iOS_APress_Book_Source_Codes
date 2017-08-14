//
//  ViewController.m
//  wanderBoard
//
//  Created by Stephen Moraco on 12/05/21.
//  Copyright (c) 2012 Iron Sheep Productions, LLC. All rights reserved.
//

#import "ViewController.h"
#import "MovementSegue.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize btnReverse;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    BOOL bIsMovToParent = [self isMovingToParentViewController];

    // non terminal dead-end screens have a reverse button w/tag=1 (dead-end end screens have tag=0)
    if(bIsMovToParent && self.btnReverse.tag == 1)
    {
        // we have arrived at this screen from another so hide our reverse button
        self.btnReverse.hidden = YES;
    }
    else if(self.btnReverse.tag == 1) 
    {
        // we have returned here by presssing reverse button at dead-end screen so show this reverse btn!
        self.btnReverse.hidden = NO;
    }
}

	- (void)viewDidUnload
{
    [self setBtnReverse:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations (our two landscape forms only)
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *strSegueID = [segue identifier];
    
    // inform our custom transition of movement direction
    if([strSegueID isEqualToString:@"Left"])
    {
        self.view.tag = MV_LEFT;
    }
    else if([strSegueID isEqualToString:@"Right"])
    {
        self.view.tag = MV_RIGHT;
    }
    else if([strSegueID isEqualToString:@"Forward"])
    {
        self.view.tag = MV_FORWARD;
    }
}

- (IBAction)onReversePress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

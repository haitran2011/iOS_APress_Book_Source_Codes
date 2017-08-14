//
//  PhotoViewController.m
//  FlickrPhotoMap
//
//  Created by Yulia McCarthy on 5/30/12.
//  Copyright (c) 2012 InspireSmart Solutions, Inc. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoAnnotation.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController
@synthesize photoImageView;
@synthesize photoTitleLabel;
@synthesize photoAnnotation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.image = self.photoAnnotation.image;
    self.photoTitleLabel.text = self.photoAnnotation.title;
}

- (void)viewDidUnload
{
    [self setPhotoImageView:nil];
    [self setPhotoTitleLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

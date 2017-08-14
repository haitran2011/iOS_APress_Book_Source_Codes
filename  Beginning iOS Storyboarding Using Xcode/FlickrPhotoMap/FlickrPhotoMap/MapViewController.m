//
//  MapViewController.m
//  FlickrPhotoMap
//
//  Created by Yulia McCarthy on 5/28/12.
//  Copyright (c) 2012 InspireSmart Solutions, Inc. All rights reserved.
//

#import "MapViewController.h"
#import "PhotoAnnotation.h"
#import "PhotoViewController.h"
#import "PinSelectionViewController.h"

NSString *const FlickrAPIKey = @"562ce9dc2086e773508d66bed9a7c068";
NSString *const FlickrUserId = @"70227599@N07";

@interface MapViewController()  // private
{ 
@private
    NSMutableDictionary *parsedPhotosDictionary;
    NSUInteger totalNumberOfPhotos;
    NSUInteger updatesCount;
}

- (void)searchFlickrPhotos;
- (void)saveGeoCodeData:(NSData *)data;
- (void)saveGeoCodeData:(NSData *)data;
- (void)populateMapWithPhotoAnnotations;

@end

@implementation MapViewController
@synthesize mapView;
@synthesize activityIndicator;

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
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
	region.center.latitude = 38.311491; 
	region.center.longitude = -105.24353;
	region.span.longitudeDelta = 1.5f;
	region.span.latitudeDelta = 1.5f;	
    [self.mapView setRegion:region animated:YES];
    [self.mapView setDelegate:self];
    
    [self searchFlickrPhotos];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    if ([segue.identifier isEqualToString:@"ShowFullSizeImageSegue"]) {
        
        PhotoViewController *photoVC = [segue destinationViewController];
        
        PhotoAnnotation *selectedAnnotation = (PhotoAnnotation *)sender;    
        photoVC.photoAnnotation = selectedAnnotation;
    }
    if ([segue.identifier isEqualToString:@"ShowPinChoicesSegue"]) {
        
        PinSelectionViewController *pinVC = [segue destinationViewController];
        
        PhotoAnnotation *selectedAnnotation = (PhotoAnnotation *)sender;    
        pinVC.currentPinType = selectedAnnotation.pinType;
        pinVC.delegate = self;
    }
}

#pragma mark - Flickr API Processing

- (void)searchFlickrPhotos 
{
        [self.activityIndicator startAnimating];
    
    // Build the string to call the Flickr API
	NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&user_id=%@&has_geo=1&format=json&nojsoncallback=1", FlickrAPIKey, FlickrUserId];

    NSLog(@"URL string: %@", urlString);

    // Send request to search for photos in a thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]; 
        [self performSelectorOnMainThread:@selector(saveData:) withObject:data waitUntilDone:YES];
    });

}

- (void)saveData:(NSData *)data 
{
    NSError *error = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *photos = [[response objectForKey:@"photos"] objectForKey:@"photo"];
    
    totalNumberOfPhotos = photos.count;
    parsedPhotosDictionary = [NSMutableDictionary dictionaryWithCapacity:totalNumberOfPhotos];
    updatesCount = 0;
    
    for (NSMutableDictionary *photoInfo in photos) {
        NSString *thumbnailURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_t.jpg", [photoInfo objectForKey:@"farm"], 
                                        [photoInfo objectForKey:@"server"], [photoInfo objectForKey:@"id"], [photoInfo objectForKey:@"secret"]];
        
        // Construct the URL to where the medium size image is located on Flickr (to zoom to when requested)
        NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@.jpg", [photoInfo objectForKey:@"farm"], 
                                    [photoInfo objectForKey:@"server"], [photoInfo objectForKey:@"id"], [photoInfo objectForKey:@"secret"]];
        
        // Construct the URL to location information where image was taken (for geotagged images)
        NSString *photoGeoInfoURLString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", 
                                           FlickrAPIKey, [photoInfo objectForKey:@"id"]];
        // Save constructed URLs for later use 
        [photoInfo setObject:[NSURL URLWithString:thumbnailURLString] forKey:@"thumbnailurl"];
        [photoInfo setObject:[NSURL URLWithString:photoURLString] forKey:@"mediumimageurl"];
        
        [parsedPhotosDictionary setObject:photoInfo forKey:[photoInfo valueForKey:@"id"]];
        
        // Send request to get geocode for each photo
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoGeoInfoURLString]]; 
            [self performSelectorOnMainThread:@selector(saveGeoCodeData:) withObject:data waitUntilDone:YES];
        });
    }
}

- (void)saveGeoCodeData:(NSData *)data 
{
    updatesCount++;
    NSError *error = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        NSString *photoId = [[response objectForKey:@"photo"] objectForKey:@"id"];
        NSString *photoLatitude = [[[response objectForKey:@"photo"] objectForKey:@"location"] objectForKey:@"latitude"];
        NSString *photoLongitude = [[[response objectForKey:@"photo"] objectForKey:@"location"] objectForKey:@"longitude"];
        
        NSMutableDictionary *photoInfo = [parsedPhotosDictionary objectForKey:photoId];
        [photoInfo setObject:photoLatitude forKey:@"latitude"];
        [photoInfo setObject:photoLongitude forKey:@"longitude"];
    }
    if (updatesCount == totalNumberOfPhotos) {
        [self.activityIndicator stopAnimating];
        [self populateMapWithPhotoAnnotations];
    }
}

- (void)populateMapWithPhotoAnnotations
{
    NSMutableArray *photoAnnotations = [[NSMutableArray alloc] init];
    
    for (NSDictionary *photoDict in [parsedPhotosDictionary allValues]) 
    {
        // Read the image's metadata
        NSURL *photoURL = [photoDict objectForKey:@"mediumimageurl"];
        NSURL *thumbnailURL = [photoDict objectForKey:@"thumbnailurl"];
        NSString *photoLat = [photoDict objectForKey:@"latitude"];
        NSString *photoLon = [photoDict objectForKey:@"longitude"];
        
        if (photoLat && photoLon) {
            CLLocationCoordinate2D coord;
            coord.latitude = [photoLat doubleValue];
            coord.longitude = [photoLon doubleValue];
            
            NSString *fileName = [photoDict objectForKey:@"title"];;
            PhotoAnnotation *photo = [[PhotoAnnotation alloc] initWithImageURL:photoURL thumbnailURL:thumbnailURL title:fileName coordinate:coord];
            [photoAnnotations addObject:photo];
        }
    }
    
    if (photoAnnotations.count > 0) {
        [mapView addAnnotations:photoAnnotations];
    }
    
    parsedPhotosDictionary = nil;
}



-(void)userDidSelectPinType:(AnnotationPinType)aPinType
{
    PhotoAnnotation *selectedAnnotation = (PhotoAnnotation *)[mapView.selectedAnnotations objectAtIndex:0];
    selectedAnnotation.pinType = aPinType;
    [mapView removeAnnotation:selectedAnnotation];
    [mapView addAnnotation:selectedAnnotation];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - MKMapViewDelegate Protocol
#pragma mark -

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation 
{
    if ([annotation isKindOfClass:[PhotoAnnotation class]]) {
        // Use our pin image for annotation, with a disclosure button callout accessory

        MKAnnotationView *annotationView = (MKAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:((PhotoAnnotation *)annotation).annotationViewImageName];
        
        if (annotationView == nil)
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:((PhotoAnnotation *)annotation).annotationViewImageName];
        
        annotationView.image = [UIImage imageNamed:((PhotoAnnotation *)annotation).annotationViewImageName];
        annotationView.canShowCallout = YES;
        
        UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = disclosureButton;
        
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (![view.annotation isKindOfClass:[PhotoAnnotation class]])
        return;
    
    PhotoAnnotation *photoAnnotation = (PhotoAnnotation *)view.annotation;
 
    if (control.tag == 0) {
        [self performSegueWithIdentifier:@"ShowFullSizeImageSegue" sender:photoAnnotation];
    } else {
        [self onLeftCalloutAccessoryViewTouched:control];
    }

}




- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[PhotoAnnotation class]])
        return;
    
    // Reverse geocode the annotation if needed
    PhotoAnnotation *photoAnnotation = (PhotoAnnotation *)view.annotation;
    if (!photoAnnotation.subtitle)
        [photoAnnotation updateSubtitle];
    
    if (!view.leftCalloutAccessoryView) {
        UIButton *leftViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 48.0, 32.0)];
        [leftViewButton setBackgroundImage:photoAnnotation.thumbnail forState:UIControlStateNormal];
        [leftViewButton addTarget:self action:@selector(onLeftCalloutAccessoryViewTouched:) forControlEvents:UIControlEventTouchUpInside];
        leftViewButton.tag = 1;
        view.leftCalloutAccessoryView = leftViewButton;
    }
}


- (void)onLeftCalloutAccessoryViewTouched:(id)sender
{
    PhotoAnnotation *selectedAnnotation = (PhotoAnnotation *)[mapView.selectedAnnotations objectAtIndex:0];
    [self performSegueWithIdentifier:@"ShowPinChoicesSegue" sender:selectedAnnotation];
}

@end

//
//  ViewController.m
//  Get On That Bus
//
//  Created by David Warner on 5/28/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController () <MKMapViewDelegate , UITableViewDataSource, UITableViewDelegate>
@property NSArray *stopsArray;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *stopsTableView;
@property NSDictionary *selectedDictionary;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    NSString *urlString = @"https://s3.amazonaws.com/mobile-makers-lib/bus.json";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *dictionary  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
         self.stopsArray = [dictionary objectForKey:@"row"];

         for (NSDictionary *dictionary in self.stopsArray) {

             NSString *longitudeString = [dictionary objectForKey:@"longitude"];
             NSString *latitudeString = [dictionary objectForKey:@"latitude"];
             float longitudeFloat = longitudeString.floatValue;
             float latitudeFloat = latitudeString.floatValue;
             self.busAnnotation = [[MKPointAnnotation alloc] init];
             self.busAnnotation.coordinate = CLLocationCoordinate2DMake(latitudeFloat, longitudeFloat);

             NSString *stopName = [dictionary objectForKey:@"cta_stop_name"];
             self.busAnnotation.title = stopName;
             NSString *routeName = [dictionary objectForKey:@"routes"];
             self.busAnnotation.subtitle = routeName;

             [self.mapView addAnnotation:self.busAnnotation];
             [self.stopsTableView reloadData];
         }
     }];

    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(41.86, -87.7);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.45, 0.45);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    [self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    UIImageView *imageViewPace = [[UIImageView alloc] init];
    imageViewPace.image = [UIImage imageNamed:@"pace"];
    UIImageView *imageViewMetra = [[UIImageView alloc] init];
    imageViewPace.image = [UIImage imageNamed:@"metra"];

    for (NSDictionary *stop in self.stopsArray) {
        if ([[stop objectForKey:@"inter_modal"] isEqualToString:@"Pace"]) {
            pin.leftCalloutAccessoryView = imageViewPace;
        }
        else if ([[stop objectForKey:@"inter_modal"] isEqualToString:@"Metra"]){
            pin.leftCalloutAccessoryView = imageViewMetra;
        }
    }
    return pin;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"segue" sender:self];
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view
{

    for (NSDictionary *dictionary in self.stopsArray)
    {
        if (view.annotation.title == [dictionary objectForKey:@"cta_stop_name"]) {
            self.selectedDictionary = dictionary;
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:control
{
    DetailViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.dictionaryFromMap = self.selectedDictionary;
    [destinationViewController.navigationItem setTitle:[self.selectedDictionary objectForKey:@"cta_stop_name"]];
}



- (IBAction)toggleViewController:(id)sender
{

    [self segmentChanged:sender];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stopsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    NSDictionary *dictionary = [self.stopsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dictionary objectForKey:@"cta_stop_name"];

    NSString *routes = [dictionary objectForKey:@"routes"];
    NSString *routesSpaces = [routes stringByReplacingOccurrencesOfString:@"," withString:@", "];
    cell.detailTextLabel.text = routesSpaces;

    return cell;
}

- (void)segmentChanged:(id)sender
{
    switch ([sender selectedSegmentIndex]) {
        case 0:
        {
            self.stopsTableView.hidden = YES;
            self.mapView.hidden = NO;
            break;
        }
        case 1:
        {
            self.stopsTableView.hidden = NO;
            self.mapView.hidden = YES;
            break;
        }
        default:
            break;
    }
}




@end

//
//  DetailViewController.m
//  Get On That Bus
//
//  Created by David Warner on 5/28/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *routesLabel;
@property (weak, nonatomic) IBOutlet MKMapView *detailMapView;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;

@end

@implementation DetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *routes = [self.dictionaryFromMap objectForKey:@"routes"];
    NSString *routesNoSpaces = [routes stringByReplacingOccurrencesOfString:@"," withString:@", "];
    self.routesLabel.text = routesNoSpaces;


    NSString *longitudeString = [self.dictionaryFromMap objectForKey:@"longitude"];
    NSString *latitudeString = [self.dictionaryFromMap objectForKey:@"latitude"];
    float longitudeFloat = longitudeString.floatValue;
    float latitudeFloat = latitudeString.floatValue;

    self.detailPointLocation = [[MKPointAnnotation alloc] init];
    self.detailPointLocation.coordinate = CLLocationCoordinate2DMake(latitudeFloat, longitudeFloat);

    NSString *stopName = [self.dictionaryFromMap objectForKey:@"cta_stop_name"];
    self.detailPointLocation.title = stopName;
    NSString *routeName = [self.dictionaryFromMap objectForKey:@"routes"];
    self.detailPointLocation.subtitle = routeName;

    [self.detailMapView addAnnotation:self.detailPointLocation];

    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitudeFloat, longitudeFloat);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.025, 0.025);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    [self.detailMapView setRegion:region animated:YES];


    NSString *direction = [self.dictionaryFromMap objectForKey:@"direction"];
    if ([direction isEqual: @"NB"]) {
        self.directionLabel.text = @"Northbound";
        }
    else if ([direction isEqual: @"SB"]) {
        self.directionLabel.text = @"Southbound";
    }
    else if ([direction isEqual: @"WB"]) {
        self.directionLabel.text = @"Westbound";
    }
    else if ([direction isEqual: @"EB"]) {
        self.directionLabel.text = @"Eastbound";
    }

}




@end

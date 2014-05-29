//
//  DetailViewController.h
//  Get On That Bus
//
//  Created by David Warner on 5/28/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController

@property NSDictionary *dictionaryFromMap;
@property MKPointAnnotation *detailPointLocation;

@end

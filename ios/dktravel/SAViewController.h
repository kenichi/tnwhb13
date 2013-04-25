//
//  SAViewController.h
//  dktravel
//
//  Created by Kenichi Nakamura on 4/24/13.
//  Copyright (c) 2013 sa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD/MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "AFNetworking.h"

@interface SAViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *currentCity;
@property (strong, nonatomic) NSMutableDictionary *entries;

@end

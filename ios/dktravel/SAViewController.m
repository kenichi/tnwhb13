//
//  SAViewController.m
//  dktravel
//
//  Created by Kenichi Nakamura on 4/24/13.
//  Copyright (c) 2013 sa. All rights reserved.
//

#import "SAViewController.h"

static NSArray *guidebookCities;

@interface SAViewController ()
{
    CLLocationManager *locationManager;
    AFHTTPClient *_httpClient;
}

@end

@implementation SAViewController

@synthesize currentCity;
@synthesize entries;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self startLocationManagerForReverseGeocodingCity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - help

// does pearson have a guidebook for the city?
//
+ (BOOL)guidebookExistsFor:(NSString *)city
{
    if (guidebookCities.count == 0) {
        guidebookCities = @[ @"London", @"New York", @"Paris", @"Washington", @"Berlin", @"Rome", @"Barcelona", @"Venice", @"Prague" ];
    }
    return ([guidebookCities indexOfObject:city] != NSNotFound);
}

#pragma mark - location

- (void)startLocationManagerForReverseGeocodingCity
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    CLLocation *mostCurrentLocation = [locations lastObject];
    [self geocode:mostCurrentLocation];
}

- (void)geocode:(CLLocation *)location
{
    __block NSString *geocodedCity;
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        
        if (placemarks && placemarks.count > 0)
        {
            CLPlacemark *placemark = placemarks[0];
            NSDictionary *addressDictionary = placemark.addressDictionary;
            geocodedCity = [addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
            NSLog(@"found city: %@", geocodedCity);
        }
        
        if ([SAViewController guidebookExistsFor:geocodedCity]) {
            
            self.currentCity = geocodedCity;
            
            NSString *lat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
            NSString *lng = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
            
            NSDictionary *params = @{@"guidebook": geocodedCity,
                                     @"latitude": lat,
                                     @"longitude": lng,
                                     @"create_triggers": @"true"};
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self runRequest:@"GET"
                    withPath:@"entries.json"
               andParameters:params
                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//                         NSLog(@"F YES: %@", JSON);
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         for (NSDictionary *dict in JSON) {
//                             NSLog(@"entry: %@", dict);
                             NSString *identifier = [dict objectForKey:@"id"];
                             if ([self.entries objectForKey:identifier] == nil) {
                                 
                                 MKPointAnnotation *pa = [MKPointAnnotation new];
                                 pa.title = [dict objectForKey:@"title"];
                                 CLLocationDegrees entryLat = [[dict objectForKey:@"latitude"] floatValue];
                                 CLLocationDegrees entryLng = [[dict objectForKey:@"longitude"] floatValue];
                                 pa.coordinate = CLLocationCoordinate2DMake(entryLat, entryLng);
                                 
                                 MKPinAnnotationView * pav = [[MKPinAnnotationView alloc] initWithAnnotation:pa
                                                                                             reuseIdentifier:[dict objectForKey:identifier]];
                                 pav.animatesDrop = YES;
                                 
                                 [self.mapView addAnnotation:pa];
                                 [self.entries setObject:pav forKey:identifier];
                             }
                             
                         }
                         
                     }
                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                         NSLog(@"OH NOES: %@", error);
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                     }
            ];
        }
    }];
}

#pragma mark - networking

- (AFHTTPClient *)httpClient
{
    if (_httpClient == nil) {
        _httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://localhost:9292/"]];
        _httpClient.parameterEncoding = AFFormURLParameterEncoding;
    }
    return _httpClient;
}

- (NSOperation *)runRequest:(NSString *)method
                   withPath:(NSString *)path
              andParameters:(NSDictionary *)parameters
                    success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))successBlock
                    failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failureBlock
{
    NSLog(@"runRequest %@", path);
    NSMutableURLRequest *request = [[self httpClient] requestWithMethod:method path:path parameters:parameters];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:successBlock
                                                                                 failure:failureBlock];
    NSLog(@"Submitting API Request: %@ %@", method, request.URL);
    [[self httpClient] enqueueHTTPRequestOperation:op];
    
    return op;
}

@end
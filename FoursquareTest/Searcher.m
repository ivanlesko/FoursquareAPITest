//
//  Searcher.m
//  MKLocalSearchTest
//
//  Created by Ivan Lesko on 9/3/14.
//  Copyright (c) 2014 GeneralUI. All rights reserved.
//

#import "Searcher.h"
#import <MapKit/MapKit.h>
#import <AFNetworking/AFNetworking.h>

#define clientID      @"RIB0TWQULGP1HNZT44CL1W40LTU5PFK5ZYQDQTN5YRHSI1QQ"
#define client_secret @"XEJIVF2QPYSC0QDC1YMBDDHC2DIGPJMCCC4O5BFJJRAH2PJP"
#define VERSION       @"20130815"
#define BASE_URL      @"https://api.foursquare.com/v2/venues/"

@interface Searcher ()
{
    
}

@property (nonatomic, strong) NSMutableArray *queries;
@property (nonatomic) CLLocationCoordinate2D currentLocation;

@end

@implementation Searcher

- (id)init {
    if (self == [super init]) {
        
    }
    
    return self;
}

- (void)beginSearch {
    MKCoordinateSpan regionSpan;
    regionSpan.latitudeDelta  = 0.0000001;
    regionSpan.longitudeDelta = 0.0000001;
    
    CLLocationCoordinate2D genUICoords;
    genUICoords.latitude  = 47.649897;
    genUICoords.longitude = -122.349777;
    
    CLLocationCoordinate2D covingtonCoords;
    covingtonCoords.latitude  = 47.357838;
    covingtonCoords.longitude = -122.108396;
    
    CLLocationCoordinate2D theLandingCoords;
    theLandingCoords.latitude  = 47.498909;
    theLandingCoords.longitude = -122.202269;
    
    
    self.currentLocation = genUICoords;
    
    [self findRestaurantsResults];
}

- (void)findRestaurantsResults {
    NSString *searchString = [NSString stringWithFormat:@"%@search?client_id=%@&client_secret=%@&v=%@&ll=%f,%f&limit=%d&category=%@&radius=%d",
                              BASE_URL,
                              clientID,
                              client_secret,
                              VERSION,
                              self.currentLocation.latitude,
                              self.currentLocation.longitude,
                              40,   // request limit
                              @"4d4b7105d754a06377d81259", // this is the food category.
                              10 // radius
                              ];
    NSLog(@"%@", searchString);
    printf("\n");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *response = (NSDictionary *)[responseObject objectForKey:@"response"];
             NSArray *venues = response[@"venues"];
             for (NSDictionary *venue in venues) {
                 CLLocationDegrees lat = [(NSNumber *)[[venue objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
                 CLLocationDegrees lng = [(NSNumber *)[[venue objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
                 CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat, lng);
                 NSString *coordsString = [self stringFromCL2D:CLLocationCoordinate2DMake(coords.latitude, coords.longitude)];
                 NSLog(@"%@, %@, \t%@", venue[@"name"], venue[@"location"][@"formattedAddress"][0], coordsString);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"error: %@", error.localizedDescription);
         }];
}

- (NSString *)stringFromCL2D:(CLLocationCoordinate2D)coords {
    return [NSString stringWithFormat:@"{ %f , %f }", coords.latitude, coords.longitude];
}

@end



















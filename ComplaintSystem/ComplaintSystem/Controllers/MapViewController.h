//
//  MapViewController.h
//  ComplaintSystem
//
//  Created by yu Andy on 14-4-12.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController
@property (nonatomic,assign) CLLocationCoordinate2D lo;
@property (nonatomic,strong) NSString *address;
@end

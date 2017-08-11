//
//  GPSCoordinateHelper.m
//  JSLite
//
//  Created by liuxueyan on 14-9-2.
//  Copyright (c) 2014年 Juicyshare. All rights reserved.
//

#import "GPSCoordinateHelper.h"

@implementation GPSCoordinateHelper

const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;

+(CLLocationCoordinate2D)bd_encrypt:(CLLocationCoordinate2D)coordinate{
    
    
    CLLocationCoordinate2D bdCoordinate;
    double x = coordinate.longitude, y = coordinate.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    bdCoordinate.longitude = z * cos(theta) + 0.0065;
    bdCoordinate.latitude = z * sin(theta) + 0.006;
    return bdCoordinate;
}

+(CLLocationCoordinate2D)bd_decrypt:(CLLocationCoordinate2D)coordinate{
    
    CLLocationCoordinate2D rsCoordinate;
    double x = coordinate.longitude - 0.0065, y = coordinate.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    rsCoordinate.longitude= z * cos(theta);
    rsCoordinate.latitude = z * sin(theta);
    
    return rsCoordinate;
}

@end

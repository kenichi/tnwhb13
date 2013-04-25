//
//  SAAppDelegate.h
//  dktravel
//
//  Created by Kenichi Nakamura on 4/24/13.
//  Copyright (c) 2013 sa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGSGeotriggerManager.h"

@class SAViewController;

@interface SAAppDelegate : UIResponder <UIApplicationDelegate, AGSGeotriggerManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SAViewController *viewController;
@property (strong, nonatomic) AGSGeotriggerManager *geotriggerManager;

@end

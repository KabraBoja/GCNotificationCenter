//
//  ViewController.h
//  GCNotificationCenterPlayground
//
//  Created by Eloi Guzmán on 25/04/13.
//  Copyright (c) 2013 Eloi Guzmán. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersNotificationCenter.h"

/**
 *  Used for testing.
 */
@interface ViewController : UIViewController
{
    
    NSMutableSet * _observers; //Used only for testing, we need to maintain a strong reference to observers. (Testing notification center weak references).
    UsersNotificationCenter * _userNotificationCenter;
    UIScrollView * _scrollView; //ScrollView to test UI freeze.
    NSTimer * _timer; //Timer only for testing.
}
@end



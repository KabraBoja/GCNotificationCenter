//
//  TestingObserver.m
//  GCNotificationCenterPlayground
//
//  Created by Eloi Guzman on 01/05/13.
//  Copyright (c) 2013 Eloi Guzmán. All rights reserved.
//

#import "TestingObserver.h"



#pragma mark - Custom Observer class (only for testing)

@implementation TestingObserver

-(void)userChatReceived:(NSString *)chatMessage
{
    NSLog(@"Observer %d received userChatReceived notif %@",[self hash],nil);
    
}

-(void)usersDeleted:(NSArray *)deletedUsers
{
    NSLog(@"Observer %d received usersDeleted notif %@",[self hash],nil);
}

-(void)usersAdded:(NSArray *)addedUsers
{
    NSLog(@"Observer %d received usersAdded notif %@",[self hash],nil);
}

-(void)dealloc
{
    NSLog(@"Observer %d deallocated ",[self hash]);
}

@end

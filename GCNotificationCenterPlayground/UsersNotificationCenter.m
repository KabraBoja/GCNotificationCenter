//
//  UsersNotificationCenter.m
//  GCNotificationCenterPlayground
//
//  Created by Eloi Guzmán on 26/04/13.
//  Copyright (c) 2013 Eloi Guzmán. All rights reserved.
//

#import "UsersNotificationCenter.h"

@implementation UsersNotificationCenter

#pragma mark - Init mehtods

- (id)init
{
    self = [super initWithProtocol:@protocol(UserManagementNotifications)];
    if (self) {
        
    }
    return self;
}

#pragma mark - User Management Notifications (example)

-(void)notifyUserChatReceived:(NSString*)chatMessage
{
    [self sendNotificationWithBlockUsingQueue:^(NSObject<UserManagementNotifications> *observer) {
        [observer userChatReceived:chatMessage];
    }];
}

-(void)notifyUsersAdded:(NSArray*)users
{
    [self sendNotificationWithBlockUsingQueuedBlocks:^(NSObject<UserManagementNotifications> *observer) {
        [observer usersAdded:users];
    }];
}

-(void)notifyUsersDeleted:(NSArray*)users
{
    [self sendNotificationWithBlockWaitUntilFinished:^(NSObject<UserManagementNotifications> *observer) {
        [observer usersDeleted:users];
    }];
}



@end

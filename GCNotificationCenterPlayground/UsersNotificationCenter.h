//
//  UsersNotificationCenter.h
//  GCNotificationCenterPlayground
//
//  Created by Eloi Guzmán on 26/04/13.
//  Copyright (c) 2013 Eloi Guzmán. All rights reserved.
//

#import "GCBaseNotificationCenter.h"

#pragma mark - User Notification center protocol (example)
@protocol UserManagementNotifications <NSObject>
-(void)userChatReceived:(NSString*)chatMessage;
-(void)usersAdded:(NSArray*)addedUsers;
-(void)usersDeleted:(NSArray*)deletedUsers;
@end



#pragma mark - Concrete User Management Notification Center (example)


/**
 *  Custom Notification Center (example)
 */
@interface UsersNotificationCenter : GCBaseNotificationCenter
-(void)notifyUserChatReceived:(NSString*)chatMessage;
-(void)notifyUsersAdded:(NSArray*)users;
-(void)notifyUsersDeleted:(NSArray*)users;
@end

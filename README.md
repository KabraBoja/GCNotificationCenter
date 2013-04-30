GCNotificationCenter
====================

This is a Custom Notification Center for iOS. It works subclassing a base Notification Center and providing a protocol to implement by the concrete observers. Works with blocks and operation queues, so you can perform any operation without NSNotification objects and without blocking the UI main thread.

##How to:

####Create a protocol to implement by the observers

You have to declare a new protocol, that will be implemented by your observers. This example shows a User Management Notification Center protocol that will notify when users are added, deleted or when the client receives a new chat message. For each type of notification you have to declare a new method.
	
	#pragma mark - User Notification center protocol (example)
	
	@protocol UserManagementNotifications <NSObject>
	
	-(void)userChatReceived:(NSString*)chatMessage;
	-(void)usersAdded:(NSArray*)addedUsers;
	-(void)usersDeleted:(NSArray*)deletedUsers;
	
	@end
	
####Create your custom Notification Center class

Subclass the GCBaseNotificationCenter and declare your custom notification methods into the class interface.

	#pragma mark - Concrete User Management Notification Center (example)

	/**
	 *  Custom Notification Center (example)
	 */
	@interface UsersNotificationCenter : GCBaseNotificationCenter
	
	-(void)notifyUserChatReceived:(NSString*)chatMessage;
	-(void)notifyUsersAdded:(NSArray*)users;
	-(void)notifyUsersDeleted:(NSArray*)users;
	
	@end

	@implementation UsersNotificationCenter

	#pragma mark - Init mehtods

	- (id)init
	{
	    self = [super initWithProtocol:@protocol(UserManagementNotifications)];
	    if (self) {
	        
	    }
	    return self;
	}

####Implement your custom notifications

Implement the different notification types using GCNotificationBlock. Each notification block will be executed for every observer when you launch the notification. There are three different types of notifications:

* sendNotificationWithBlockUsingQueue
* sendNotificationWithBlockUsingQueuedBlocks
* sendNotificationWithBlockWaitUntilFinished

Example:

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


####Init your NotificationCenter

Init the new custom UserNotificationCenter notification center.

    _userNotificationCenter = [[UsersNotificationCenter alloc]init];

####Add observers

Add observers as usual in a normal NSNotificationCenter. Remember that notification center doesn't retain the observers.

        TestingObserver * newObserver = [[TestingObserver alloc]init];
        [_userNotificationCenter addGCObserver:newObserver];

####Remove observers

Remove observers as usual in a normal NSNotificationCenter.

        [_userNotificationCenter removeGCObserver:newObserver];

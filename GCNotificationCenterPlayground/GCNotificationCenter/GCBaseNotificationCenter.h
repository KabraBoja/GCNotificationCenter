//
//  GCBaseNotificationCenter.h
//  GCNotificationCenterPlayground
//
//  Created by Eloi Guzmán on 25/04/13.
//  Copyright (c) 2013 Eloi Guzmán. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^GCNotificationBlock)(NSObject * observer);

@interface GCBaseNotificationCenter : NSObject
{
    NSMutableSet * _observers;
    Protocol * _protocol;
    NSOperationQueue * _notificationCenterQueue;
    NSRecursiveLock * _lock;
}

/**
 *  Adds a new observer to the Notification Center. You cannot add the same observer more than once. You cannot
 *  add an observer that doesn't implement the Concrete Notification Center protocol.
 *
 */
-(void)addGCObserver:(NSObject *)observer;

/**
 *  Remove an existing observer from the Notification Center. You cannot remove a non attached observer.
 *
 *  IMPORTANT: You have to remove all observer when they are not used any more because it may become a future
 *  zombie object.
 */
-(void)removeGCObserver:(NSObject *)observer;


/**
 *  Inits a new Concrete Notification Center.
 *
 *  @param protocol The protocol that has to be implemented by the added observers.
 */
-(GCBaseNotificationCenter*)initWithProtocol:(Protocol*)protocol;


/**
 *  Inits a new Concrete Notification Center.
 *
 *  @param protocol The protocol that has to be implemented by the added observers.
 *  @param queue By default the Main queue is used, but you can assign any other one created. If you
 *  user a different queue you have to add and remove observers from this concrete queue to avoid 
 *  possible incosistencies.
 */
-(GCBaseNotificationCenter*)initWithProtocol:(Protocol*)protocol andQueue:(NSOperationQueue*)queue;


/**
 *  This method ensures that Notification will be propagated sequentially (may block UI if
 *  performed from Main Thread Queue)
 *
 *  Ensure sequential execution!
 *
 *  IMPORTANT: You have to call this method from the same queue that you have created the Notification Center 
 *  to secure the thread safe.
 *  
 *  This method may block the UI but it's the Fastest. That's because adding operations and working with queues has a 
 *  high performance impact.
 */
-(void)sendNotificationWithBlockWaitUntilFinished:(GCNotificationBlock)notification_block;


/**
 *  This method ensures that Notifications will be performed on a queue but not sequentially. This method enqueues
 *  blocks of operations. For each group of observers a notification operation is created.
 *
 *  Ensure concurrent execution.
 */
-(void)sendNotificationWithBlockUsingQueue:(GCNotificationBlock)notification_block;




/**
 *  This method add one diferent block for each different observer, ensuring the most concurrent execution.
 *  Adding one different operation for observer ensures that notifications will be propagated in
 *  separated chunck of execution. Allowing the UI to not frezee, But losing the sequential
 *  control over execution.
 */
-(void)sendNotificationWithBlockUsingQueuedBlocks:(GCNotificationBlock)notification_block;
@end

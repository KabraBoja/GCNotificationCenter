//
//  GCBaseNotificationCenter.m
//  GCNotificationCenterPlayground
//
//  Created by Eloi Guzmán on 25/04/13.
//  Copyright (c) 2013 Eloi Guzmán. All rights reserved.
//

#import "GCBaseNotificationCenter.h"




@implementation GCBaseNotificationCenter

-(GCBaseNotificationCenter*)initWithProtocol:(Protocol*)protocol
{
    NSOperationQueue * mainQ = [NSOperationQueue mainQueue];
    //[mainQ setMaxConcurrentOperationCount:3];
    self = [self initWithProtocol:protocol andQueue:mainQ];
    if (self) {
    }
    return self;
}

-(GCBaseNotificationCenter *)initWithProtocol:(Protocol *)protocol andQueue:(NSOperationQueue *)queue
{
    self = [super init];
    if (self) {
        //Protocol implemented by the observers.
        NSAssert(protocol != nil,@"Protocol cannot be nil");
        _protocol = protocol;
        
        //Unretained mutable map table.
        _observers = [NSMapTable weakToWeakObjectsMapTable];
        
        //Reatined mutable set. (Not use, creates cyclic references)
        //_observers = [[NSMutableSet alloc]init];
        
        //Concrete thread queue. (By default: main queue)
        NSAssert(queue != nil,@"Queue cannot be nil");
        _notificationCenterQueue = queue;
        _lock = [[NSRecursiveLock alloc]init];
    }
    return self;
}

-(void)addGCObserver:(id)observer
{
    NSAssert(observer != nil,@"Observer to add cannot be nil");
    [_lock lock];
    
    // [_notificationCenterQueue addOperationWithBlock:^{
    if ([_observers objectForKey:observer]){
        NSAssert(NO,@"Cannot add the same observer more than once");
    }
    
    if (![observer conformsToProtocol:_protocol]) {
        NSAssert(NO,@"Cannot add an observer that doesnt implement the concrete notification center protocol");
    }
    [_observers setObject:observer forKey:observer];
    // }];
    
    [_lock unlock];
}



-(void)removeGCObserver:(id)observer
{
    NSAssert(observer != nil,@"Observer to remove cannot be nil");
    [_lock lock];
    
    //[_notificationCenterQueue addOperationWithBlock:^{
    if (![_observers objectForKey:observer]) {
        NSAssert(NO,@"Cannot remove the same observer more than once");
    }
    [_observers removeObjectForKey:observer];
    //}];
    
    [_lock unlock];
}

-(id)init
{
    // Force the programmer to work using interfaces and adquiring "good coding practices".
    // Avoiding unknown/ghost notifications in the middle of the code.
    NSAssert(NO,@"You cannot init a GCNotificationCenter without a protocol, use initWithProtocol method instead");
    return nil;
}



-(void)sendNotificationWithBlockWaitUntilFinished:(GCNotificationBlock)notification_block
{
    [_lock lock];
    for (id obj in [_observers objectEnumerator]) {
        notification_block((NSObject*)obj);
    }
    [_lock unlock];
}


-(void)sendNotificationWithBlockUsingQueue:(GCNotificationBlock)notification_block
{
    [_lock lock];
    [_notificationCenterQueue addOperationWithBlock:^{
        for (id obj in [_observers objectEnumerator]) {
            notification_block((NSObject*)obj);
        }
    }];
    [_lock unlock];
}


-(void)sendNotificationWithBlockUsingQueuedBlocks:(GCNotificationBlock)notification_block
{
    [_lock lock];
    for (id obj in [_observers objectEnumerator]) {
        [_notificationCenterQueue addOperationWithBlock:^{
            notification_block((NSObject*)obj);
        }];
    }
    [_lock unlock];
}

-(NSOperationQueue *)getQueue
{
    return _notificationCenterQueue;
}
@end

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
        
        //Unretained mutable set.
        _observers =  (__bridge_transfer NSMutableSet *)CFSetCreateMutable(nil, 0, nil);
        
        //Reatined mutable set. (Not use, creates cyclic references)
        //_observers = [[NSMutableSet alloc]init];
        
        //Concrete thread queue. (By default: main queue)
        NSAssert(queue != nil,@"Queue cannot be nil");
        _notificationCenterQueue = queue;
    }
    return self;
}

-(void)addGCObserver:(NSObject *)observer
{
    NSAssert(observer != nil,@"Observer to add cannot be nil");
    NSRecursiveLock * lock = [[NSRecursiveLock alloc]init];
    [lock lock];
    
   // [_notificationCenterQueue addOperationWithBlock:^{
        if ([_observers containsObject:observer]){
            NSAssert(NO,@"Cannot add the same observer more than once");
        }
        
        if (![observer conformsToProtocol:_protocol]) {
            NSAssert(NO,@"Cannot add an observer that doesnt implement the concrete notification center protocol");
        }
        [_observers addObject:observer];
   // }];
    
    [lock unlock];
}



-(void)removeGCObserver:(NSObject *)observer
{
    NSAssert(observer != nil,@"Observer to remove cannot be nil");
    NSRecursiveLock * lock = [[NSRecursiveLock alloc]init];
    [lock lock];
    
    //[_notificationCenterQueue addOperationWithBlock:^{
        if (![_observers containsObject:observer]) {
            NSAssert(NO,@"Cannot remove the same observer more than once");
        }
        [_observers removeObject:observer];
    //}];
    
    [lock unlock];
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
    NSRecursiveLock * lock = [[NSRecursiveLock alloc]init];
    [lock lock];
    [_observers enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        notification_block((NSObject*)obj);
    }];
    [lock unlock];
}


-(void)sendNotificationWithBlockUsingQueue:(GCNotificationBlock)notification_block
{
    NSRecursiveLock * lock = [[NSRecursiveLock alloc]init];
    [lock lock];
    [_notificationCenterQueue addOperationWithBlock:^{
        [_observers enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            notification_block((NSObject*)obj);
        }];
    }];
    [lock unlock];
}


-(void)sendNotificationWithBlockUsingQueuedBlocks:(GCNotificationBlock)notification_block
{
    NSRecursiveLock * lock = [[NSRecursiveLock alloc]init];
    [lock lock];
    
    [_observers enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [_notificationCenterQueue addOperationWithBlock:^{
            
            notification_block((NSObject*)obj);
        }];
    }];
    [lock unlock];
}
@end

//
//  ViewController.m
//  GCNotificationCenterPlayground
//
//  Created by Eloi Guzmán on 25/04/13.
//  Copyright (c) 2013 Eloi Guzmán. All rights reserved.
//

#import "ViewController.h"
#import "TestingObserver.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:_scrollView];
    
    _observers = [[NSMutableSet alloc]init];
    
    //Test observers
    _userNotificationCenter = [[UsersNotificationCenter alloc]init];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //Playground tests...
    [self beginTests];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _scrollView.frame = self.view.bounds;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*30, self.view.bounds.size.height*40);
}

#pragma mark - Testing methods only

-(void)beginTests
{
    //Creating observers
    for (int i=0;i<15; i++) {
        TestingObserver * newObserver = [[TestingObserver alloc]init];
        [_userNotificationCenter addGCObserver:newObserver];
        [_observers addObject:newObserver];

        
        /*
        //We add the observer to prevent dealloc. The notification center doesn't retain observers added.
        if (i!=0) { //Force first observer to be deallocated (Testing for errors)
            [_observers addObject:newObserver];
            //[_userNotificationCenter notifyUsersAdded:@[@"User0!"]]; //This sends a message to a deallocated instance (We have to removeObservers!!!)
        }
        
        if (i==0) {
            [_userNotificationCenter removeGCObserver:newObserver]; // We avoid zombies removing the observer...
        }*/
    }
    
    //Notifying observers
    NSMutableString * user1 = [[NSMutableString alloc]initWithString:@"User1"];
    NSMutableString * user2 = [[NSMutableString alloc]initWithString:@"User2"];
    NSMutableString * user3 = [[NSMutableString alloc]initWithString:@"User3"];
    [_userNotificationCenter notifyUsersAdded:@[user1,user2,user3]];
    [_userNotificationCenter notifyUsersDeleted:@[user3]];
    
    for (int i = 0; i<500; i++) {
        [user3 setString:[NSString stringWithFormat:@"User%d",i]];
        //[[NSOperationQueue mainQueue]addOperationWithBlock:^{
        //[_userNotificationCenter notifyUsersDeleted:@[user1,user2,user3]]; //Blocks UI
        [_userNotificationCenter notifyUserChatReceived:@"Hello world!!"]; //No UI block
        [_userNotificationCenter notifyUsersAdded:@[user1,user2]]; //No UI block
        //}];
        
        /*if ((i%50) == 0) {
            NSObject * o = _observers.anyObject;
            [_userNotificationCenter removeGCObserver:o];
            [_observers removeObject:o];
        }*/
    }
    
    //Scheduling a removal of observers from notification center and from retained observers. Testing obserever deallocation
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(removeObserverStep) userInfo:nil repeats:YES];

}

//Testing methods...
-(void)removeObserverStep
{
    //NSLog(@"Remove observer called");
    NSObject * o = _observers.anyObject;
    if (o) {
        [_userNotificationCenter removeGCObserver:o];
        [_observers removeObject:o];
    }
}


@end


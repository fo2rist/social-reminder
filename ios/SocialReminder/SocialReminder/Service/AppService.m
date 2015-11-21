//
//  AppService.m
//  VenuesViewer
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AppService.h"

#import "User.h"
#import "Reminder.h"

#import <RestKit/RestKit.h>

#define NullCheck(obj) obj == nil ? [NSNull null] : obj

typedef void(^SuccessResponseHandler)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void(^FailureResponseHandler)(RKObjectRequestOperation *operation, NSError *error);

static NSString *const HostName = @"http://10.10.40.12:5000";

static NSString *const UserEndpoint = @"/users";
static NSString *const UserCountdownsEndpoint = @"/usercountdowns";
static NSString *const CountdownsEndpoint = @"/countdowns";

@interface AppService ()

@property (nonatomic, weak) NSUserDefaults *defaults;

@end

@implementation AppService

#pragma mark - Singleton Methods

+ (instancetype)sharedService {
    static AppService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[AppService alloc] init];
    });
    return service;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupRestKit];
    }
    
    return self;
}

#pragma mark - RestKit Methods

- (void)setupRestKit {
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    _objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:HostName]];
    _objectManager.operationQueue.maxConcurrentOperationCount = 2;
    [_objectManager.HTTPClient setDefaultHeader:@"UID" value:[self.defaults objectForKey:UIDDefaultsKey]];
    [_objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    NSIndexSet *successfulCodesIndexSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[User objectMapping]
                                                                                    method:RKRequestMethodPOST
                                                                               pathPattern:UserEndpoint
                                                                                   keyPath:nil
                                                                               statusCodes:successfulCodesIndexSet];
    [_objectManager addResponseDescriptor:descriptor];
    
    descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Reminder objectMapping]
                                                              method:RKRequestMethodGET
                                                         pathPattern:CountdownsEndpoint
                                                             keyPath:nil
                                                         statusCodes:successfulCodesIndexSet];
    [_objectManager addResponseDescriptor:descriptor];
    
    descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Reminder objectMapping]
                                                              method:RKRequestMethodPOST
                                                         pathPattern:CountdownsEndpoint
                                                             keyPath:nil
                                                         statusCodes:successfulCodesIndexSet];
    [_objectManager addResponseDescriptor:descriptor];
    
}

- (void)getObjectsAtPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(ServiceCompletionHandler)completion {
    [self requestAtPath:path parameters:parameters method:RKRequestMethodGET completion:completion];
}

- (void)postObjectsAtPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(ServiceCompletionHandler)completion {
    [self requestAtPath:path parameters:parameters method:RKRequestMethodPOST completion:completion];
}

#pragma mark - Public Methods

- (void)createUserWithPhoneNumber:(NSString *)phoneNumber completion:(ServiceCompletionHandler)completion {
    NSDictionary *parameters = @{@"phone" : NullCheck(phoneNumber)};
    [self postObjectsAtPath:UserEndpoint
                 parameters:parameters
                 completion:completion];
}

- (void)saveReminderWithTitle:(NSString *)title
                     fireDate:(NSDate *)fireDate
                   completion:(ServiceCompletionHandler)completion {
    NSDictionary *parameters = @{@"name" : NullCheck(title),
                                 @"datetime" : NullCheck(@([fireDate timeIntervalSince1970]))};
    [self postObjectsAtPath:CountdownsEndpoint
                 parameters:parameters
                 completion:completion];
}

- (void)userRemindersWithCompletion:(ServiceCompletionHandler)completion {
    [self getObjectsAtPath:UserCountdownsEndpoint
                parameters:nil
                completion:completion];
}

- (void)allRemindersWithFilter:(ReminderFilter)filter completion:(ServiceCompletionHandler)completion {
    NSDictionary *parameters = @{@"filter" : @(filter)};
    [self getObjectsAtPath:CountdownsEndpoint
                parameters:parameters
                completion:completion];
}

#pragma mark - Private Methods

- (void)requestAtPath:(NSString *)path
           parameters:(NSDictionary *)parameters
               method:(RKRequestMethod)method
           completion:(ServiceCompletionHandler)completion {
    
    SuccessResponseHandler success = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (completion) {
            completion(YES, mappingResult.array, operation.HTTPRequestOperation.responseString, nil);
        }
    };
    FailureResponseHandler failure = ^(RKObjectRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(NO, nil, operation.HTTPRequestOperation.responseString, error);
        }
    };
    
    RKObjectRequestOperation *requestOperation = [_objectManager appropriateObjectRequestOperationWithObject:nil
                                                                                                      method:method
                                                                                                        path:path
                                                                                                  parameters:parameters];
    [requestOperation setCompletionBlockWithSuccess:success failure:failure];
    [_objectManager enqueueObjectRequestOperation:requestOperation];
}

@end

//
//  AppService.m
//  VenuesViewer
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AppService.h"
#import "NotificationsManager.h"

#import "User.h"
#import "Reminder.h"
#import "Contact.h"

#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

#define NullCheck(obj) obj == nil ? [NSNull null] : obj

typedef void(^SuccessResponseHandler)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void(^FailureResponseHandler)(RKObjectRequestOperation *operation, NSError *error);

static NSString *const HostName = @"http://10.10.40.12:5000";

static NSString *const UserEndpoint = @"/users";
static NSString *const ContactsEndpoint = @"/contacts";
static NSString *const UserCountdownsEndpoint = @"/user/countdowns";
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
    [_objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    // Model
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // Manually create a NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Add your persistent store to the coordinator
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"SocialReminder.sqlite"];
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:storeUrl
                                                   options:nil
                                                     error:&error];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:persistentStoreCoordinator];
    [managedObjectStore createManagedObjectContexts];
    
    _objectManager.managedObjectStore = managedObjectStore;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onManagedContextSave)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:managedObjectStore.mainQueueManagedObjectContext];
    
    NSIndexSet *successfulCodesIndexSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[Contact objectMapping]
                                                                                   objectClass:[Contact class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    [_objectManager addRequestDescriptor:requestDescriptor];
    
    RKResponseDescriptor *descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[User objectMapping]
                                                                                    method:RKRequestMethodPOST
                                                                               pathPattern:UserEndpoint
                                                                                   keyPath:nil
                                                                               statusCodes:successfulCodesIndexSet];
    [_objectManager addResponseDescriptor:descriptor];
    
    descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RuntimeReminder objectMapping]
                                                              method:RKRequestMethodGET
                                                         pathPattern:CountdownsEndpoint
                                                             keyPath:nil
                                                         statusCodes:successfulCodesIndexSet];
    [_objectManager addResponseDescriptor:descriptor];
    
    descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[DBReminder entityMappingWithManagedObjectStore:_objectManager.managedObjectStore]
                                                              method:RKRequestMethodPOST
                                                         pathPattern:CountdownsEndpoint
                                                             keyPath:nil
                                                         statusCodes:successfulCodesIndexSet];
    [_objectManager addResponseDescriptor:descriptor];
    
    descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[DBReminder entityMappingWithManagedObjectStore:_objectManager.managedObjectStore]
                                                              method:RKRequestMethodGET
                                                         pathPattern:UserCountdownsEndpoint
                                                             keyPath:nil
                                                         statusCodes:successfulCodesIndexSet];
    [_objectManager addResponseDescriptor:descriptor];
    
}

- (void)getObjectsAtPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(ServiceCompletionHandler)completion {
    [self requestAtPath:path parameters:parameters method:RKRequestMethodGET object:nil completion:completion];
}

- (void)postObjectsAtPath:(NSString *)path parameters:(NSDictionary *)parameters object:(id)object completion:(ServiceCompletionHandler)completion {
    [self requestAtPath:path parameters:parameters method:RKRequestMethodPOST object:object completion:completion];
}

- (void)onManagedContextSave {
    [[NotificationsManager sharedManager] reloadLocalNotifications];
}

#pragma mark - Public Methods

- (void)createUserWithPhoneNumber:(NSString *)phoneNumber completion:(ServiceCompletionHandler)completion {
    NSDictionary *parameters = @{@"phone" : NullCheck(phoneNumber)};
    [self postObjectsAtPath:UserEndpoint
                 parameters:parameters
                     object:nil
                 completion:completion];
}

- (void)saveContacts:(NSArray *)contacts completion:(ServiceCompletionHandler)completion {
    //    NSDictionary *parameters = nil;
    //    if (contacts.count > 0) {
//            if (contacts.count > 10) {
//                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)];
//                contacts = [contacts objectsAtIndexes:indexSet];
//            }
    //        parameters = @{@"contacts" : NullCheck([contacts valueForKey:@"dictionary"])};
    //    }
    if (contacts.count > 10) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)];
        contacts = [contacts objectsAtIndexes:indexSet];
    }

    [self postObjectsAtPath:ContactsEndpoint
                 parameters:nil
                     object:contacts
                 completion:completion];
}

- (void)saveReminderWithTitle:(NSString *)title
                     fireDate:(NSDate *)fireDate
                   completion:(ServiceCompletionHandler)completion {
    
    NSDictionary *parameters = @{@"name" : NullCheck(title),
                                 @"datetime" : NullCheck(@([fireDate timeIntervalSince1970]))};
    [self postObjectsAtPath:CountdownsEndpoint
                 parameters:parameters
                     object:nil
                 completion:completion];
}

- (void)subscribeToReminderWithId:(NSString *)reminderId
                       completion:(ServiceCompletionHandler)completion {
    NSDictionary *parameters = @{@"id" : NullCheck(reminderId)};
    [self postObjectsAtPath:CountdownsEndpoint
                 parameters:parameters
                     object:nil
                 completion:completion];
}

- (void)userRemindersWithCompletion:(ServiceCompletionHandler)completion {
    [self getObjectsAtPath:UserCountdownsEndpoint
                parameters:nil
                completion:completion];
}

- (void)allRemindersWithFilter:(ReminderFilter)filter search:(NSString *)search completion:(ServiceCompletionHandler)completion {
    NSString *filterName = @"";
    switch (filter) {
        case ReminderFilterPopular:
            filterName = @"popular";
            break;
            
        case ReminderFilterFriends:
            filterName = @"friends";
            break;
            
        default:
            break;
    }
    NSDictionary *parameters = @{@"filter" : NullCheck(filterName),
                                 @"search" : NullCheck(search)};
    [self getObjectsAtPath:CountdownsEndpoint
                parameters:parameters
                completion:completion];
}

#pragma mark - Private Methods

- (void)requestAtPath:(NSString *)path
           parameters:(NSDictionary *)parameters
               method:(RKRequestMethod)method
               object:(id)object
           completion:(ServiceCompletionHandler)completion {
    
    [_objectManager.HTTPClient setDefaultHeader:@"UID" value:[self.defaults objectForKey:UIDDefaultsKey]];
    
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
    
    RKObjectRequestOperation *requestOperation = [_objectManager appropriateObjectRequestOperationWithObject:object
                                                                                                      method:method
                                                                                                        path:path
                                                                                                  parameters:parameters];
    [requestOperation setCompletionBlockWithSuccess:success failure:failure];
    [_objectManager enqueueObjectRequestOperation:requestOperation];
}

@end

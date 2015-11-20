//
//  AppService.h
//  VenuesViewer
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectManager;

typedef void(^ServiceCompletionHandler)(BOOL success, id parsedData, NSString *responseString, NSError *error);

@interface AppService : NSObject {
    @private
    RKObjectManager *_objectManager;
}

+ (instancetype)sharedService;

- (void)createUserWithPhoneNumber:(NSString *)phoneNumber completion:(ServiceCompletionHandler)completion;

@end

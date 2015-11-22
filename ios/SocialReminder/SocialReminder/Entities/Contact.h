//
//  Contact.h
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, readonly) NSDictionary *dictionary;

+ (Contact *)contactWithFullName:(NSString *)fullName phoneNumber:(NSString *)phoneNumber;

+ (RKObjectMapping *)objectMapping;

@end

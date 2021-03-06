//
//  Contact.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "Contact.h"

#define NullCheck(obj) obj == nil ? [NSNull null] : obj

@implementation Contact

+ (Contact *)contactWithFullName:(NSString *)fullName phoneNumber:(NSString *)phoneNumber {
    Contact *contact = [[Contact alloc] init];
    contact.fullName = fullName;
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"+1234567890"];
    contact.phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[set invertedSet]] componentsJoinedByString:@""];
    return contact;
}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromDictionary:@{@"phoneNumber" : @"phone",
                                                  @"fullName" : @"name"}];
    return mapping;
}

- (NSDictionary *)dictionary {
    NSDictionary *dictionary = @{@"phone" : NullCheck(self.phoneNumber),
                                 @"name" : NullCheck(self.fullName)};
    return dictionary;
}

@end

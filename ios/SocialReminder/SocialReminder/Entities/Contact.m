//
//  Contact.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "Contact.h"

@implementation Contact

+ (Contact *)contactWithFullName:(NSString *)fullName phoneNumber:(NSString *)phoneNumber {
    Contact *contact = [[Contact alloc] init];
    contact.fullName = fullName;
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"+1234567890"];
    contact.phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[set invertedSet]] componentsJoinedByString:@""];
    return contact;
}

- (NSDictionary *)dictionary {
    NSDictionary *dictionary = @{@"phone" : self.phoneNumber,
                                 @"name" : self.fullName};
    return dictionary;
}

@end

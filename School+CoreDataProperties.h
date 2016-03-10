//
//  School+CoreDataProperties.h
//  SmartSearch
//
//  Created by Appmonkeyz on 3/9/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "School.h"

NS_ASSUME_NONNULL_BEGIN

@interface School (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *address;

@end

NS_ASSUME_NONNULL_END

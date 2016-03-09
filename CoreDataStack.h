//
//  CoreDataStack.h
//  SmartSearch
//
//  Created by Appmonkeyz on 3/9/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

+ (instancetype)defaultCoreDataStack;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end

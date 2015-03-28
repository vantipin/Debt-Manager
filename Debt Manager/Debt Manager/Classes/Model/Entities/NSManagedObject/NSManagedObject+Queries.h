//
//  NSManagedObject+Queries.h
//  PixPublisherMobile
//
//  Created by Pavel Stoma on 13/06/13.
//  Copyright (c) 2013 BMB. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject(Queries)

+ (NSFetchRequest *)fetchRequest;
+ (NSArray *)fetchAll;
+ (NSArray *)fetchAllWithSortDescriptor:(NSSortDescriptor *)aSortDescriptor parameters:(NSDictionary *)aParameters;
+ (NSArray *)fetchAllWithSortDescriptor:(NSSortDescriptor *)sortDescriptor parameters:(NSDictionary *)aParameters inContext:(NSManagedObjectContext *)aContext;
+ (NSArray *)fetchAllWithSortDescriptor:(NSSortDescriptor *)sortDescriptor parameters:(NSDictionary *)aParameters withOffset:(NSInteger)offsetCount andCount:(NSInteger)count;
+ (NSArray *)fetchAllWithSortDescriptor:(NSSortDescriptor *)sortDescriptor andPrediacte:(NSPredicate *)aPredicate;
+ (NSArray *)fetchAllInContext:(NSManagedObjectContext *)aContext;
+ (NSArray *)fetchWithParameters:(NSDictionary *)aParameters;
+ (NSArray *)fetchWithParameters:(NSDictionary *)aParameters inContext:(NSManagedObjectContext *)aContext;
+ (NSArray *)fetchWithPredicate:(NSPredicate *)aPredicate;
+ (NSArray *)fetchWithPredicate:(NSPredicate *)aPredicate inContext:(NSManagedObjectContext *)aContext;
+ (NSArray *)fetchWithRange:(NSRange)aRange prediacte:(NSPredicate *)aPredicate;
+ (NSArray *)fetchWithRange:(NSRange)aRange prediacte:(NSPredicate *)aPredicate sortDescriptor:(NSSortDescriptor *)aSortDescriptor;

+ (id)fetchObjectWithPredicate:(NSPredicate *)aPredicate;
+ (id)fetchObjectWithPredicate:(NSPredicate *)aPredicate inContext:(NSManagedObjectContext *)aContext;
+ (id)fetchObjectWithParameters:(NSDictionary *)aParameters;
+ (id)fetchObjectWithParameters:(NSDictionary *)aParameters inContext:(NSManagedObjectContext *)aContext;

+ (NSManagedObjectContext *)managedObjectContext;

+ (id)object;
+ (id)objectInContext:(NSManagedObjectContext *)aContext;
+ (id)objectWithPredicate:(NSPredicate *)aPredicate;

+ (void)deleteObject:(id)aObject;
+ (void)deleteObject:(id)aObject inContext:(NSManagedObjectContext *)aContext;

+ (void)flushEntity;
+ (void)flushEntityInContext:(NSManagedObjectContext *)aContext;

+ (NSInteger)entityCount;
+ (NSInteger)entityCountInContext:(NSManagedObjectContext *)aContext;

+ (NSInteger)entityCountWithPredicate:(NSPredicate *)aPredicate;
+ (NSInteger)entityCountWithPredicate:(NSPredicate *)aPredicate inContext:(NSManagedObjectContext *)aContext;
+ (NSUInteger)entityCountWithSortDescriptor:(NSSortDescriptor *)sortDescriptor parameters:(NSDictionary *)aParameters;

- (NSArray *)propertiesList;

- (NSDictionary *)proxyForNSDictionary;
- (NSString *)proxyForJSON;

- (id)transformValue:(id)aValue toType:(NSAttributeType)aType;
- (id)transformValue:(id)aValue toClass:(Class *)aClass;

@end

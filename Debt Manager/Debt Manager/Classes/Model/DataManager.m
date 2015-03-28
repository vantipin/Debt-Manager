//
//  CoreDataClass.m
//  BookShelf
//
//  Created by Vlad Antipin on 09.12.13.
//  Copyright (c) 2013 VolcanoSoft. All rights reserved.
//

#import "DataManager.h"
#import "NSStringAdditions.h"
#import "MainContextObject.h"
#import <CommonCrypto/CommonHMAC.h>

static DataManager *instance = nil;

@implementation DataManager

@synthesize context = _context;

+ (DataManager *)sharedInstance
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        if (!instance) {
            instance = [[DataManager alloc] init];
        }
    });
    
    return instance;
}

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [MainContextObject sharedInstance].context;
    }
    
    return _context;
}

- (NSInteger)amountForType:(DebtType)type
{
    NSArray *debts = [self fetchDebtsWithType:type sortingBy:DATE_TYPE isActive:YES];
    NSInteger summ = 0;
    for (Debt *debt in debts) {
        summ += debt.amount.integerValue;
    }
    
    return summ;
}

- (NSArray *)fetchDebtsSortingBy:(SortingType)type
{
    return [self fetchDebtsWithType:ANY_TYPE sortingBy:type isActive:YES];
}

- (NSArray *)fetchDebtsWithType:(DebtType)debtType sortingBy:(SortingType)sortingType isActive:(BOOL)isActive;
{
    NSPredicate *predicate;
    if (debtType == BORROW_TYPE || debtType == LEND_TYPE) {
        predicate = [NSPredicate predicateWithFormat:@"typeDebt == %d && isClosed != %d",debtType ,isActive];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"isClosed != %d" ,isActive];
    }
    
    NSString *sortingKey;
    switch (sortingType) {
        case 0: {
            sortingKey = @"date";
            break;
        }
        case 1: {
            sortingKey = @"user.name";
            break;
        }
        case 2: {
            sortingKey = @"amount";
            break;
        }
            
        default: {
            sortingKey = @"date";
            break;
        }
    }
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:sortingKey ascending:NO];
    NSArray *result = [self fetchRequestForObjectName:@"Debt" withPredicate:predicate andSortDescriptor:@[descriptor]];
    
    return result;
}

- (UIImage *)imageForType:(DebtType)type;
{
    if (type == BORROW_TYPE) {
        return [UIImage imageNamed:@"borrowIcon.png"];
    }
    else if (type == LEND_TYPE) {
        return [UIImage imageNamed:@"lendIcon.png"];
    }
    else {
        return nil;
    }
}

- (NSString *)textForType:(DebtType)type;
{
    if (type == BORROW_TYPE) {
        return @"Borrowed";
    }
    else if (type == LEND_TYPE) {
        return @"Lent";
    }
    else {
        return @"";
    }
}



+ (UIImage *)imageForID:(NSString *)anId
{
    if (anId) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *docs = [paths objectAtIndex:0];
        NSString* path =  [docs stringByAppendingString:[NSString stringWithFormat:@"/image%@.jpg", anId]];
        
//        NSData* imageData = [NSData dataWithContentsOfFile:path];
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        return image;
    }
    
    return nil;
}

+ (void)saveImage:(UIImage *)anImage withId:(NSString *)anId
{
    if (anImage && anId) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *docs = [paths objectAtIndex:0];
        NSString* path =  [docs stringByAppendingString:[NSString stringWithFormat:@"/image%@.jpg", anId]];
        
        NSData* imageData = [NSData dataWithData:UIImageJPEGRepresentation(anImage, .96)];
        NSError *writeError = nil;
        
        if (![imageData writeToFile:path options:NSDataWritingAtomic error:&writeError]) {
            NSLog(@"%@: Error saving image: %@", [self class], [writeError localizedDescription]);
        }
    }
}


- (void)setValue:(NSNumber *)number forKey:(NSString *)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults setObject:number forKey:key];
    [standardUserDefaults synchronize];
}

- (NSNumber *)valueForKey:(NSString *)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    id objectForKey = [standardUserDefaults objectForKey:key];
    
    if (!objectForKey) {
        objectForKey = @(300);
        [[DataManager sharedInstance] setValue:objectForKey forKey:key];
    }
    
    return objectForKey;
}


- (NSArray *)fetchRequestForObjectName:(NSString *)objName
                         withPredicate:(NSPredicate *)predicate
{
    return [self fetchRequestForObjectName:objName withPredicate:predicate andSortDescriptor:nil];
}

- (NSArray *)fetchRequestForObjectName:(NSString *)objName
                         withPredicate:(NSPredicate *)predicate
                     andSortDescriptor:(NSArray *)sortDescriptors
{
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = [NSEntityDescription entityForName:objName inManagedObjectContext:self.context];
    request.predicate = predicate;
    
    if (sortDescriptors != nil && sortDescriptors.count) {
        request.sortDescriptors = sortDescriptors;
    }
    
    NSError *error = nil;
    NSArray *objPool = [self.context executeFetchRequest:request error:&error];
    
    if (!error) {
        return objPool;
    }
    
    return nil;
}

- (BOOL)save
{
    NSError *error = nil;
    if ([self.context hasChanges]) {
        if (![self.context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
            
            return false;
        }
        else {
            //save succeed
            
        }
    }
    else {
        NSLog(@"Context hasn't changed");
    }
    
    return true;
}

- (BOOL)clearEntityForNameWithObjName:(NSString *)name
                        withPredicate:(NSPredicate *)predicate
{
    
    NSArray *objectsPool = [self fetchRequestForObjectName:name withPredicate:predicate];
    
    if (objectsPool.count > 0 ) {
        for (id obj in objectsPool) {
            [self.context deleteObject:obj];
        }
        [self save];
        return true;
        
    }
    return false;
}


+ (NSString *)standartDateFormat:(NSTimeInterval)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMM"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
    
    return dateString;
}
@end

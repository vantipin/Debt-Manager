//
//  NSManagedObject+Queries.m
//  BMBDataLayer
//
//  Created by Andrey Kozeletsky on 13/06/13.
//  Copyright (c) 2013 BMB. All rights reserved.
//

#import "NSManagedObject+Queries.h"
#import "MainContextObject.h"
@class Album;

@implementation NSManagedObject(Queries)


+ (NSFetchRequest *)fetchRequest {
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	[fetchRequest setEntity:[NSEntityDescription entityForName:[NSString stringWithFormat:@"%@", self] inManagedObjectContext:[[MainContextObject sharedInstance] context]]];
    
	return fetchRequest;
}

+ (NSArray *)fetchAll {
	return [self fetchAllInContext:nil];
}


+ (NSArray *)fetchAllWithSortDescriptor:(NSSortDescriptor *)aSortDescriptor parameters:(NSDictionary *)aParameters
{
    return [[self class] fetchAllWithSortDescriptor:aSortDescriptor parameters:aParameters inContext:nil];
}

+ (NSArray *)fetchAllWithSortDescriptor:(NSSortDescriptor *)sortDescriptor parameters:(NSDictionary *)aParameters inContext:(NSManagedObjectContext *)aContext
{
    NSArray* fetchedResults = @[];
    NSError* error = nil;
    NSManagedObjectContext* context = nil;
    
    @try {
        
        context = (nil != aContext) ? aContext : [[MainContextObject sharedInstance] context];
        
        NSFetchRequest* request = [self fetchRequest];
        
        if (aParameters != nil && [aParameters isKindOfClass:[NSDictionary class]]) {
            
            NSMutableArray* values = [NSMutableArray array];
            NSMutableString* predicateString  = [NSMutableString string];
            
            for (NSString* key in aParameters) {
                
                NSString *propertyName = key;
                
                [predicateString appendFormat:@" %@ %@ = %@ ", (([predicateString length] == 0) ? @"" : @"AND") , propertyName, @"%@"];
                [values addObject:[aParameters valueForKey:key]];
            }
            
            NSPredicate* predicate = nil;
            
            if ([values count]) {
                predicate = [NSPredicate predicateWithFormat:predicateString
                                               argumentArray:values];
                [request setPredicate:predicate];
            }

        }
        
        if (nil != sortDescriptor) {
            [request setSortDescriptors:@[sortDescriptor]];
        }
        
        fetchedResults = [context executeFetchRequest:request error:&error];
        
        if (error != nil) {
            @throw([NSException exceptionWithName:error.domain
                                           reason:error.localizedFailureReason
                                         userInfo:error.userInfo]);
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"aContext:%@\nexception: %@", context, exception);
    }
    @finally {
        return fetchedResults;
    }

}

+ (NSArray *)fetchAllWithSortDescriptor:(NSSortDescriptor *)sortDescriptor
                             parameters:(NSDictionary *)aParameters
                             withOffset:(NSInteger)offsetCount
                               andCount:(NSInteger)count {
    
    @synchronized(self) {
        
        NSArray* fetchedResults = @[];
        NSError* error = nil;
        NSManagedObjectContext* context = nil;
        
        @try {
            context = [[MainContextObject sharedInstance] context];
            
            NSFetchRequest* request = [self fetchRequest];
            
            if (aParameters != nil && [aParameters isKindOfClass:[NSDictionary class]]) {
                
                NSMutableArray* values = [[NSMutableArray alloc] init];
                
                NSMutableString* predicateString  = [NSMutableString string];
                
                for (NSString* key in aParameters) {
                    
                    NSString *propertyName = key;
                
                    
                    [predicateString appendFormat:@" %@ %@ = %@ ", (([predicateString length] == 0) ? @"" : @"AND") , propertyName, @"%@"];
                    [values addObject:[aParameters valueForKey:key]];
                }
                
                NSPredicate* predicate = nil;
                
                if ([values count]) {
                    predicate = [NSPredicate predicateWithFormat:predicateString
                                                   argumentArray:values];
                    [request setPredicate:predicate];
                }
                
            }
            
            if (count > 0) {
                [request setFetchLimit:count + offsetCount];
            }
            
            if (nil != sortDescriptor) {
                [request setSortDescriptors:@[sortDescriptor]];
            }
            
            fetchedResults = [context executeFetchRequest:request error:&error];
            
            if (error != nil) {
                @throw([NSException exceptionWithName:error.domain
                                               reason:error.localizedFailureReason
                                             userInfo:error.userInfo]);
            }
            
            if (count == 0) {
                return fetchedResults;
            } else  {
                if (fetchedResults != nil) {
                    if ([fetchedResults count] == (count + offsetCount)) {
                        return [fetchedResults subarrayWithRange:NSMakeRange(offsetCount, count)];
                    } else if ([fetchedResults count] > offsetCount) {
                        if (fetchedResults.count >= (offsetCount + count)) {
                            return [fetchedResults subarrayWithRange:NSMakeRange(offsetCount, count)];
                        } else {
                            return [fetchedResults subarrayWithRange:NSMakeRange(offsetCount, fetchedResults.count - offsetCount)];
                        }
                    } else {
                        return @[];
                    }
                } else {
                    return @[];
                }
            }
        }
        @catch (NSException *exception) {
            
            NSLog(@"aContext:%@\nexception: %@", context, exception);
            return @[];
            
        }
        @finally {
            //            return fetchedResults;
        }
    }
}

+ (NSArray *)fetchAllWithSortDescriptor:(NSSortDescriptor *)aSortDescriptor andPrediacte:(NSPredicate *)aPredicate
{
    return [self fetchAllWithSortDescriptor:aSortDescriptor andPrediacte:aPredicate inContext:nil];
}

+ (NSArray *)fetchAllWithSortDescriptor:(NSSortDescriptor *)aSortDescriptor andPrediacte:(NSPredicate *)aPredicate inContext:(NSManagedObjectContext *)aContext
{
    @synchronized(self) {
        
        NSArray* fetchedResults = @[];
        NSError* error = nil;
        NSManagedObjectContext* context = nil;
        
        @try {
            context = (nil != aContext) ? aContext : [[MainContextObject sharedInstance] context];
            
            NSFetchRequest* request = [self fetchRequest];
            
            if (nil != aPredicate && [aPredicate isKindOfClass:[NSPredicate class]]) {
                
                [request setPredicate:aPredicate];
                
            }
            
            if (nil != aSortDescriptor) {
                [request setSortDescriptors:@[aSortDescriptor]];
            }
            
            fetchedResults = [context executeFetchRequest:request error:&error];
            
            if (error != nil) {
                @throw([NSException exceptionWithName:error.domain
                                               reason:error.localizedFailureReason
                                             userInfo:error.userInfo]);
            }
            
        }
        @catch (NSException *exception) {
            
            NSLog(@"aContext:%@\nexception: %@", context, exception);
            
        }
        @finally {
            return fetchedResults;
        }
    }
}

+ (NSArray *)fetchAllInContext:(NSManagedObjectContext *)aContext {
	return [self fetchWithParameters:nil inContext:aContext];
}

+ (NSArray *)fetchWithParameters:(NSDictionary *)aParameters
{
    return [self fetchWithParameters:aParameters inContext:nil];
}

+ (NSArray *)fetchWithParameters:(NSDictionary *)aParameters inContext:(NSManagedObjectContext *)aContext
{
    return [self fetchAllWithSortDescriptor:nil parameters:aParameters withOffset:0 andCount:0];
}

+ (NSArray *)fetchWithPredicate:(NSPredicate *)aPredicate
{
    return [self fetchWithPredicate:aPredicate inContext:nil];
}

+ (NSArray *)fetchWithPredicate:(NSPredicate *)aPredicate inContext:(NSManagedObjectContext *)aContext
{
    NSArray* fetchedResults = @[];
	NSError* error = nil;
	NSManagedObjectContext* context = nil;
    
    @try {
        
        context = (nil != aContext) ? aContext : [[MainContextObject sharedInstance] context];
		
		NSFetchRequest* request = [self fetchRequest];
        
        if (nil != aPredicate && [aPredicate isKindOfClass:[NSPredicate class]]) {
            
            [request setPredicate:aPredicate];
            
        }
        
        fetchedResults = [context executeFetchRequest:request error:&error];
		
		if (error != nil) {
			@throw([NSException exceptionWithName:error.domain
										   reason:error.localizedFailureReason
										 userInfo:error.userInfo]);
		}
        
    }
    @catch (NSException *exception) {
        NSLog(@"aPredicate:%@\naContext:%@\nexception: %@", aPredicate, aContext, exception.userInfo);
    }
    @finally {
        return fetchedResults;
    }
    
}

+ (NSArray *)fetchWithRange:(NSRange)aRange prediacte:(NSPredicate *)aPredicate {
    
    return [self fetchWithRange:aRange prediacte:aPredicate sortDescriptor:nil];
}

+ (NSArray *)fetchWithRange:(NSRange)aRange prediacte:(NSPredicate *)aPredicate sortDescriptor:(NSSortDescriptor *)aSortDescriptor {
    
    NSFetchRequest *request = [self fetchRequest];
    
    [request setPredicate:aPredicate];
    [request setFetchLimit:aRange.length];
    [request setFetchOffset:aRange.location];
    
    if (aSortDescriptor) {
        
        [request setSortDescriptors:@[aSortDescriptor]];
    }
    
    NSError* error = nil;
    NSArray* fetchedResults = [[[MainContextObject sharedInstance] context] executeFetchRequest:request error:&error];
    
    if (error != nil) {
        
        NSLog(@"fetch error: %@", [error localizedFailureReason]);
        
        return @[];
    }
    
    return fetchedResults;
}

+ (id)fetchObjectWithPredicate:(NSPredicate *)aPredicate
{
    return [[self class] fetchObjectWithPredicate:aPredicate inContext:nil];
}

+ (id)fetchObjectWithPredicate:(NSPredicate *)aPredicate inContext:(NSManagedObjectContext *)aContext
{
    NSArray* fetchedResults = @[];
    id object = nil;
    
    fetchedResults = [[self class] fetchWithPredicate:aPredicate inContext:aContext];
    
    if ([fetchedResults count] > 0) {
        object = [fetchedResults firstObject];
    }
    
    return object;
}

+ (id)fetchObjectWithParameters:(NSDictionary *)aParameters
{
    return [[self class] fetchObjectWithParameters:aParameters inContext:nil];
}

+ (id)fetchObjectWithParameters:(NSDictionary *)aParameters inContext:(NSManagedObjectContext *)aContext
{
    NSArray* fetchedResults = [[self class] fetchAllWithSortDescriptor:nil parameters:aParameters inContext:aContext];
    id object = nil;
    
    if ([fetchedResults count] > 0) {
        object = [fetchedResults firstObject];
    }
    
    return object;
}

+ (NSManagedObjectContext *)managedObjectContext {
    return [[MainContextObject sharedInstance] context];
}

+ (id)object {
	return [self objectInContext:nil];
}

+ (id)objectInContext:(NSManagedObjectContext *)aContext {
    
	NSManagedObjectContext *context;
	id object = nil;
	
	@try {
		context = (nil != aContext) ? aContext : [[MainContextObject sharedInstance] context];
		
		if (context.undoManager == nil) {
			
			NSUndoManager *undoManager = [[NSUndoManager alloc] init];
			context.undoManager = undoManager;
			
		}
		
        object = [[self alloc] initWithEntity:[NSEntityDescription entityForName:[NSString stringWithFormat:@"%@", self] inManagedObjectContext:context]
			   insertIntoManagedObjectContext:context];
	}
	@catch (NSException *exception) {
		NSLog(@"exception:%@", exception);
	}
	@finally {
		return object;
	}
}

+ (id)objectWithPredicate:(NSPredicate *)aPredicate {
    
    NSFetchRequest *request = [self fetchRequest];
    
    [request setPredicate:aPredicate];
    
    NSError* error = nil;
    NSArray* fetchedResults = [[[MainContextObject sharedInstance] context] executeFetchRequest:request error:&error];
    
    if (error != nil) {
        
        NSLog(@"fetch error: %@", [error localizedFailureReason]);
        
        return nil;
    }
    
    return [fetchedResults count] > 0 ? [fetchedResults firstObject] : nil;
}

+ (void)deleteObject:(id)aObject {
    
	[self deleteObject:aObject inContext:nil];
	
}

+ (void)deleteObject:(id)aObject inContext:(NSManagedObjectContext *)aContext {
	
	NSManagedObjectContext *context = nil;
	NSError *error = nil;
	
	@try {
        
		context = (nil != aContext) ? aContext : [[MainContextObject sharedInstance] context];
		
		[context deleteObject:aObject];
		
		[context save:&error];
		
		if (error != nil) {
			
			@throw([NSException exceptionWithName:error.domain
										   reason:error.localizedFailureReason
										 userInfo:error.userInfo]);
			
		}
		
	}
	@catch (NSException *exception) {
        
		NSLog(@"aObject: %@ aContext: %@ exception: %@", aObject, aContext, exception.userInfo);
        
	}
    
}

+ (void)flushEntity {
	
	@try {
		
		[self flushEntityInContext:nil];
		
	}
	@catch (NSException *exception) {
		
		NSLog(@"exception: %@", exception.userInfo);
		
	}
}

+ (void)flushEntityInContext:(NSManagedObjectContext *)aContext {
    
	NSError* error = nil;
    NSManagedObjectContext *context = nil;
	
	@try {
        
		@autoreleasepool {
            
            context = (nil != aContext) ? aContext : [[MainContextObject sharedInstance] context];
            
            NSFetchRequest* request = [self fetchRequest];
            [request setIncludesPropertyValues:NO];
            
            NSArray* items = [context executeFetchRequest:request error:&error];
            
            for (NSManagedObject* item in items) {
                [context deleteObject:item];
            }
            
            [context save:&error];
            
        }
        
	}
	@catch (NSException *exception) {
		NSLog(@"exception: %@", exception.userInfo);
	}
}

+ (NSInteger)entityCount {
    return [self entityCountInContext:nil];
}

+ (NSInteger)entityCountInContext:(NSManagedObjectContext *)aContext
{
    return [self entityCountWithPredicate:nil inContext:aContext];
}

+ (NSInteger)entityCountWithPredicate:(NSPredicate *)aPredicate
{
    return [self entityCountWithPredicate:aPredicate inContext:nil];
}

+ (NSInteger)entityCountWithPredicate:(NSPredicate *)aPredicate inContext:(NSManagedObjectContext *)aContext
{
	NSError* error = nil;
	NSManagedObjectContext* context = nil;
    NSUInteger count = 0;
    
    @try {
        
        context = (nil != aContext) ? aContext : [[MainContextObject sharedInstance] context];
		
		NSFetchRequest* request = [self fetchRequest];
        
        
        if (nil != aPredicate && [aPredicate isKindOfClass:[NSPredicate class]]) {
            
            [request setPredicate:aPredicate];
            
        }
        
        [request setIncludesPropertyValues:NO];
        [request setIncludesSubentities:NO];
        
        count = [context countForFetchRequest:request error:&error];
		
		if (nil != error) {
			@throw([NSException exceptionWithName:error.domain
										   reason:error.localizedFailureReason
										 userInfo:error.userInfo]);
		}
        
    }
    @catch (NSException *exception) {
        NSLog(@"aPredicate:%@\naContext:%@\nexception: %@", aPredicate, context, exception);
    }
    @finally {
        return count;
    }
    
}

+ (NSUInteger)entityCountWithSortDescriptor:(NSSortDescriptor *)sortDescriptor parameters:(NSDictionary *)aParameters
{
    return [self entityCountWithSortDescriptor:sortDescriptor parameters:aParameters inContext:nil];
}

+ (NSUInteger)entityCountWithSortDescriptor:(NSSortDescriptor *)sortDescriptor parameters:(NSDictionary *)aParameters inContext:(NSManagedObjectContext *)aContext
{
    NSError* error = nil;
    NSManagedObjectContext* context = nil;
    NSUInteger count = 0;
    
    @try {
        context = (nil != aContext) ? aContext : [[MainContextObject sharedInstance] context];
        
        NSFetchRequest* request = [self fetchRequest];
        
        if (aParameters != nil && [aParameters isKindOfClass:[NSDictionary class]]) {
            
            NSMutableArray* values = [[NSMutableArray alloc] init];
            
            NSMutableString* predicateString  = [NSMutableString string];
            
            for (NSString* key in aParameters) {
                
                NSString *propertyName = key;
                
                [predicateString appendFormat:@" %@ %@ = %@ ", (([predicateString length] == 0) ? @"" : @"AND") , propertyName, @"%@"];
                [values addObject:[aParameters valueForKey:key]];
                
            }
            
            NSPredicate* predicate = nil;
            
            if ([values count]) {
                predicate = [NSPredicate predicateWithFormat:predicateString
                                               argumentArray:values];
                [request setPredicate:predicate];
            }
            
        }
        
        if (nil != sortDescriptor) {
            [request setSortDescriptors:@[sortDescriptor]];
        }
        
        count = [context countForFetchRequest:request error:&error];
        
        if (nil != error) {
            @throw([NSException exceptionWithName:error.domain
                                           reason:error.localizedFailureReason
                                         userInfo:error.userInfo]);
        }
        
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"aContext:%@\nexception: %@", context, exception);
        
    }
    @finally {
        return count;
    }
}

- (NSArray *)propertiesList {
	return [[[self entity] attributesByName] allKeys];
}

- (NSDictionary *)proxyForNSDictionary {
    
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
	@try {
		for (__strong NSString *propertyName in [self propertiesList]) {
			id propertyValue = [self valueForKey:propertyName];
			
            // TODO: Insert Mapping here
            
            //			if ([propertyName isEqualToString:@"Id"]) {
            //				propertyName = @"id";
            //			} else if([propertyName isEqualToString:@"Description"]) {
            //				propertyName = @"description";
            //			}
            //
            //			if (propertyValue == nil) {
            //				propertyValue = @"";
            //			}
			
			dictionary[propertyName] = propertyValue;
		}
	}
	@catch (NSException *exception) {
		NSLog(@"exception: %@", exception);
	}
	@finally {
		return dictionary;
	}
}

- (NSString *)proxyForJSON {
    //	NSDictionary *dict = [NSDictionary dictionary];
    //
    //	@try {
    //		dict = [self proxyForNSDictionary];
    //	}
    //	@catch (NSException *exception) {
    //		NSLog(@"exception: %@", exception);
    //	}
    //	@finally {
    //		return [dict JSONString];
    //	}
    
    // TODO: Implementation
    
    return @"";
    
}

- (id)transformValue:(id)aValue toType:(NSAttributeType)aType {
	id returnValue = nil;
	
	@try {
		switch (aType) {
			case NSInteger16AttributeType:
			case NSInteger32AttributeType:
			case NSInteger64AttributeType:
				if ([aValue isKindOfClass:[NSString class]]) {
					returnValue = @([(NSString *)aValue intValue]);
				} else if([aValue isKindOfClass:[NSNumber class]]) {
					returnValue = aValue;
				} else {
					returnValue = @((NSInteger)aValue);
				}
                
				break;
			case NSDoubleAttributeType:
				if ([aValue isKindOfClass:[NSString class]]) {
					returnValue = @([(NSString *)aValue doubleValue]);
				}
				break;
			case NSDecimalAttributeType:
			case NSFloatAttributeType:
				if ([aValue isKindOfClass:[NSString class]]) {
					returnValue = @([(NSString *)aValue floatValue]);
				}
				break;
			case NSStringAttributeType:
				if (aValue == nil ||
					[aValue isKindOfClass:[NSNull class]] ||
					[aValue isEqualToString:@"<null>"]) {
                    
					returnValue = @"";
                    
				} else if (![aValue isKindOfClass:[NSString class]]) {
					
					returnValue = [NSString stringWithFormat:@"%@", aValue];
					
				} else {
					
					returnValue = aValue;
					
				}
				break;
			case NSBooleanAttributeType:
				if ([aValue isKindOfClass:[NSString class]]) {
					returnValue = [NSNumber numberWithFloat:[(NSString *)aValue boolValue]];
				} else if ([aValue isKindOfClass:[NSNumber class]]) {
					returnValue = aValue;
				}
                
				break;
			case NSDateAttributeType:
				if ([aValue isKindOfClass:[NSString class]]) {
					// Date formatter
					NSDateFormatter* dateFormatter = [NSDateFormatter new];
					[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                    [dateFormatter setLocale:locale];
                    
					returnValue = [dateFormatter dateFromString:(NSString *)aValue];
				} else if([aValue isKindOfClass:[NSDate class]]) {
					returnValue = aValue;
				}
				break;
			case NSBinaryDataAttributeType:
			case NSTransformableAttributeType:
			case NSObjectIDAttributeType:
			case NSUndefinedAttributeType:
			default:
				break;
		}
	}
	@catch (NSException *exception) {
		NSLog(@"aValue:%@\naType:%lu\nexception: %@", aValue, (unsigned long)aType, exception);
	}
	@finally {
		return returnValue;
	}
}

- (id)transformValue:(id)aValue toClass:(Class *)aClass {
    
    id returnValue = nil;
    
    @try {
        // TODO:
    }
    @catch (NSException *exception) {
        NSLog(@"aValue: %@\nexceprtion: %@", aValue, exception);
    }
    @finally {
        return returnValue;
    }
    
}


@end

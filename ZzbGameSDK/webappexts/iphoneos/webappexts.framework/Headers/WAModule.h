//
//  WAModule.h
//  webapp
//
//  Created by Gen2 on 2019/1/14.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "symbols.h"

NS_ASSUME_NONNULL_BEGIN

@class WARows;

typedef void (^WAModuleActionBlock)(void *db);

typedef enum : NSUInteger {
    WAFieldInt,
    WAFieldReal,
    WAFieldText,
    WAFieldBlob
} WAFieldType;

@interface WARows : NSObject

- (BOOL)nextRow;

- (NSInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(NSString *key, id obj, BOOL *stop))block;

@end

@interface WAField : NSObject

@property (nonatomic, readonly) WAFieldType type;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, assign) SEL setter;
@property (nonatomic, assign) SEL getter;
@property (nonatomic, assign) BOOL primary;
@property (nonatomic, assign) BOOL isNullable;
@property (nonatomic, assign) BOOL unique;
@property (nonatomic, assign) BOOL index;

- (id)initWithType:(WAFieldType)type name:(NSString *)name;
+ (instancetype)field:(WAFieldType)type :(NSString*)name :(BOOL)null :(BOOL)index;

@end

@interface WATable : NSObject

@property (nonatomic, readonly) NSArray<WAField *> *fields;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *version;

- (WAField *)filedOfName:(NSString *)name;

@end

@interface WAModule : NSObject

@property (nonatomic, readonly) NSInteger ID;

+ (WARows *)execute:(void*)db sqlSegment:(NSString *)sqlSegment params:(NSArray * _Nullable)params;
+ (BOOL)action:(WAModuleActionBlock)block;

+ (WATable *)getTable;

/**
 * 重载这个方法返回这个类的Fields
 */
+ (NSMutableArray<WAField *> *)tableFileds;
/**
 * 重载这个方法返回version,默认是1.0。
 * 在修改表后必须修改这个version否则会引发崩溃。
 */
+ (NSString *)version;

/**
 * 查找modules
 * @param where     sql语句WHERE {where}
 * @param sort      sql语句SORT BY {sort}
 * @param limit     查找限制如果为0表示不限制，默认0
 * @param offset    跳过多少项
 */
+ (NSArray<WAModule *> *)find:(NSString * _Nullable)where sort:(NSString * _Nullable)sort limit:(NSInteger)limit offset:(NSInteger)offset;

/**
 * 查找一个module
 * @param format    会拼成一个where参数
 */
+ (instancetype)findOne:(NSString *)format, ...;

/**
 * 储存这个module
 */
- (void)save;

- (void)remove;

@end

NS_ASSUME_NONNULL_END

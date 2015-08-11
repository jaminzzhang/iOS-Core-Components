//
//  MZQueueDef.m
//
//
//  Created by Jamin on 7/30/14.
//  Copyright © 2015 MZ. All rights reserved.
//

#import "MZQueueDef.h"

static void *kQueueNameKey = (__bridge void *)@"kQueueNameKey";



#pragma mark - Create Queue
/**
 *  创建串行线程队列queue
 *
 *  @param name queue的名称
 *
 *  @return 返回创建的queue
 */
dispatch_queue_t dispatch_create_serial_queue_for_name(const char * name)
{
    dispatch_queue_t customQueue = dispatch_queue_create(name, NULL);
    dispatch_queue_set_specific(customQueue, kQueueNameKey, (void *)(name), NULL);
    return customQueue;
}


/**
 *  创建并行线程队列queue
 *
 *  @param name queue的名称
 *
 *  @return 返回创建的queue
 */
dispatch_queue_t dispatch_create_concurrent_queue_for_name(const char * name)
{
    dispatch_queue_t customQueue = dispatch_queue_create(name, DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_set_specific(customQueue, kQueueNameKey, (void *)name, NULL);
    return customQueue;
}


#pragma mark - check queue


/**
 *  返回当前所在的queue是否是主线程所在的queue
 *
 *  @return
 */
BOOL dispatch_current_queue_is_main_queue()
{
    return [NSThread isMainThread];
}


/**
 *  返回当前的线程队列是否是目标queue
 *
 *  @param queue 对比的queue
 *
 *  @return
 */
BOOL dispatch_current_queue_same_as(dispatch_queue_t queue)
{
    return (dispatch_queue_get_specific(queue, kQueueNameKey) == dispatch_get_specific(kQueueNameKey));
}



#pragma mark - Run block in queue
/**
 *  在queue同步执行block
 *  当前函数就在queue的线程内执行，则直接执行block；
 *  当前函数在其他queue内，则调用dispatch_sync执行
 *
 *  @param queue 目标线程池
 *  @param block 执行的block
 */
void dispatch_sync_in_queue(dispatch_queue_t queue, dispatch_block_t block)
{
    if (dispatch_current_queue_same_as(queue)) {
        block();
    }
    else {
        dispatch_sync(queue, block);
    }
}



/**
 *  在queue异步执行block
 *  当前函数就在queue的线程内执行，则直接执行block；
 *  当前函数在其他queue内，则调用dispatch_async执行
 *
 *  @param queue 目标线程池
 *  @param block 执行的block
 */
void dispatch_async_in_queue(dispatch_queue_t queue, dispatch_block_t block)
{
    if (dispatch_current_queue_same_as(queue)) {
        block();
    }
    else {
        dispatch_async(queue, block);
    }
}



/**
 *  同步在主线程上执行block
 *
 *  @param block
 */
void dispatch_sync_in_main_queue(dispatch_block_t block)
{
    if (dispatch_current_queue_is_main_queue()) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}




/**
 *  异步到主线程上执行block
 *
 *  @param block
 */
void dispatch_async_in_main_queue(dispatch_block_t block)
{
    if (dispatch_current_queue_is_main_queue()) {
        block();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}




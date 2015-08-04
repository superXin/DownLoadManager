//
//  WXDownLoadManager.m
//  WXDownLoadManager
//
//  Created by 周伟昕 on 15/7/21.
//  Copyright (c) 2015年 zwx. All rights reserved.
//

#import "WXDownLoadManager.h"
#import "WXDownLoadTask.h"

@interface WXDownLoadManager()<WXDownLoadTaskDelegate>
//所有任务
@property (nonatomic,strong)NSMutableArray *wx_Array;
//所有任务（存放唯一标示）
@property (nonatomic,strong)NSMutableArray *wx_Array_fileNames;

//正在下载的任务
@property (nonatomic,strong)NSMutableArray *wx_downLoadArray;
//取消的任务
@property (nonatomic,strong)NSMutableArray *wx_suspendArray;

//已完成的任务
@property (nonatomic,strong)NSMutableArray *wx_finishArray;
//已完成的任务（存放唯一标示）
@property (nonatomic,strong)NSMutableArray *wx_finishArray_fileNames;
@end

@implementation WXDownLoadManager
static WXDownLoadManager *_manager;
#pragma mark - 实现单粒
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _manager;
}
#pragma mark - 延时加载
//存放WXDownLoadTask对象的数组
-(NSMutableArray *)wx_Array
{
    if(!_wx_Array)
    {
        _wx_Array = [NSMutableArray array];
    }
    return _wx_Array;
 
}
-(NSMutableArray *)wx_Array_fileNames
{
    if(!_wx_Array_fileNames)
    {
        _wx_Array_fileNames = [NSMutableArray array];
    }
    return _wx_Array_fileNames;
}
-(NSMutableArray *)wx_downLoadArray
{
    if(!_wx_downLoadArray)
    {
        _wx_downLoadArray = [NSMutableArray array];
    }
    return _wx_downLoadArray;
}
-(NSMutableArray *)wx_suspendArray
{
    if(!_wx_suspendArray)
    {
        _wx_suspendArray = [NSMutableArray array];
    }
    return _wx_suspendArray;
}
-(NSMutableArray *)wx_finishArray
{
    if(!_wx_finishArray)
    {
        _wx_finishArray = [NSMutableArray array];
    }
    return _wx_finishArray;
}
-(NSMutableArray *)wx_finishArray_fileNames
{
    if(!_wx_finishArray_fileNames)
       {
           _wx_finishArray_fileNames = [NSMutableArray array];
       }
    return _wx_finishArray_fileNames;
}
-(NSArray *)taskArray
{
    return self.wx_Array;
}

//正在下载的任务
-(NSArray *)downLoadArray
{
    return _wx_downLoadArray;
}
//暂停的任务
-(NSArray *)suspendArray
{
    return _wx_suspendArray;
}
//取消的任务
-(NSArray *)finishArray
{
    return _wx_finishArray;
}

#pragma mark - 开始下载
-(void)startAllTask
{

    if(!self.taskArray.count) return;
    for(WXDownLoadTask *task in self.taskArray)
    {
        [task start];
    }
}
#pragma mark - 暂停下载
-(void)suspendAllTask
{
    if(!self.taskArray.count) return;
    for(WXDownLoadTask *task in self.taskArray)
    {
        [task suspend];
    }
}
#pragma mark - 取消下载
-(void)cancelAllTask
{
    if(!self.taskArray.count) return;
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.taskArray];
    for(WXDownLoadTask *task in tempArray)
    {
        [task cancel];
    }
    [tempArray removeAllObjects];
    
}
#pragma mark - 添加下载任务
-(void)addTask:(WXDownLoadTask *)task
{
    if([self.wx_Array_fileNames indexOfObject:task.fileName] == NSNotFound)
    {
        [self.wx_Array addObject:task];
        [self.wx_Array_fileNames addObject:task.fileName];
    }
    task.ParManager = self;
    if([_delegate respondsToSelector:@selector(WXDownLoadManager:addTask:)])
    {
        [_delegate WXDownLoadManager:self addTask:task];
    }
}



#pragma mark - WXDownLoadTask代理方法
//task开始下载
-(void)WXDownLoadTaskDidBeginDownLoad:(WXDownLoadTask *)task
{
    if([self.wx_finishArray_fileNames indexOfObject:task.fileName] != NSNotFound) return;
    if([self.wx_suspendArray indexOfObject:task] != NSNotFound)
    {
        [self.wx_suspendArray removeObject:task];
    }
    if([self.wx_downLoadArray indexOfObject:task] == NSNotFound)
    {
        [self.wx_downLoadArray addObject:task];
    }
    if([_delegate respondsToSelector:@selector(WXDownLoadManager:BeginLoadTask:)])
    {
        [_delegate WXDownLoadManager:self BeginLoadTask:task];
    }
}
//task暂停下载
-(void)WXDownLoadTaskDidSuspendDownLoad:(WXDownLoadTask *)task
{
    
    if([self.wx_finishArray_fileNames indexOfObject:task.fileName] != NSNotFound) return;
    if([self.wx_suspendArray indexOfObject:task] == NSNotFound && [self.wx_downLoadArray indexOfObject:task] != NSNotFound)
    {
        [self.wx_downLoadArray removeObject:task];
        [self.wx_suspendArray addObject:task];
    }
    if([_delegate respondsToSelector:@selector(WXDownLoadManager:SuspendTask:)])
    {
        [_delegate WXDownLoadManager:self SuspendTask:task];
    }
    if(self.downLoadArray.count == 0)
    {
        if([_delegate respondsToSelector:@selector(WXDownLoadManagerSuspendAllTask:)])
        {
            [_delegate WXDownLoadManagerSuspendAllTask:self];
        }
    }
}
//task取消下载
-(void)WXDownLoadTaskDidCancelDownLoad:(WXDownLoadTask *)task
{
    if([self.wx_suspendArray indexOfObject:task] != NSNotFound)
    {
        [self.wx_suspendArray removeObject:task];
    }
    if([self.wx_downLoadArray indexOfObject:task] != NSNotFound)
    {
        [self.wx_downLoadArray removeObject:task];
    }
    if([self.wx_finishArray indexOfObject:task] != NSNotFound )
    {
        [self.wx_finishArray removeObject:task];
        [self.wx_finishArray_fileNames removeObject:task.fileName];
    }

    [self.wx_Array_fileNames removeObject:task.fileName];
    [self.wx_Array removeObject:task];
    
    if([_delegate respondsToSelector:@selector(WXDownLoadManager:CancelTask:)])
    {
        [_delegate WXDownLoadManager:self CancelTask:task];
    }
    if(self.downLoadArray.count == 0 && self.suspendArray.count ==0)
    {
        if([_delegate respondsToSelector:@selector(WXDownLoadManagerCancelAllTask:)])
        {
            [_delegate WXDownLoadManagerCancelAllTask:self];
        }
    }
}
//task下载完成时
-(void)WXDownLoadTaskDidFinishDownLoad:(WXDownLoadTask *)task
{
    [self.wx_downLoadArray removeObject:task];
    [self.wx_finishArray addObject:task];
    [self.wx_finishArray_fileNames addObject:task.fileName];
    if([_delegate respondsToSelector:@selector(WXDownLoadManager:FinishLoadTask:)])
    {
        [_delegate WXDownLoadManager:self FinishLoadTask:task];
    }
    if(self.suspendArray.count == 0 && self.downLoadArray.count == 0)
    {
        if([_delegate respondsToSelector:@selector(WXDownLoadManagerFinishLoadAllTask:)])
        {
            [_delegate WXDownLoadManagerFinishLoadAllTask:self];
        }
    }
}
@end


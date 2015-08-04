//
//  WXDownLoadManager.h
//  WXDownLoadManager
//
//  Created by 周伟昕 on 15/7/21.
//  Copyright (c) 2015年 zwx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXDownLoadTask.h"
/**
 *  代理方法
 */
@protocol WXDownLoadManagerDelegate <NSObject>
@optional
//当添加某个task的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager addTask:(WXDownLoadTask *)task;

//当某个任务下载完成的时候
/**
 * 此方法的调用不一定会在主线程中，如果在此方法中需要刷新ui界面，需将刷新ui界面的代码放在主线程中调用。
 */
-(void)WXDownLoadManager:(WXDownLoadManager *)manager FinishLoadTask:(WXDownLoadTask *)task;


//当某个任务开始的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager BeginLoadTask:(WXDownLoadTask *)task;
//当某个任务暂停的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager SuspendTask:(WXDownLoadTask *)task;
//当某个任务取消的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager CancelTask:(WXDownLoadTask *)task;


//所有任务下载完毕的时候
-(void)WXDownLoadManagerFinishLoadAllTask:(WXDownLoadManager *)manager;
//所有任务暂停的时候
-(void)WXDownLoadManagerSuspendAllTask:(WXDownLoadManager *)manager;
//所有任务取消的时候
-(void)WXDownLoadManagerCancelAllTask:(WXDownLoadManager *)manager;
@end

@interface WXDownLoadManager : NSObject<WXDownLoadTaskDelegate>
/**
 *  存放WXDownLoadTask对象的数组,用来管理下载任务，可以批量修改下载任务的状态
 * 所有任务
 */
@property (nonatomic,strong)NSArray *taskArray;
//正在下载的任务
@property (nonatomic,strong)NSArray *downLoadArray;
//暂停的任务
@property (nonatomic,strong)NSArray *suspendArray;
//已经完成的任务
@property (nonatomic,strong)NSArray *finishArray;

@property (nonatomic,weak)id<WXDownLoadManagerDelegate> delegate;
//获取默认对象(单粒)
+ (instancetype)sharedManager;


//添加任务(添加后需要调用startAllTask开始下载)
-(void)addTask:(WXDownLoadTask *)task;

//开始下载
-(void)startAllTask;
//暂停下载
-(void)suspendAllTask;
//取消下载
-(void)cancelAllTask;

@end

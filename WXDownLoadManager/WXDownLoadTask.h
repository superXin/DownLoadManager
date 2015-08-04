//
//  WXDownLoadTask.h
//  WXDownLoadManager
//
//  Created by 周伟昕 on 15/7/21.
//  Copyright (c) 2015年 zwx. All rights reserved.
//
#import <Foundation/Foundation.h>
@class WXDownLoadManager;
@class WXDownLoadTask;
/**
 *   WXDownLoadTask 的协议。用于监控WXDownLoadTask的状态变化
 */
@protocol WXDownLoadTaskDelegate <NSObject>
@optional
//完成下载时
-(void)WXDownLoadTaskDidFinishDownLoad:(WXDownLoadTask *)task;
//任务开始
-(void)WXDownLoadTaskDidBeginDownLoad:(WXDownLoadTask *)task;
//任务暂停
-(void)WXDownLoadTaskDidSuspendDownLoad:(WXDownLoadTask *)task;
//任务取消
-(void)WXDownLoadTaskDidCancelDownLoad:(WXDownLoadTask *)task;

/**
 *  下载进度（会调用多次，返回最新的进度）
 *
 *  @param task     任务对象
 *  @param progress 进度值
 *  ！！！如果需要用progress去刷新界面的UI空间.需要将进度值赋值的代码添加到主线程中。
 */
-(void)WXDownLoadTask:(WXDownLoadTask *)task didReceiveProgress:(float)progress;

@end
/**
 *  WXDownLoadTask表示下载任务，可以添加进WXDownLoadManager中执行下载任务(通过WXDownLoadManager来监控下载任务的状态)。
 *  单独使用----每个task对象对应一个下载任务。
 *  使用WXDownLoadTask下载任务：支持断点下载，不会受意外断开影响。
 */
@interface WXDownLoadTask : NSObject
/**
 *  初始化方法
 *
 *  @param ufileURL  文件的url路径
 *  @param file      文件保存的路径，可以传nil，表示保存在Library/Caches中 --- !!!(目前只支持nil)!!!
 *
 */
+(instancetype)taskWithString:(NSString *)fileURL writeToFile:(NSString *)file;
-(instancetype)initWithString:(NSString *)fileURL writeToFile:(NSString *)file;

//代理
@property (nonatomic,weak) id<WXDownLoadTaskDelegate> delegate;

/**
 *  下载任务的状态(默认是0)
 *  0 ---- 等待中的任务（首次添加还没有开始下载的任务）
 *  1 ---- 正在下载的任务
 *  2 ---- 暂停的任务
 *  3 ---- 取消下载的任务
 *  4 ---- 已经完成的任务
 */
@property (nonatomic,readonly)NSInteger state;

//下载文件的名称（文件在服务器的名称）
@property (nonatomic,readonly)NSString *taskName;
//文件的真实路径（文件在手机中真实存储的路径（包括文件在手机中真实存储的名称，名称是唯一编码，跟文件在服务器的名称不一致））
@property (nonatomic,readonly)NSString *filePath;
//文件存在手机中的名称（唯一标识名称）
@property (nonatomic,readonly)NSString *fileName;

//当前的下载进度
@property (nonatomic,assign,readonly)float CurProgress;

//文件所属的WXDownLoadManager，如果是直接通过WXDownLoadTask进行下载，则为nil
@property (nonatomic,weak)WXDownLoadManager *ParManager;


/** 文件总大小和已经下载的大小必须在启动下载任务后才有值 */
//文件总大小
@property (nonatomic,readonly)NSInteger totalLength;
//已经下载的大小
@property (nonatomic,readonly)NSInteger downLoadLength;

//开始下载
-(void)start;
//暂停下载
-(void)suspend;
//取消下载（对已完成的任务会同时删除下载的文件）
-(void)cancel;
@end



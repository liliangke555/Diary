//
//  MDYBaseRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/8.
//

#import "BaseRequest.h"
#import "RSAEncryptor.h"
//#import "AppDelegate+RCT_AppDelegate.h"


//NSString *const ServerAddressWeb = @"https://pharmaforte.xyz/diaryapi";
NSString *const ServerAddressWeb = @"http://47.109.51.24/api";

@implementation BaseRequest
+ (void)load {
    [NSObject mj_setupIgnoredPropertyNames:^NSArray *{
        return @[@"_response",@"_succHandler",@"_failHandler",@"sessionManager",@"response",@"succHandler",@"failHandler",@"isRequestParametersMethodJson",@"hideLoadingView",@"hideErrorHUD",@"notEncryption"];
    }];
}
- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler {
    if (self = [self init]) {
        self.succHandler = succHandler;
    }
    return self;
}

- (AFHTTPSessionManager *)sessionManager {
    if(!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        if(self.isRequestParametersMethodJson) {
            
        }
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = 30;
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"charset=utf-8", nil];
    }
    return _sessionManager;
}

- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail {
    if (self = [self initWithHandler:succHandler]) {
        self.failHandler = fail;
    }
    return self;
}

- (NSString *)uri {
    return @"";
}

- (NSString *)requestMethod {
    return @"POST";
}
- (Class)responseDataClass; {
    return [NSObject class];
}

- (BaseResponse *)response {
    if (!_response) {
        _response = [[BaseResponse alloc] init];
    }
    return _response;
}

- (NSData *)toPostData {
    NSMutableString *string = [[NSMutableString alloc] init];
    return [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}


- (void)parseResponse:(NSObject *)respJsonObject {
    if (respJsonObject && [respJsonObject isKindOfClass:[NSDictionary class]]) {
        NSLog(@"==========[%@]开始解析响应>>>>>>>>>", self);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 子线程解析数据
            if (self->_succHandler) {
                NSDictionary *respJsonDict = (NSDictionary *)respJsonObject;
                
                if([respJsonDict[@"data"] isKindOfClass:[NSDictionary class]]){
                    self.response.data = [[self responseDataClass] mj_objectWithKeyValues:respJsonDict[@"data"]];
                } else  if([respJsonDict[@"data"] isKindOfClass:[NSArray class]]) {
                    self.response.data = [[self responseDataClass] mj_objectArrayWithKeyValuesArray:respJsonDict[@"data"]];
                } else if([respJsonDict[@"data"] isKindOfClass:[NSNull class]]) {
                    self.response.data = nil;
                } else {
                    self.response.data = respJsonDict[@"data"];
                }
                if(respJsonDict[@"success"] && ![respJsonDict[@"success"] isKindOfClass:[NSNull class]]) {
                    self.response.code = [respJsonDict[@"success"] integerValue];
                }
                if(respJsonDict[@"code"] && ![respJsonDict[@"code"] isKindOfClass:[NSNull class]]) {
                    if ([respJsonDict[@"code"] integerValue] == 0) {
                        self.response.code = 0;
                    } else {
                        self.response.code = [respJsonDict[@"code"] integerValue];
                    }
                }
                if(respJsonDict[@"msg"] && ![respJsonDict[@"msg"] isKindOfClass:[NSNull class]]) {
                    self.response.message = respJsonDict[@"msg"];
                }
                if(respJsonDict[@"message"] && ![respJsonDict[@"message"] isKindOfClass:[NSNull class]]) {
                    self.response.message = respJsonDict[@"message"];
                }
                if(respJsonDict[@"count"] && ![respJsonDict[@"count"] isKindOfClass:[NSNull class]]) {
                    id count = respJsonDict[@"count"];
                    if ([count isKindOfClass:[NSString class]]) {
                        self.response.count = [count integerValue];
                    } else {
                        self.response.count = [count integerValue];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self->_response.code == 0) {
                        if (self->_succHandler) {
                            self->_succHandler(self.response);
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (!self.hideErrorHUD) {
                                [MBProgressHUD showMessage:self.response.message];
                            }
                        });
                        //需要登录
                        if(self.response.code == 403 ||self.response.code == 401){
//                            [WSSingleCache clean];
//                            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                            [self animation];
//                            [delegate setRootViewControllerWithLogin:NO];
                        }
                        if (self.response.code == 2) {
                            
                        }
                        // 返回的数据有业务错误
                        if (self->_failHandler) {
                            self->_failHandler(self.response);
                        }
                    }
                    NSLog(@"==========解析响应完成>>>>>>>>>");
                });
            }
        });
    } else  {
        self.response.data = respJsonObject;
        NSLog(@"[%@]返回数据格式不对", [self class]);
        dispatch_async(dispatch_get_main_queue(), ^{
            // 说明返回内容有问题
            if (self->_succHandler) {
                self->_succHandler(self.response);
            }
        });
    }
}

- (void)asyncRequestWithsuccessHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail {
    self.succHandler = succHandler;
    self.failHandler = fail;

    NSString *url = [NSString stringWithFormat:@"%@/%@",ServerAddressWeb,[self uri]];
    
    NSMutableDictionary *paramters = [self mj_keyValues];
    [self.sessionManager.requestSerializer setValue:@"iphone"  forHTTPHeaderField:@"XX-Device-Type"];
    NSString *token = DFSingleCache.shareSingleCache.token;
    if (token.length <= 0) {
        token = @"";
    }
    [self.sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"paramters = %@   \n url = %@  requestMethod = %@ \n paramters = %@",self,url,[self requestMethod],paramters);
    NSLog(@"==========开始请求>>>>>>>>>");
    NSLog(@"HTTP Request Header  =   %@", self.sessionManager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"HTTP Response acceptableContentTypes =   %@", self.sessionManager.responseSerializer.acceptableContentTypes);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
  
    if(!self.hideLoadingView) {
        [MBProgressHUD showLoadingWithMessage:@""];
    }
    
    if([[self requestMethod] isEqualToString:RequestMethodGet]) {
        [self.sessionManager GET:url parameters:paramters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self requestSuccess:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"网络错误++++++%@+++++",error);
             [self requestFaild:(NSHTTPURLResponse *)task.response error:error];
        }];
    } else if([[self requestMethod] isEqualToString:RequestMethodPut]) {
        [self.sessionManager PUT:url parameters:paramters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self requestSuccess:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"网络错误++++++%@+++++",error);
            [self requestFaild:(NSHTTPURLResponse *)task.response error:error];
        }];
    } else if([[self requestMethod] isEqualToString:RequestMethodDelete]) {
        [self.sessionManager DELETE:url parameters:paramters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self requestSuccess:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"网络错误++++++%@+++++",error);
             [self requestFaild:(NSHTTPURLResponse *)task.response error:error];
        }];
    } else {
        [self.sessionManager POST:url parameters:paramters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             [self requestSuccess:responseObject];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"网络错误++++++%@+++++",error);
             [self requestFaild:(NSHTTPURLResponse *)task.response error:error];
         }];
    }
}

- (void)asyncCheckRequestWithsuccessHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail {
    self.succHandler = succHandler;
    self.failHandler = fail;

    NSString *url = [NSString stringWithFormat:@"%@",[self uri]];
    NSMutableDictionary *paramters = [self mj_keyValues];
    [self.sessionManager.requestSerializer setValue:@"2"  forHTTPHeaderField:@"deviceType"];
    [self.sessionManager.requestSerializer setValue:WSPackageName  forHTTPHeaderField:@"packageName"];
    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self.sessionManager.requestSerializer setValue:deviceUUID  forHTTPHeaderField:@"appId"];
    [self.sessionManager.requestSerializer setValue:deviceUUID  forHTTPHeaderField:@"allAppId"];
//    NSString *version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self.sessionManager.requestSerializer setValue:WSVersion  forHTTPHeaderField:@"version"];
    [self.sessionManager.requestSerializer setValue:@"zh-Hans-CN" forHTTPHeaderField:@"locale"];
    [self.sessionManager.requestSerializer setValue:@"460" forHTTPHeaderField:@"cardtype"];
    [self.sessionManager.requestSerializer setValue:@"2" forHTTPHeaderField:@"deviceType"];
    [self.sessionManager.requestSerializer setValue:@"1" forHTTPHeaderField:@"useVpn"];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%.0lf", (double)[[NSDate  date] timeIntervalSince1970]*1000] forHTTPHeaderField:@"localTime"];
    NSString *token = DFSingleCache.shareSingleCache.token;
    if (token.length <= 0) {
        token = @"";
    }
    [self.sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"paramters = %@   \n url = %@  requestMethod = %@ \n paramters = %@",self,url,[self requestMethod],paramters);
    NSLog(@"==========开始请求>>>>>>>>>");
    NSLog(@"HTTP Request Header  =   %@", self.sessionManager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"HTTP Response acceptableContentTypes =   %@", self.sessionManager.responseSerializer.acceptableContentTypes);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
  
    if(!self.hideLoadingView) {
        [MBProgressHUD showLoadingWithMessage:@""];
    }
    
    if([[self requestMethod] isEqualToString:RequestMethodGet]) {
        [self.sessionManager GET:url parameters:paramters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            [self requestSuccess:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"网络错误++++++%@+++++",error);
             [self requestFaild:(NSHTTPURLResponse *)task.response error:error];
        }];
    
    } else if([[self requestMethod] isEqualToString:RequestMethodPut]) {

    } else if([[self requestMethod] isEqualToString:RequestMethodDelete]) {
        
    } else {
       
    }
}
- (void)asyncRequestWithFormDatas:(NSArray<NSData *> *)formDatas formName:(NSString *)formName successHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail {
    self.succHandler = succHandler;
    self.failHandler = fail;
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",ServerAddressWeb,[self uri]];
    NSMutableDictionary *paramters = [[self mj_keyValues] mutableCopy];

    _sessionManager.requestSerializer.timeoutInterval = 6000;

    
    NSLog(@"paramters = %@   url = %@  requestMethod = %@",self,url,[self requestMethod]);
    
    NSLog(@"==========[%@]开始请求>>>>>>>>>", paramters);
    
    NSLog(@"HTTP Request Header  =   %@", self.sessionManager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"HTTP Response acceptableContentTypes =   %@", self.sessionManager.responseSerializer.acceptableContentTypes);
    
    [self.sessionManager POST:url parameters:paramters headers:nil constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
//        for (NSData *data in formDatas)
//        {
//            [formData appendPartWithFileData:data name:formName fileName:[NSString stringWithFormat:@"%@.jpg",@([FlyClientTools getNowTimeStamp])] mimeType:@"image/jpg"];
//        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度+++++++++++%@",@(uploadProgress.fractionCompleted));
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"上传成功+++++++++++");
         [self requestSuccess:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"上传失败++++++%@+++++",error);
         [self requestFaild:(NSHTTPURLResponse *)task.response error:error];
     }];
}


- (void)asyncRequestWithVoiceData:(NSData *)data formName:(NSString *)formName successHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail {
    self.succHandler = succHandler;
    self.failHandler = fail;
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",ServerAddressWeb,[self uri]];
    NSMutableDictionary *paramters = [[self mj_keyValues] mutableCopy];
    _sessionManager.requestSerializer.timeoutInterval = 6000;

    
    NSLog(@"paramters = %@   url = %@  requestMethod = %@",self,url,[self requestMethod]);
    
    NSLog(@"==========[%@]开始请求>>>>>>>>>", paramters);
    
    NSLog(@"HTTP Request Header  =   %@", self.sessionManager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"HTTP Response acceptableContentTypes =   %@", self.sessionManager.responseSerializer.acceptableContentTypes);
    
    [self.sessionManager POST:url parameters:paramters headers:nil constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
//        [formData appendPartWithFileData:data name:formName fileName:[NSString stringWithFormat:@"%@.amr",@([FlyClientTools getNowTimeStamp])] mimeType:@"audio/AMR"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度+++++++++++%@",@(uploadProgress.fractionCompleted));
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"上传成功+++++++++++");
         [self requestSuccess:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"上传失败++++++%@+++++",error);
         [self requestFaild:(NSHTTPURLResponse *)task.response error:error];
     }];
}
#pragma mark -- 上传图片 --
- (void)uploadWitImagedData:(NSData *)imageData
                 uploadName:(NSString *)uploadName
                   progress:(void (^)(NSProgress *progress))progress
             successHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail {
    self.succHandler = succHandler;
    self.failHandler = fail;
    
    NSMutableDictionary *paramters = [[self mj_keyValues] mutableCopy];

    
    _sessionManager.requestSerializer.timeoutInterval = 6000;
    NSString *url = [NSString stringWithFormat:@"%@/%@",ServerAddressWeb,[self uri]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    NSString *token = [DFSingleCache.shareSingleCache token];
    if (token.length <= 0) {
        token = @"";
    }
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
    [manager.requestSerializer setValue:@"2"  forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:WSPackageName  forHTTPHeaderField:@"packageName"];
    [manager.requestSerializer setValue:WSAPPID  forHTTPHeaderField:@"appId"];
    [manager.requestSerializer setValue:WSAPPID  forHTTPHeaderField:@"allAppId"];
//    NSString *version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:WSVersion  forHTTPHeaderField:@"version"];
    [manager.requestSerializer setValue:@"zh-Hans-CN" forHTTPHeaderField:@"locale"];
    [manager.requestSerializer setValue:@"460" forHTTPHeaderField:@"cardtype"];
    [manager.requestSerializer setValue:WSDeviceType forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"useVpn"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%.0lf", (double)[[NSDate  date] timeIntervalSince1970]*1000] forHTTPHeaderField:@"localTime"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    [manager POST:url parameters:paramters headers:nil constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
        if (imageData) {
            [formData appendPartWithFileData:imageData name:uploadName fileName:[NSString stringWithFormat:@"%@.jpg",str] mimeType:@"image/jpg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress) {
            progress(uploadProgress);
        }
         NSLog(@"上传进度+++++++++++%@",@(uploadProgress.fractionCompleted));
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"上传成功+++++++++++");
        NSMutableDictionary *dataSource = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"data"] isKindOfClass:NSString.class]) {
                NSString *string = [[RSAEncryptor sharedInstance] rsaDecryptString:responseObject[@"data"]];
                NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                id content = dataDic[@"content"];
                if (content) {
                    [dataSource setObject:content forKey:@"data"];
                } else {
                    [dataSource setObject:dataDic forKey:@"data"];
                }
            }
        }
        [self requestSuccess:dataSource];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"上传失败++++++%@+++++",error);
         [self requestFaild:(NSHTTPURLResponse *)task.response error:error];
     }];
}

- (void)uploadWitImagedDatas:(NSArray <UIImage *>*)imageDatas
                 uploadName:(NSString *)uploadName
                   progress:(void (^)(NSProgress *progress))progress
             successHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail {
    self.succHandler = succHandler;
    self.failHandler = fail;
    
    NSMutableDictionary *paramters = [[self mj_keyValues] mutableCopy];

    
    _sessionManager.requestSerializer.timeoutInterval = 6000;
    NSString *url = [NSString stringWithFormat:@"%@/%@",ServerAddressWeb,[self uri]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    [manager.requestSerializer setValue:@"iphone"  forHTTPHeaderField:@"XX-Device-Type"];
    NSString *token = [DFSingleCache shareSingleCache].token;
    if (token.length <= 0) {
        token = @"";
    }
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
    [manager POST:url parameters:paramters headers:nil constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
        for (UIImage *image in imageDatas) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSData *imageData = [self compressWithMaxLength:4*1024*1024 image:image];
            [formData appendPartWithFileData:imageData name:uploadName fileName:[NSString stringWithFormat:@"%@.jpg",str] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress) {
            progress(uploadProgress);
        }
         NSLog(@"上传进度+++++++++++%@",@(uploadProgress.fractionCompleted));
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"上传成功+++++++++++");
         [self requestSuccess:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"上传失败++++++%@+++++",error);
         [self requestFaild:(NSHTTPURLResponse *)task.response error:error];
     }];
}

- (void)requestSuccess:(id)responseObject {
    if (!self.hideLoadingView) {
        [MBProgressHUD hideHUD];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    
    [self parseResponse:responseObject];
    NSLog(@"%@'response = %@",[self class],responseObject);
}

- (void)requestFaild:(NSHTTPURLResponse *)responses error:(NSError *)error {
    if (!self.hideLoadingView) {
        [MBProgressHUD hideHUD];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSInteger state = responses.statusCode;
    NSString *msg = @"服务器错误";
    if(responses.statusCode == 500)//服务器内部错误
    {
        msg = @"服务器错误";
    } else if(responses.statusCode == 401)//授权失败 直接跳转登录界面
    {
        //跳转登录界面
//        [[HUDHelper sharedInstance] tipMessage:@"授权失败"];
        return;
    } else {
         if(error && error.code == NSURLErrorTimedOut) {
             state = -2;
             msg = @"网络连接超时";
         } else if (error && error.code == NSURLErrorNotConnectedToInternet) {
            state = -1;
            msg = @"网络连接失败";
        }
    }
    self.response.code = state;
    self.response.message = msg;
    if (!self.hideErrorHUD) {
        [MBProgressHUD showMessage:msg];
    }
    if(self.failHandler)  {
        self.failHandler(self.response);
    }
}


//+ (NSString *)getSignWithParamters:(NSDictionary *)paramters timeString:(NSString *)timeString{
//    NSString *sortString = [self stringWithDict:paramters];
//    NSString *secrectKey = [EJSUserTokenModel userTokenModel].secretKey;
//    return [[NSString stringWithFormat:@"%@%@%@",sortString,secrectKey,timeString] md5];
//}

+(NSString*)stringWithDict:(NSDictionary*)dict{
    NSArray*keys = [dict allKeys];
    NSArray*sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        return[obj1 compare:obj2 options:NSNumericSearch];//正序
    }];
    NSString*str =@"";
    for(NSString*categoryId in sortedArray) {
        id value = [dict objectForKey:categoryId];
        if(str.length > 0){
            str = [str stringByAppendingString:@"&"];
        }
        str = [str stringByAppendingFormat:@"%@=%@",categoryId,value];
    }
    return str;
}


//+ (NSString *)makeSignForVerifyCode:(NSString *)phone phoneType:(NSString *)phoneType
//{
//    NSData *stringData = [phone dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *encodedString = [GTMBase64 stringByEncodingData:stringData];
//
//    return [[NSString stringWithFormat:@"%@%@",[self hexStringFromString:encodedString],phoneType] md5];
//}

+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange,BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i =0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) &0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

+ (NSString *)hexStringWithData:(NSData *)data {
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    if (!dataBuffer) {
        return [NSString string];
    }
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", (unsigned char)dataBuffer[i]];
    }
    return [NSString stringWithString:hexString];
}

- (NSData *)compressWithMaxLength:(NSUInteger)maxLength image:(UIImage *)image{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}
@end

@implementation BaseResponse

- (instancetype)init
{
    if (self = [super init])
    {
        // 默认成功
        _code = 0;
        _message = @"";
        _status = @"SUCCESSS";
    }
    return self;
}

- (BOOL)success
{
    if([_status isEqualToString:@"SUCCESSS"])
    {
        return YES;
    }
    return NO;
}

- (NSString *)msg
{
    return _message?_message:@"";
}

@end


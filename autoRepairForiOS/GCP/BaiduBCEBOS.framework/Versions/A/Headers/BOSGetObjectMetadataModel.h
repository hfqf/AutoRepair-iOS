/*
 * Copyright (c) 2016 Baidu.com, Inc. All Rights Reserved
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */

#import <BaiduBCEBOS/BOSResponse.h>
#import <BaiduBCEBOS/BOSCommonModel.h>
#import <BaiduBCEBOS/BOSObjectRelatedModel.h>

/**
 *  @brief BOS get object metadata request.
 */
@interface BOSGetObjectMetadataRequest : BOSObjectRelatedRequest
@end

/**
 *  @brief BOS get object metadata response.
 */
@interface BOSGetObjectMetadataResponse : BOSResponse

/**
 *  @brief HTTP Headers
 */
@property(nonatomic, copy) NSString* cacheControl;
@property(nonatomic, copy) NSString* contentDisposition;
@property(nonatomic, copy) NSString* contentRange;
@property(nonatomic, copy) NSString* expires;

/**
 *  @brief The object's user metadata.
 */
@property(nonatomic, strong) NSDictionary<NSString*, NSString*>* userMetadata;

@end

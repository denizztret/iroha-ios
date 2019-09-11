/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRGetAccountDetail.h"
#import "Queries.pbobjc.h"
#import "Primitive.pbobjc.h"

@implementation IRGetAccountDetail

@synthesize accountId = _accountId;
@synthesize pagination = _pagination;

- (nonnull instancetype)initWithAccountId:(nullable id<IRAccountId>)accountId
                               pagination:(nonnull id<IRAccountDetailPagination>)pagination {
    if (self = [super init]) {
        _accountId = accountId;
        _pagination = pagination;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError **)error {
    GetAccountDetail *query = [GetAccountDetail new];
    
    AccountDetailRecordId *recordId = [AccountDetailRecordId new];
    recordId.writer = _pagination.nextRecordId.writer;
    recordId.key = _pagination.nextRecordId.key;

    AccountDetailPaginationMeta *meta = [AccountDetailPaginationMeta new];
    meta.pageSize = _pagination.pageSize;
    meta.firstRecordId = recordId;

    query.accountId = [_accountId identifier];
    query.paginationMeta = meta;
    
    Query_Payload *payload = [Query_Payload new];
    payload.getAccountDetail = query;
    
    return payload;
}

@end

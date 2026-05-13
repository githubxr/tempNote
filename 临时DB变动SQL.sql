

#注销需求相关数据库变动
#权限（waiting）
#...

#注销记录表
CREATE TABLE `member_disable_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户ID',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `disable_member_id` int DEFAULT NULL COMMENT '注销会员ID',
  `member_no` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '注销会员编号',
  `balance_before` int DEFAULT NULL COMMENT '注销会员注销前余额（分）',  
  `remark` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注说明',
  `operator_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员注销记录表'
;
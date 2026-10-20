-- 电子病历操作日志（历次操作印痕，可查询可追溯）
CREATE TABLE emr_audit_log (
  id          BIGINT      NOT NULL AUTO_INCREMENT,
  emr_id      BIGINT      NOT NULL,
  operator    VARCHAR(64) NOT NULL,
  operation   VARCHAR(32) NOT NULL,
  operated_at DATETIME    NOT NULL,
  trace_id    VARCHAR(64) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_emr (emr_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='电子病历操作日志';

-- 电子病历主表（含操作留痕字段）
CREATE TABLE emr_record (
  id            BIGINT       NOT NULL AUTO_INCREMENT,
  patient_id    BIGINT       NOT NULL,
  content       LONGTEXT     NOT NULL,
  version       INT          NOT NULL DEFAULT 1,
  created_by    VARCHAR(64)  NOT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by    VARCHAR(64)  NOT NULL,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_patient (patient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='电子病历';

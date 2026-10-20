-- 电子病历主表
CREATE TABLE emr_record (
  id            BIGINT       NOT NULL AUTO_INCREMENT,
  patient_id    BIGINT       NOT NULL,
  content       LONGTEXT     NOT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_patient (patient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='电子病历';

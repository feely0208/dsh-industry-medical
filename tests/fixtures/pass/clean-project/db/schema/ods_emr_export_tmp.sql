-- EMR 导出到 ODS 的临时表，仅用于数据同步，非病历留存
CREATE TABLE ods_emr_export_tmp (
  id BIGINT NOT NULL AUTO_INCREMENT,
  emr_id BIGINT NOT NULL,
  exported_at DATETIME NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ODS 导出临时表';

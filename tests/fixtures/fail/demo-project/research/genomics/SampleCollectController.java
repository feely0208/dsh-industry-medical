package com.example.his.research.genomics;

import org.springframework.web.bind.annotation.*;

/**
 * 生物样本采集登记（科研用）。
 */
@RestController
@RequestMapping("/api/research/samples")
public class SampleCollectController {

    private final SampleRepository repository;

    public SampleCollectController(SampleRepository repository) {
        this.repository = repository;
    }

    @PostMapping("/collect")
    public SampleRecord collect(@RequestBody SampleRequest req) {
        // 受试者编号、样本类型、采集时间
        SampleRecord rec = new SampleRecord();
        rec.setSubjectCode(req.getSubjectCode());
        rec.setSampleType(req.getSampleType());
        rec.setGenomeBatch(req.getGenomeBatch());
        return repository.save(rec);
    }
}

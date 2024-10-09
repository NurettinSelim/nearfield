package com.example.phoneserver.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.phoneserver.entity.Record;
import com.example.phoneserver.service.RecordService;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/records")
public class RecordController {

    @Autowired
    private RecordService recordService;

    // Create a new record
    @PostMapping
    public Record createRecord(@RequestBody Record record) {
        return recordService.saveRecord(record);
    }

    // Get all records
    @GetMapping
    public List<Record> getAllRecords() {
        return recordService.getAllRecords();
    }

    // Get a record by ID
    @GetMapping("/{id}")
    public ResponseEntity<Record> getRecordById(@PathVariable Long id) {
        Optional<Record> record = recordService.getRecordById(id);
        if (record.isPresent()) {
            return ResponseEntity.ok(record.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Update a record
    @PutMapping("/{id}")
    public ResponseEntity<Record> updateRecord(@PathVariable Long id, @RequestBody Record recordDetails) {
        Optional<Record> optionalRecord = recordService.getRecordById(id);
        if (optionalRecord.isPresent()) {
            Record record = optionalRecord.get();
            record.setPhoneNumber(recordDetails.getPhoneNumber());
            record.setMessage(recordDetails.getMessage());
            record.setTimestamp(recordDetails.getTimestamp());
            Record updatedRecord = recordService.saveRecord(record);
            return ResponseEntity.ok(updatedRecord);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Delete a record
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRecord(@PathVariable Long id) {
        Optional<Record> record = recordService.getRecordById(id);
        if (record.isPresent()) {
            recordService.deleteRecord(id);
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}

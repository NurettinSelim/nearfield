package com.example.phoneserver.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.phoneserver.entity.Record;
import com.example.phoneserver.repository.RecordRepository;

import java.util.List;
import java.util.Optional;

@Service
public class RecordService {

    @Autowired
    private RecordRepository recordRepository;

    public Record saveRecord(Record record) {
        return recordRepository.save(record);
    }

    public List<Record> getAllRecords() {
        return recordRepository.findAll();
    }

    public Optional<Record> getRecordById(Long id) {
        return recordRepository.findById(id);
    }

    public void deleteRecord(Long id) {
        recordRepository.deleteById(id);
    }
}

package com.s21.devops.sample.reportservice.Statistics;

import io.micrometer.core.instrument.MeterRegistry;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.s21.devops.sample.reportservice.Communication.BookingStatisticsMessage;
import com.s21.devops.sample.reportservice.Service.BookingStatsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


@Component
public class QueueConsumer {
    @Autowired
    private BookingStatsService bookingStatsService;

    @Autowired
    private MeterRegistry meterRegistry;

    private ObjectMapper objectMapper = new ObjectMapper();

    public void receiveMessage(String message) throws JsonProcessingException {
        System.out.println("Received !!! (String) " + message);
        processMessage(message);
        meterRegistry.counter("rabbitmq.messages.received").increment();
    }

    public void receiveMessage(byte[] message) throws JsonProcessingException {
        String strMessage = new String(message);
        System.out.println("Received !!! (No String) " + strMessage);
        processMessage(strMessage);
        meterRegistry.counter("rabbitmq.messages.received").increment();
    }

    private void processMessage(String message) throws JsonProcessingException {
        BookingStatisticsMessage bsm = objectMapper.readValue(message, BookingStatisticsMessage.class);
        bookingStatsService.postBookingStatsMessage(bsm);
    }
}

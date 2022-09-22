package com.slalom.api;

import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class GreetingControllerTest {

    @Autowired
    private TestRestTemplate template;

    @Test
    public void getGreeting() throws Exception {
        ResponseEntity<String> response = template.getForEntity("/greeting?name=Person", String.class);
        assertThat(response.getBody()).isEqualTo("{\"id\":1,\"content\":\"Hello, Person!\"}");
    }

}
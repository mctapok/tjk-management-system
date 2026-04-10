package com.gavrilov_di.tjk_management_system;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootTest
public class PasswordEncoderTest {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Test
    void generateHashes() {
        System.out.println(passwordEncoder.encode("admin123"));
        System.out.println(passwordEncoder.encode("store123"));
    }
}
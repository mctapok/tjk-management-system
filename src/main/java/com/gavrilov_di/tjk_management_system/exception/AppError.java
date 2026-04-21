package com.gavrilov_di.tjk_management_system.exception;

import lombok.Data;

import java.util.Date;

@Data
public class AppError extends RuntimeException {
    private int status;
    private String message;
    private Date timestamp;

    public AppError(int status, String message) {
        this.status = status;
        this.message = message;
        this.timestamp = new Date();
    }
}

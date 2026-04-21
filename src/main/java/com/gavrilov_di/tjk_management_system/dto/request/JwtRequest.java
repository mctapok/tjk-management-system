package com.gavrilov_di.tjk_management_system.dto.request;

import lombok.Data;

@Data
public class JwtRequest {
    private  String email;
    private  String password;
}

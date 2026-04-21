package com.gavrilov_di.tjk_management_system.repository;

import com.gavrilov_di.tjk_management_system.entity.User;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface UserRepository extends CrudRepository<User, Long> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
}

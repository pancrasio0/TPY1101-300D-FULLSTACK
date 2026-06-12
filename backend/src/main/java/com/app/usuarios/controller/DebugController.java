package com.app.usuarios.controller;

import com.app.usuarios.repository.UsuarioRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
@RequestMapping("/api/debug")
public class DebugController {

    private final UsuarioRepository usuarioRepository;

    public DebugController(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    @GetMapping("/check")
    public ResponseEntity<?> check() {
        var admin = usuarioRepository.findByUsername("admin").orElse(null);
        if (admin == null) return ResponseEntity.ok(Map.of("error", "admin not found"));
        String pwd = admin.getPassword();
        return ResponseEntity.ok(Map.of(
            "pwd_length", pwd != null ? pwd.length() : -1,
            "pwd_prefix", pwd != null ? pwd.substring(0, Math.min(10, pwd.length())) : "null",
            "pwd_hex", pwd != null ? bytesToHex(pwd.getBytes(java.nio.charset.StandardCharsets.UTF_8)) : "null",
            "starts_with_2a", pwd != null && pwd.startsWith("\\$")
        ));
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) sb.append(String.format("%02x", b & 0xff));
        return sb.toString();
    }
}
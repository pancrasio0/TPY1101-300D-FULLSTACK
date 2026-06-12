package com.app.usuarios.service;

import com.app.usuarios.dto.LoginRequest;
import com.app.usuarios.dto.LoginResponse;
import com.app.usuarios.model.Usuario;
import com.app.usuarios.repository.UsuarioRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);

    private final UsuarioRepository usuarioRepository;
    private final JwtService jwtService;
    private final BCryptPasswordEncoder passwordEncoder;

    public AuthService(UsuarioRepository usuarioRepository,
                       JwtService jwtService,
                       BCryptPasswordEncoder passwordEncoder) {
        this.usuarioRepository = usuarioRepository;
        this.jwtService = jwtService;
        this.passwordEncoder = passwordEncoder;
    }

    public LoginResponse login(LoginRequest request) {
        Usuario usuario = usuarioRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new RuntimeException("Credenciales inválidas"));

        String storedPwd = usuario.getPassword();
        log.info("Stored password length: {}", storedPwd != null ? storedPwd.length() : -1);
        log.info("Stored password prefix: {}", storedPwd != null ? storedPwd.substring(0, Math.min(10, storedPwd.length())) : "null");
        log.info("Stored password starts with \\$2a: {}", storedPwd != null && storedPwd.startsWith("$2a$"));

        boolean matches = passwordEncoder.matches(request.getPassword(), storedPwd);
        log.info("BCrypt matches: {}", matches);

        if (!matches) {
            throw new RuntimeException("Credenciales inválidas");
        }

        if (Boolean.FALSE.equals(usuario.getActivo())) {
            throw new RuntimeException("Usuario inactivo");
        }

        String token = jwtService.generateToken(usuario.getUsername());
        return new LoginResponse(token);
    }
}

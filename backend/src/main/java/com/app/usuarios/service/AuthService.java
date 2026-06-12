package com.app.usuarios.service;

import com.app.usuarios.dto.LoginRequest;
import com.app.usuarios.dto.LoginResponse;
import com.app.usuarios.model.Usuario;
import com.app.usuarios.repository.UsuarioRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

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

        if (!passwordEncoder.matches(request.getPassword(), usuario.getPassword())) {
            throw new RuntimeException("Credenciales inválidas");
        }

        if (Boolean.FALSE.equals(usuario.getActivo())) {
            throw new RuntimeException("Usuario inactivo");
        }

        String token = jwtService.generateToken(usuario.getUsername());
        return new LoginResponse(token);
    }
}

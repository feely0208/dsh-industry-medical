package com.example.his.auth.controller;

import org.springframework.web.bind.annotation.*;

/**
 * 登录控制器：人脸识别与账号密码两种方式并存。
 */
@RestController
@RequestMapping("/api/auth")
public class FaceAuthController {

    private final FaceService faceService;
    private final LoginService loginService;

    public FaceAuthController(FaceService faceService, LoginService loginService) {
        this.faceService = faceService;
        this.loginService = loginService;
    }

    @PostMapping("/face-login")
    public LoginResult faceLogin(@RequestBody FaceLoginRequest req) {
        String faceId = faceService.detect(req.getImageBase64());
        if (faceId == null) {
            return LoginResult.fail("人脸识别失败，请改用账号密码登录");
        }
        String userId = faceService.matchUser(faceId);
        return LoginResult.ok(faceService.issueToken(userId));
    }

    @PostMapping("/password-login")
    public LoginResult passwordLogin(@RequestBody PasswordLoginRequest req) {
        return loginService.login(req.getUsername(), req.getPassword());
    }
}

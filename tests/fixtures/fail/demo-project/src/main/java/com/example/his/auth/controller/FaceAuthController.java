package com.example.his.auth.controller;

import org.springframework.web.bind.annotation.*;

/**
 * 人脸识别登录。
 */
@RestController
@RequestMapping("/api/auth")
public class FaceAuthController {

    private final FaceService faceService;

    public FaceAuthController(FaceService faceService) {
        this.faceService = faceService;
    }

    @PostMapping("/face-login")
    public LoginResult faceLogin(@RequestBody FaceLoginRequest req) {
        String faceId = faceService.detect(req.getImageBase64());
        if (faceId == null) {
            return LoginResult.fail("人脸识别失败");
        }
        String userId = faceService.matchUser(faceId);
        return LoginResult.ok(faceService.issueToken(userId));
    }
}

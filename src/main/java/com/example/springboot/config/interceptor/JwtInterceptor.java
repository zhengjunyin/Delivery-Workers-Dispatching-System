package com.example.springboot.config.interceptor;

import cn.hutool.core.util.StrUtil;
import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTDecodeException;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.example.springboot.common.Constants;
import com.example.springboot.entity.Account;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.service.IAdminService;
import com.example.springboot.service.IUserService;
import com.example.springboot.utils.SecurityUtils;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

public class JwtInterceptor implements HandlerInterceptor {

    @Resource
    private IUserService userService;
    @Resource
    private IAdminService adminService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        if (handler instanceof HandlerMethod handlerMethod) {
            AuthAccess annotation = handlerMethod.getMethodAnnotation(AuthAccess.class);
            if (annotation != null) {
                return true;
            }
        }

        String token = request.getHeader("token");
        if (StrUtil.isBlank(token)) {
            token = request.getParameter("token");
        }
        if (StrUtil.isBlank(token)) {
            throw new ServiceException(Constants.CODE_401, "Missing token, please log in again");
        }

        Account account;
        try {
            String accountInfo = JWT.decode(token).getAudience().get(0);
            String[] parts = accountInfo.split("-", 2);
            if (parts.length != 2) {
                throw new JWTDecodeException("Invalid token audience");
            }
            Integer accountId = Integer.valueOf(parts[0]);
            String accountRole = parts[1];

            if (StrUtil.equals(accountRole, SecurityUtils.ROLE_USER)) {
                account = userService.getById(accountId);
            } else if (StrUtil.equals(accountRole, SecurityUtils.ROLE_ADMIN)) {
                account = adminService.getById(accountId);
            } else {
                throw new JWTDecodeException("Invalid role");
            }
        } catch (JWTDecodeException | NumberFormatException e) {
            throw new ServiceException(Constants.CODE_401, "Token verification failed, please log in again");
        }

        if (account == null || StrUtil.isBlank(account.getPassword())) {
            throw new ServiceException(Constants.CODE_401, "User does not exist, please log in again");
        }

        JWTVerifier jwtVerifier = JWT.require(Algorithm.HMAC256(account.getPassword())).build();
        try {
            jwtVerifier.verify(token);
        } catch (JWTVerificationException e) {
            throw new ServiceException(Constants.CODE_401, "Token verification failed, please log in again");
        }
        return true;
    }
}

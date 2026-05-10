package com.example.springboot.utils;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.example.springboot.entity.Account;
import com.example.springboot.service.IAdminService;
import com.example.springboot.service.IUserService;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.Date;

@Component
public class TokenUtils {

    private static IUserService staticUserService;
    private static IAdminService staticAdminService;

    @Resource
    private IUserService userService;
    @Resource
    private IAdminService adminService;

    @PostConstruct
    public void initService() {
        staticUserService = userService;
        staticAdminService = adminService;
    }

    public static String createToken(String data, String sign) {
        return JWT.create()
                .withAudience(data)
                .withExpiresAt(DateUtil.offsetHour(new Date(), 2))
                .sign(Algorithm.HMAC256(sign));
    }

    public static Account getCurrentUser() {
        try {
            ServletRequestAttributes attributes =
                    (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes == null) {
                return null;
            }
            HttpServletRequest request = attributes.getRequest();
            String token = request.getHeader("token");
            if (StrUtil.isBlank(token)) {
                token = request.getParameter("token");
            }
            if (StrUtil.isBlank(token)) {
                return null;
            }

            String accountInfo = JWT.decode(token).getAudience().get(0);
            String[] parts = accountInfo.split("-", 2);
            if (parts.length != 2) {
                return null;
            }
            String accountId = parts[0];
            String accountRole = parts[1];

            Account account = null;
            if (StrUtil.equals(accountRole, SecurityUtils.ROLE_USER)) {
                account = staticUserService.getById(Integer.valueOf(accountId));
            }
            if (StrUtil.equals(accountRole, SecurityUtils.ROLE_ADMIN)) {
                account = staticAdminService.getById(Integer.valueOf(accountId));
            }
            if (account != null) {
                account.setRole(accountRole);
            }
            return account;
        } catch (Exception e) {
            return null;
        }
    }
}

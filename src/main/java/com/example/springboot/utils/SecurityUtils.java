package com.example.springboot.utils;

import cn.hutool.core.util.StrUtil;
import com.example.springboot.common.Constants;
import com.example.springboot.entity.Account;
import com.example.springboot.exception.ServiceException;

import java.util.Collection;

public class SecurityUtils {

    public static final String ROLE_USER = "ROLE_USER";
    public static final String ROLE_ADMIN = "ROLE_ADMIN";

    private SecurityUtils() {
    }

    public static Account currentUser() {
        Account account = TokenUtils.getCurrentUser();
        if (account == null || account.getId() == null || StrUtil.isBlank(account.getRole())) {
            throw new ServiceException(Constants.CODE_401, "Please log in again");
        }
        return account;
    }

    public static boolean isAdmin(Account account) {
        return account != null && StrUtil.equals(account.getRole(), ROLE_ADMIN);
    }

    public static Account requireAdmin() {
        Account account = currentUser();
        if (!isAdmin(account)) {
            throw new ServiceException(Constants.CODE_403, "No permission");
        }
        return account;
    }

    public static void requireOwnerOrAdmin(Integer ownerId) {
        Account account = currentUser();
        if (!isAdmin(account) && (ownerId == null || !ownerId.equals(account.getId()))) {
            throw new ServiceException(Constants.CODE_403, "No permission");
        }
    }

    public static <T extends Account> T clearPassword(T account) {
        if (account != null) {
            account.setPassword(null);
        }
        return account;
    }

    public static <T extends Account> Collection<T> clearPasswords(Collection<T> accounts) {
        if (accounts != null) {
            accounts.forEach(SecurityUtils::clearPassword);
        }
        return accounts;
    }
}

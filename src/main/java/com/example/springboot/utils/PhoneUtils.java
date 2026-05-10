package com.example.springboot.utils;

import cn.hutool.core.util.StrUtil;
import com.example.springboot.common.Constants;
import com.example.springboot.exception.ServiceException;

import java.util.regex.Pattern;

public class PhoneUtils {

    private static final Pattern BELARUS_PHONE = Pattern.compile("^\\+375\\d{9}$");

    private PhoneUtils() {
    }

    public static String normalizeOptionalBelarusPhone(String phone) {
        if (StrUtil.isBlank(phone)) {
            return "";
        }
        String normalized = normalize(phone);
        if (!BELARUS_PHONE.matcher(normalized).matches()) {
            throw new ServiceException(Constants.CODE_400, "Please enter a Belarus phone number in +375XXXXXXXXX format");
        }
        return normalized;
    }

    public static String normalizeRequiredBelarusPhone(String phone) {
        String normalized = normalize(phone);
        if (!BELARUS_PHONE.matcher(normalized).matches()) {
            throw new ServiceException(Constants.CODE_400, "Please enter a Belarus phone number in +375XXXXXXXXX format");
        }
        return normalized;
    }

    private static String normalize(String phone) {
        if (phone == null) {
            return "";
        }
        return phone.trim().replaceAll("[\\s\\-()]", "");
    }
}

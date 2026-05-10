package com.example.springboot.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.common.Constants;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.User;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.mapper.UserMapper;
import com.example.springboot.service.IUserService;
import com.example.springboot.utils.PasswordUtils;
import com.example.springboot.utils.SecurityUtils;
import com.example.springboot.utils.TokenUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    @Override
    public Account login(Account account) {
        User one = getOne(Wrappers.<User>lambdaQuery().eq(User::getUsername, account.getUsername()), false);
        if (one == null || !PasswordUtils.matches(account.getPassword(), one.getPassword())) {
            throw new ServiceException(Constants.CODE_605, "Incorrect username or password");
        }

        if (!PasswordUtils.isHashed(one.getPassword())) {
            one.setPassword(PasswordUtils.hash(account.getPassword()));
            updateById(one);
        }

        String role = SecurityUtils.ROLE_USER;
        BeanUtils.copyProperties(one, account);
        String token = TokenUtils.createToken(one.getId() + "-" + role, one.getPassword());
        account.setToken(token);
        account.setRole(role);
        account.setPassword(null);
        return account;
    }

    @Override
    public void register(Account account) {
        User one = getOne(Wrappers.<User>lambdaQuery().eq(User::getUsername, account.getUsername()), false);
        if (one != null) {
            throw new ServiceException(Constants.CODE_605, "User already exists");
        }
        one = new User();
        BeanUtils.copyProperties(account, one);
        one.setPassword(PasswordUtils.hash(account.getPassword()));
        save(one);
    }

    @Override
    public void updatePassword(Account account) {
        User one = getOne(Wrappers.<User>lambdaQuery().eq(User::getUsername, account.getUsername()), false);
        if (one == null || !PasswordUtils.matches(account.getPassword(), one.getPassword())) {
            throw new ServiceException(Constants.CODE_605, "Original password is incorrect");
        }
        if (StrUtil.equals(account.getPassword(), account.getNewPassword())) {
            throw new ServiceException(Constants.CODE_605, "New password must be different");
        }
        one.setPassword(PasswordUtils.hash(account.getNewPassword()));
        updateById(one);
    }
}

package com.example.springboot.controller;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.common.Constants;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.Comment;
import com.example.springboot.entity.User;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.service.ICommentService;
import com.example.springboot.service.IUserService;
import com.example.springboot.utils.SecurityUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/comment")
public class CommentController {

    @Resource
    private ICommentService commentService;
    @Resource
    private IUserService userService;

    @PostMapping
    public Result save(@RequestBody Comment comment) {
        Account currentUser = SecurityUtils.currentUser();
        if (comment.getId() == null) {
            comment.setUserId(currentUser.getId());
            comment.setTime(DateUtil.now());
            normalizeReply(comment);
        } else {
            Comment existing = requireExisting(comment.getId());
            SecurityUtils.requireOwnerOrAdmin(existing.getUserId());
            comment.setUserId(existing.getUserId());
            comment.setTime(existing.getTime());
            comment.setItemId(existing.getItemId());
            comment.setOriginId(existing.getOriginId());
        }
        commentService.saveOrUpdate(comment);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        Comment existing = requireExisting(id);
        SecurityUtils.requireOwnerOrAdmin(existing.getUserId());
        commentService.removeById(id);
        return Result.success();
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        SecurityUtils.requireAdmin();
        commentService.removeByIds(ids);
        return Result.success();
    }

    @GetMapping
    public Result findAll() {
        SecurityUtils.requireAdmin();
        return Result.success(commentService.list());
    }

    @GetMapping("/tree/{itemId}")
    public Result findTree(@PathVariable Integer itemId) {
        Map<Integer, User> userMap = userService.list().stream()
                .collect(Collectors.toMap(User::getId, u -> u, (a, b) -> a));
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getItemId, itemId);
        wrapper.orderByDesc(Comment::getId);
        List<Comment> allComments = commentService.list(wrapper).stream()
                .peek(comment -> Optional.ofNullable(userMap.get(comment.getUserId())).ifPresent(user -> {
                    comment.setNickname(user.getNickname());
                    comment.setAvatarUrl(user.getAvatarUrl());
                }))
                .collect(Collectors.toList());

        List<Comment> originList = allComments.stream()
                .filter(comment -> comment.getOriginId() == null)
                .collect(Collectors.toList());
        for (Comment origin : originList) {
            List<Comment> children = allComments.stream()
                    .filter(comment -> origin.getId().equals(comment.getOriginId()))
                    .collect(Collectors.toList());
            children.forEach(comment -> allComments.stream()
                    .filter(parent -> parent.getId().equals(comment.getPid()))
                    .findFirst()
                    .ifPresent(parent -> {
                        comment.setPUserId(parent.getUserId());
                        comment.setPNickname(parent.getNickname());
                    }));
            origin.setChildren(children);
        }
        return Result.success(originList);
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String keyword) {
        SecurityUtils.requireAdmin();
        LambdaQueryWrapper<Comment> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(Comment::getId);

        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(Comment::getContent, keyword);
        }

        return Result.success(commentService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

    private void normalizeReply(Comment comment) {
        if (comment.getPid() == null) {
            return;
        }
        Comment parent = requireExisting(comment.getPid());
        if (parent.getOriginId() == null) {
            comment.setOriginId(parent.getId());
            comment.setPid(null);
        } else {
            comment.setOriginId(parent.getOriginId());
        }
    }

    private Comment requireExisting(Integer id) {
        Comment existing = commentService.getById(id);
        if (existing == null) {
            throw new ServiceException(Constants.CODE_404, "Comment not found");
        }
        return existing;
    }
}

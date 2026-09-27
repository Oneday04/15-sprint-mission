package com.sprint.mission.discodeit.controller;

import com.sprint.mission.discodeit.dto.data.ChannelDto;
import com.sprint.mission.discodeit.dto.request.PrivateChannelCreateRequest;
import com.sprint.mission.discodeit.dto.request.PublicChannelCreateRequest;
import com.sprint.mission.discodeit.dto.request.PublicChannelUpdateRequest;
import com.sprint.mission.discodeit.dto.response.ChannelResponse;
import com.sprint.mission.discodeit.entity.Channel;
import com.sprint.mission.discodeit.service.ChannelService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.print.DocFlavor;
import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@Controller
@ResponseBody
@RequestMapping("/api/channel")
public class ChannelController {
    private final ChannelService channelService;

    // 채널 생성
    @PostMapping(path = "public")
    public ResponseEntity<Channel> create(
            @Valid @RequestBody PublicChannelCreateRequest request) {
        Channel channel = channelService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(channel);
    }

    // 비공개 채널 생성
    @PostMapping(path = "private")
    public ResponseEntity<Channel> create(
            @Valid @RequestBody PrivateChannelCreateRequest request) {
        Channel channel = channelService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(channel);
    }

    // 채널 수정
    @PatchMapping(path = "channelId")
    public ResponseEntity<Channel> update(
            @RequestParam("channelId") UUID channelId,
            @Valid @RequestBody PublicChannelUpdateRequest request) {
        Channel channel = channelService.update(channelId, request);
        return ResponseEntity.status(HttpStatus.ACCEPTED)
                .body(channel);
    }

    // 채널 삭제
    @DeleteMapping(path = "channelId")
    public ResponseEntity<ChannelResponse> delete(
            @RequestParam("channelId") UUID channelId) {
        channelService.delete(channelId);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    // 전체 조회
    @GetMapping
    public ResponseEntity<List<ChannelDto>> findAll(
            @PathVariable("userId") UUID userId) {
        List<ChannelDto> channels = channelService.findAllByUserId(userId);
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(channels);
    }
}

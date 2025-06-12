package co.jp.ulsystems.mahjong.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Room {
    private Long id;
    private String name;
    private String yearMonth;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

create database discodeit;
CREATE USER discodeit_user WITH PASSWORD 'discodeit1234';
GRANT ALL PRIVILEGES ON DATABASE discodeit TO discodeit_user;

-- discodeit schema (PostgreSQL)
-- 생성 순서: 참조 당하는 테이블 -> 참조하는 테이블

-- 1. binary_contents
CREATE TABLE binary_contents
(
    id           uuid PRIMARY KEY,
    created_at   timestamptz  NOT NULL,
    file_name    varchar(255) NOT NULL,
    size         bigint       NOT NULL,
    content_type varchar(100) NOT NULL,
    bytes        bytea        NOT NULL
);

-- 2. users
CREATE TABLE users
(
    id         uuid PRIMARY KEY,
    created_at timestamptz  NOT NULL,
    updated_at timestamptz,
    username   varchar(50)  NOT NULL UNIQUE,
    email      varchar(100) NOT NULL UNIQUE,
    password   varchar(60)  NOT NULL,
    profile_id uuid UNIQUE,
    CONSTRAINT fk_users_profile
        FOREIGN KEY (profile_id) REFERENCES binary_contents (id)
            ON DELETE SET NULL
);

-- 3. channels
CREATE TABLE channels
(
    id          uuid PRIMARY KEY,
    created_at  timestamptz NOT NULL,
    updated_at  timestamptz,
    name        varchar(100),
    description varchar(500),
    type        varchar(10) NOT NULL,
    CONSTRAINT chk_channels_type CHECK (type IN ('PUBLIC', 'PRIVATE'))
);

-- 4. user_statuses (users 1 : 1 user_statuses)
CREATE TABLE user_statuses
(
    id             uuid PRIMARY KEY,
    created_at     timestamptz NOT NULL,
    updated_at     timestamptz,
    user_id        uuid        NOT NULL UNIQUE,
    last_active_at timestamptz NOT NULL,
    CONSTRAINT fk_user_statuses_user
        FOREIGN KEY (user_id) REFERENCES users (id)
            ON DELETE CASCADE
);

-- 5. read_statuses (users N : M channels 를 풀어준 테이블)
CREATE TABLE read_statuses
(
    id           uuid PRIMARY KEY,
    created_at   timestamptz NOT NULL,
    updated_at   timestamptz,
    user_id      uuid        NOT NULL,
    channel_id   uuid        NOT NULL,
    last_read_at timestamptz NOT NULL,
    CONSTRAINT uk_read_statuses_user_channel UNIQUE (user_id, channel_id),
    CONSTRAINT fk_read_statuses_user
        FOREIGN KEY (user_id) REFERENCES users (id)
            ON DELETE CASCADE,
    CONSTRAINT fk_read_statuses_channel
        FOREIGN KEY (channel_id) REFERENCES channels (id)
            ON DELETE CASCADE
);

-- 6. messages
CREATE TABLE messages
(
    id         uuid PRIMARY KEY,
    created_at timestamptz NOT NULL,
    updated_at timestamptz,
    content    text,
    channel_id uuid        NOT NULL,
    author_id  uuid,
    CONSTRAINT fk_messages_channel
        FOREIGN KEY (channel_id) REFERENCES channels (id)
            ON DELETE CASCADE,
    CONSTRAINT fk_messages_author
        FOREIGN KEY (author_id) REFERENCES users (id)
            ON DELETE SET NULL
);

-- 7. message_attachments (messages N : M binary_contents 를 풀어준 테이블)
CREATE TABLE message_attachments
(
    message_id    uuid NOT NULL,
    attachment_id uuid NOT NULL,
    CONSTRAINT fk_message_attachments_message
        FOREIGN KEY (message_id) REFERENCES messages (id)
            ON DELETE CASCADE,
    CONSTRAINT fk_message_attachments_attachment
        FOREIGN KEY (attachment_id) REFERENCES binary_contents (id)
            ON DELETE CASCADE
);


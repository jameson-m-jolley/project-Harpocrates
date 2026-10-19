# Project Zooid — Email Transport Protocol (JSON)

## Overview

Messages are transported over existing email infrastructure. Each community/room
thread is an email conversation. JSON metadata is embedded in the email body
(or a MIME attachment) alongside the human-readable message text.

Every message is a JSON object with a top-level `type` field that determines
how the client interprets it.

## Envelope

```json
{
  "v": 1,
  "type": "message",
  "msg_id": "uuid-v4",
  "thread_id": "uuid-v4",
  "community_id": "uuid-v4",
  "room_id": "uuid-v4",
  "from": "user@example.com",
  "to": "community-list@example.com",
  "timestamp": "2026-10-19T12:00:00Z",
  "payload": { ... },
  "signature": "base64-encoded-ed25519-signature",
  "encrypted": false
}
```

### Envelope Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `v` | integer | Yes | Protocol version (currently `1`) |
| `type` | string | Yes | Message type (see below) |
| `msg_id` | string | Yes | Unique message ID (UUID v4) |
| `thread_id` | string | Yes | Email thread ID for grouping |
| `community_id` | string | Yes | Owning community |
| `room_id` | string | No | Specific room/channel within community |
| `from` | string | Yes | Sender email address |
| `to` | string | Yes | Recipient (list or individual) |
| `timestamp` | string | Yes | ISO 8601 UTC |
| `payload` | object | Yes | Type-specific payload |
| `signature` | string | No | Ed25519 signature of canonical JSON |
| `encrypted` | boolean | No | Whether payload is encrypted |

## Message Types

### `community.create`

Sent by the founder to bootstrap a community.

```json
{
  "type": "community.create",
  "payload": {
    "name": "Example Community",
    "description": "A place to talk",
    "owner_email": "founder@example.com",
    "settings": {
      "invite_only": true,
      "allow_anon": false
    }
  }
}
```

### `community.invite`

Sent by an owner/moderator to invite a user.

```json
{
  "type": "community.invite",
  "payload": {
    "invitee_email": "newuser@example.com",
    "inviter_email": "owner@example.com",
    "invite_token": "opaque-token",
    "expires": "2026-11-19T12:00:00Z"
  }
}
```

### `room.create`

Sent to create a channel or chat room within a community.

```json
{
  "type": "room.create",
  "payload": {
    "room_id": "uuid-v4",
    "name": "general",
    "room_type": "text",
    "description": "General discussion",
    "created_by": "owner@example.com",
    "is_voice": false,
    "permissions": {
      "read": ["members"],
      "write": ["members"]
    }
  }
}
```

### `message.send`

A standard chat message posted to a room.

```json
{
  "type": "message.send",
  "payload": {
    "body": "Hello world",
    "body_format": "markdown",
    "reply_to": "uuid-v4-or-null",
    "attachments": [
      {
        "filename": "image.png",
        "mime_type": "image/png",
        "size": 12345,
        "sha256": "hex-digest",
        "cid": "attachment-1"
      }
    ],
    "mentions": ["user2@example.com"]
  }
}
```

### `message.edit`

Edit a previously sent message.

```json
{
  "type": "message.edit",
  "payload": {
    "target_msg_id": "uuid-v4",
    "new_body": "Corrected text",
    "edit_reason": "typo"
  }
}
```

### `message.delete`

Soft-delete a message.

```json
{
  "type": "message.delete",
  "payload": {
    "target_msg_id": "uuid-v4",
    "reason": "user_request"
  }
}
```

### `room.join` / `room.leave`

Membership changes.

```json
{
  "type": "room.join",
  "payload": {
    "room_id": "uuid-v4",
    "user_email": "user@example.com"
  }
}
```

### `presence.update`

Optional online/away status.

```json
{
  "type": "presence.update",
  "payload": {
    "user_email": "user@example.com",
    "status": "online",
    "last_seen": "2026-10-19T12:00:00Z"
  }
}
```

## Encryption

When `encrypted` is `true`, `payload` contains:

```json
{
  "payload": {
    "ciphertext": "base64",
    "nonce": "base64",
    "kdf": "argon2id",
    "recipient_keys": [
      {
        "user_email": "user@example.com",
        "encrypted_key": "base64"
      }
    ]
  }
}
```

The actual application-layer payload is inside the decrypted plaintext.

## Email Mapping

- **Subject**: `[zooid] {community.name} — {room.name} ({type})`
- **Headers**: `X-Zooid-Type`, `X-Zooid-Msg-Id`, `X-Zooid-Thread-Id`
- **Body**: Plain-text fallback + JSON blob (either inline or as `application/zooid+json` MIME part)

## Client Pipeline

1. **Auth**: IMAP login, decrypt local store
2. **Fetch**: List threads matching `X-Zooid-Type` headers
3. **Cache**: Store messages in `.zooid/data.db` (30-day eviction or on delete/block)
4. **Grab Room**: Resolve `room_id` to thread
5. **Auth to Room**: Verify membership / invite token
6. **Decompress**: Huffman-decompress if needed, decrypt if encrypted

## Open Questions

- Should `type` use namespaced names like `zooid:community.create`?
- MIME attachment vs inline JSON body?
- How are large attachments hosted (email size limits)?
- Exact canonical JSON serialization for signatures
# API Integration Guide

This document describes the REST API contract expected by the Salon Customer App.  
The **client/backend team** must implement these endpoints. The mobile app is ready to consume them.

---

## Base URL

Set at build/run time:

```bash
flutter run --dart-define=API_BASE_URL=https://your-domain.com/v1
```

All paths below are relative to that base URL (e.g. `/auth/login` → `https://your-domain.com/v1/auth/login`).

---

## Authentication

### Headers (authenticated requests)

```
Authorization: Bearer {access_token}
Content-Type: application/json
Accept: application/json
```

### Response format

The app accepts either:

```json
{ "data": { ... } }
```

or a direct object/array at the root.

For auth responses, token fields supported:

- `token` / `access_token` / `accessToken`
- `refresh_token` / `refreshToken`
- User object under `user` or `customer`, or at root with `id` + `email`

---

## Endpoints

### POST `/auth/login`

**Body:**
```json
{
  "email": "user@example.com",
  "password": "secret123"
}
```

**Response:** user + tokens (see above).

**Errors:** `401` → invalid credentials

---

### POST `/auth/register`

**Body:**
```json
{
  "name": "Sara",
  "email": "user@example.com",
  "password": "secret123",
  "phone": "+966500000000"
}
```

**Response:** user + tokens.

**Errors:** `409` → email already exists

---

### POST `/auth/logout`

**Auth required.** Clears server session (optional).

---

### POST `/auth/forgot-password`

**Body:**
```json
{ "email": "user@example.com" }
```

**Response:** `200` — email sent (any success body).

---

### POST `/auth/refresh`

**Body:**
```json
{ "refresh_token": "..." }
```

**Response:**
```json
{
  "data": {
    "token": "new_access_token",
    "refresh_token": "new_refresh_token"
  }
}
```

Used automatically by the app when any request returns `401`.

---

## Salons

### GET `/salons`

**Query:** `q` (optional search string)

**Response:** array of salons:
```json
{
  "data": [
    {
      "id": "1",
      "name": "Glow Salon",
      "description": "...",
      "image_url": "https://...",
      "rating": 4.8,
      "address": "Riyadh",
      "distance": 1.2
    }
  ]
}
```

Also accepts `snake_case` or `camelCase` for `image_url` / `imageUrl`.

---

### GET `/salons/{id}`

**Response:** single salon object (same fields).

---

## Services

### GET `/services`

All services (optional).

### GET `/salons/{salonId}/services`

**Response:** array:
```json
{
  "data": [
    {
      "id": "1",
      "name": "Haircut",
      "price": 120,
      "description": "...",
      "duration_minutes": 45,
      "image_url": "https://...",
      "salon_id": "1"
    }
  ]
}
```

---

## Deals

### GET `/deals`

### GET `/salons/{salonId}/deals`

**Response:** array:
```json
{
  "data": [
    {
      "id": "1",
      "title": "20% Off",
      "discount_percent": 20,
      "description": "...",
      "image_url": "https://...",
      "valid_until": "2026-12-31T23:59:59Z",
      "salon_id": "1"
    }
  ]
}
```

---

## Bookings

### GET `/bookings/slots`

**Query:**
| Param | Example |
|-------|---------|
| `salon_id` | `1` |
| `service_id` | `2` |
| `date` | `2026-07-15` |

**Response:** array of slots:
```json
{
  "data": [
    { "time": "10:00", "available": true },
    { "time": "10:30", "available": false }
  ]
}
```

Or `{ "slots": [...] }`. Times can be ISO strings; app filters `available: false`.

---

### POST `/bookings`

**Auth required.**

**Body:**
```json
{
  "salon_id": "1",
  "service_id": "2",
  "date_time": "2026-07-15T10:00:00.000Z",
  "notes": "Optional note"
}
```

**Response:** booking object:
```json
{
  "data": {
    "id": "99",
    "salon_id": "1",
    "service_id": "2",
    "date_time": "2026-07-15T10:00:00.000Z",
    "status": "pending",
    "salon_name": "Glow Salon",
    "service_name": "Haircut",
    "notes": "..."
  }
}
```

**Status values:** `pending`, `confirmed`, `completed`, `cancelled`

---

### POST `/bookings/{id}/cancel`

**Auth required.**

---

## Reviews

### GET `/salons/{salonId}/reviews`

**Response:**
```json
{
  "data": [
    {
      "id": "1",
      "rating": 5,
      "user_name": "Sara",
      "comment": "Great service",
      "created_at": "2026-06-01T12:00:00Z",
      "salon_id": "1"
    }
  ]
}
```

---

### POST `/reviews`

**Auth required.**

**Body:**
```json
{
  "salon_id": "1",
  "rating": 5,
  "comment": "Optional text"
}
```

---

## Profile

### GET `/user/profile`

**Auth required.**

**Response:**
```json
{
  "data": {
    "id": "1",
    "name": "Sara",
    "email": "user@example.com",
    "phone": "+966...",
    "avatar_url": "https://..."
  }
}
```

---

### PUT `/user/profile`

**Auth required.**

**Body:** (partial update)
```json
{ "name": "New Name", "phone": "+966..." }
```

---

### GET `/user/bookings`

**Auth required.** Booking history — same shape as booking objects above.

---

## Push notifications

### POST `/user/fcm-token`

**Auth required.**

**Body:**
```json
{
  "token": "fcm_device_token",
  "platform": "android"
}
```

`platform`: `android` or `ios`

---

### DELETE `/user/fcm-token`

**Auth required.** Called on logout.

---

## Error format (recommended)

```json
{
  "message": "Human readable error",
  "error": "error_code"
}
```

The app maps:

| HTTP | App message key |
|------|-----------------|
| Network failure | `network_error` |
| 401 (login) | `invalid_credentials` |
| 409 (register) | `email_already_exists` |

---

## Testing checklist

After deploying the API:

1. `flutter run --dart-define=API_BASE_URL=YOUR_URL`
2. Register → login → logout
3. List salons, open detail, services, deals
4. Create booking, view history, cancel
5. Submit review
6. Edit profile
7. Login on device → verify FCM token POST succeeds
8. Send test push from Firebase Console

---

## Guest mode (no API)

When `API_BASE_URL` is not set (default `example.com`), the app shows an info banner on login.  
**Continue as guest** uses built-in demo data for browse-only flows (no real auth/booking).

---
title: "API errors, status codes, and rate limit guidance"
description: "HTTP status codes, V2 hardened error codes like SlippageExceeded and PriceStale, and tiered rate limit guidance for integrating with the QuantDesk gateway."
---

# Errors and rate limits

Practical guidance for integrating with the QuantDesk gateway. **Exact limits per route** evolve — treat Swagger responses as authoritative for your deployment.

## HTTP status codes you will see

| Code | Typical meaning | What to do |
| --- | --- | --- |
| `400` | Bad request / validation | Fix payload; compare body to Swagger schema |
| `401` | Unauthorized | Refresh auth; confirm wallet/session or Bearer token |
| `403` | Forbidden | Check roles/scopes for the route |
| `429` | Too many requests | Backoff and reduce cadence; respect `Retry-After` if present |
| `500` | Server error | Retry with backoff; surface correlation ID if your deployment adds one |
| `503` | Temporarily unavailable | Retry with longer backoff; check status/incidents |

## V2 hardened error codes

In addition to standard HTTP codes, the V2 engine may return specific business errors in the response body or as SBF program errors:

| Error code | Meaning | Context |
| :--- | :--- | :--- |
| `SlippageExceeded` | Trade band violation | Social trades must stay within 100bps of oracle price. |
| `PriceStale` | Oracle update timeout | Oracle must have updated in the last 20 seconds. |
| `InvalidOraclePrice` | Price sanity failure | Oracle reported price is negative or zero. |

## Rate limiting (conceptual)

The gateway applies **tiered limits** on sensitive surfaces (for example auth, trading-related routes, admin, webhooks, and general API traffic). Paths under `/api/` are affected differently — prefer steady request pacing over bursts.

### Client-side discipline

- Cache stable reads where safe  
- Debounce UI-driven spam  
- Use bulk endpoints when documented instead of fan-out  

## Parsing errors

Prefer structured JSON error bodies when returned; log status, route, and a short correlation fingerprint — never log secrets or full JWTs.

## Related

- [Authentication](./authentication)  
- [API overview](./api-overview)  
- [WebSockets overview](./websocket-overview)  

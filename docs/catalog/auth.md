# Access Control

- Go to: https://jwt.io/
- Use Algorithm HS256
- Enter the secret (Do not use "secret base64 encoded")

```json
{
  "realm_access": {
    "roles": [
      "operator"
    ]
  }
}
```
# Access Control

The catalog applies access control, which is currently only applied to write operations. Read operations are openly accessible.

## JWT for Development Access

For the development instance you can use a self-signed JWT. You will require a secret, which you will get via a different channel from the administrator of the catalog. You can create the JWT yourself:

- Go to: [https://jwt.io/](https://jwt.io/)
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

The result `<token>` will look something like this:

```bash
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib3BlcmF0b3IiXX19.PEqLVmGUAA4pkse7WLKKNFiGYbQ2wW_kwReocGxDUIc
```

You then use it in the HTTP header of your API requests:

```bash
Authorization: Bearer <token>
```



## Production Auth

Work in progress...
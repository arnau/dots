# pass notes

* https://github.com/zx2c4/password-store


There are two possible ways to validate each key:

*  Explicitly [sign each key](https://www.gnupg.org/gph/en/manual/x56.html)
*  Validate each key via the [web of trust](https://www.gnupg.org/gph/en/manual/x334.html)
    * (sign and trust the key of a single person who has already validated all other keys)


## Add recipients

Get the GPG key ID for the recipient:

```sh
gpg -K --keyid-format long
```

Append the ID to the relevant `.gpg-id` files.

## Remove recipients

Remove the ID to the relevant `.gpg-id` files.

## Re-encrypt

```sh
pass init $(cat .gpg-id)
```

Secondary stores need to be reencrypted after the global one.


## Issues

### no secret key

If you get an error `gpg: Decryption failed: No secret key` whilst decrypting
a password it may be because your public key has not been used to encrypt that
particular password.

### untrusted key

If you get an error `gpg: BB78B8A9: There is no assurance this key belongs to the named user`
you need to import the unknown keys and add sign them.

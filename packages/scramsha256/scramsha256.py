"""Compute the PostgreSQL SCRAM-SHA-256 hash of an input string."""

import argparse
import base64
import getpass
import hashlib
import hmac
import secrets
import sys


def scram_sha256(input: str, *, iterations: int, salt: bytes) -> str:
    salted = hashlib.pbkdf2_hmac("sha256", input.encode(), salt, iterations, 32)
    client_key = hmac.new(salted, b"Client Key", hashlib.sha256).digest()
    stored_key = hashlib.sha256(client_key).digest()
    server_key = hmac.new(salted, b"Server Key", hashlib.sha256).digest()

    def b64(b: bytes) -> str:
        return base64.b64encode(b).decode()

    return f"SCRAM-SHA-256${iterations}:{b64(salt)}${b64(stored_key)}:{b64(server_key)}"


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "input",
        nargs="?",
        help="Input to hash. If omitted, read from stdin (or prompt if TTY).",
    )
    ap.add_argument("-i", "--iterations", type=int, default=4096)
    ap.add_argument("--salt", help="Hex-encoded salt (default: 16 random bytes).")
    args = ap.parse_args()

    if args.input is not None:
        s = args.input
    elif not sys.stdin.isatty():
        s = sys.stdin.read()
    else:
        s = getpass.getpass("input: ")

    salt = bytes.fromhex(args.salt) if args.salt else secrets.token_bytes(16)
    print(scram_sha256(s, iterations=args.iterations, salt=salt))
    return 0


sys.exit(main())

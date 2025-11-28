#!/bin/sh

set -e

cd "$(dirname "$0")"

(cd web && pnpm install --frozen-lockfile)
(cd web && pnpm build)

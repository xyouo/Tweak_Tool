#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
VERSION="2.1.0"
BUILD="$ROOT/build"
STAGE="$BUILD/stage"
PACKAGE="$BUILD/com.kitten.tweaktool_${VERSION}_iphoneos-arm64e.deb"

rm -rf "$BUILD"
mkdir -p "$STAGE/DEBIAN"

install -Dm755 "$ROOT/src/tweaktool" "$STAGE/usr/local/bin/roothide-tweaktool"
ln -s roothide-tweaktool "$STAGE/usr/local/bin/tweaktool"
install -Dm644 "$ROOT/src/tweak_exclude_list" "$STAGE/usr/local/lib/tweak_exclude_list"
install -Dm755 "$ROOT/src/一键备份和恢复工具.sh" "$STAGE/usr/share/roothide-tweaktool/launcher.sh"
install -Dm644 "$ROOT/LICENSE" "$STAGE/usr/share/doc/roothide-tweaktool/LICENSE"

cat > "$STAGE/DEBIAN/control" <<EOF
Package: com.kitten.tweaktool
Name: 一键备份和恢复工具-RootHide
Version: $VERSION
Architecture: iphoneos-arm64e
Description: 适合 Dopamine2 RootHide 的插件及配置一键备份恢复工具
Maintainer: xyouo
Author: 预言小猫
Section: Tweaks
Depends: sudo, bash (>= 5.0.3-2), coreutils (>= 8.31-1), grep (>= 3.1-1), sed (>= 4.5-1), gawk (>= 4.2.1-1), tar (>= 1.33-1), dpkg
EOF

cat > "$STAGE/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e
docs=/var/mobile/Documents/tweak_tool
mkdir -p "$docs"
cp -f /usr/share/roothide-tweaktool/launcher.sh "$docs/一键备份和恢复工具.sh"
chown 501:501 "$docs" "$docs/一键备份和恢复工具.sh" 2>/dev/null || true
chmod 755 "$docs/一键备份和恢复工具.sh"
EOF
chmod 755 "$STAGE/DEBIAN/postinst"

cat > "$STAGE/DEBIAN/prerm" <<'EOF'
#!/bin/sh
rm -f "/var/mobile/Documents/tweak_tool/一键备份和恢复工具.sh"
EOF
chmod 755 "$STAGE/DEBIAN/prerm"

dpkg-deb --root-owner-group --build "$STAGE" "$PACKAGE"
printf '%s\n' "$PACKAGE"

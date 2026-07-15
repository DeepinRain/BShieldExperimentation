#!/system/bin/sh
resetprop -n -p init.svc.adb_root ""
resetprop -n -p init.svc.adbd "stopped"

val="$(getprop service.adb.root)"
if [ -n "$val" ]; then
    resetprop -n -p service.adb.root ""
fi

display_id="$(getprop ro.build.display.id)"
case "$display_id" in
    *test-keys*)
        new_display_id="$(printf '%s' "$display_id" | sed 's/test-keys/release-keys/g')"
        resetprop -n -p ro.build.display.id "$new_display_id"
        ;;
esac

build_keys="$(getprop ro.build.keys)"
case "$build_keys" in
    *test-keys*)
        new_build_keys="$(printf '%s' "$build_keys" | sed 's/test-keys/release-keys/g')"
        resetprop -n -p ro.build.keys "$new_build_keys"
        ;;
esac
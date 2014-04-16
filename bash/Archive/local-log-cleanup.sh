#!/bin/sh

echo ""
printf %s "Rotating Applescript log files:"
cd /Users/monty/Library/Logs
i=AppleScript-events.log

if [ -f "${i}" ]; then
    if [ -x /usr/bin/gzip ]; then gzext=".gz"; else gzext=""; fi
    if [ -f "${i}.3${gzext}" ]; then mv -f "${i}.3${gzext}" "${i}.4${gzext}"; fi
    if [ -f "${i}.2${gzext}" ]; then mv -f "${i}.2${gzext}" "${i}.3${gzext}"; fi
    if [ -f "${i}.1${gzext}" ]; then mv -f "${i}.1${gzext}" "${i}.2${gzext}"; fi
    if [ -f "${i}.0${gzext}" ]; then mv -f "${i}.0${gzext}" "${i}.1${gzext}"; fi
    if [ -f "${i}" ]; then mv -f "${i}" "${i}.0" && if [ -x /usr/bin/gzip ]; then gzip -9 "${i}.0"; fi; fi
#touch "${i}" && chmod 640 "${i}" && chown root:admin "${i}"
echo ""
fi
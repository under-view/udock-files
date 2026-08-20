export DISTRO="${oe_arg}"

if [[ -z "${DISTRO}" ]]; then
	echo "[x] DISTRO not set"
	exit 1
fi

for i in /etc/profile.d/*.sh; do
	if [[ -r "$i" ]]; then
		. "$i"
	fi
done
unset i

export OE_TERMINAL="screen -A"

export DL_DIR="${HOME}/downloads"
export SOURCES_DIR="${HOME}/sources"
export SSTATE_DIR="${HOME}/sstate-cache"
export BUILD_DIR="${HOME}/build-output/${DISTRO}"

core_count=$(nproc)
export PARALLEL_MAKE="-j $((core_count / 2))"
export BB_NUMBER_THREADS=$((core_count / 2))

export BB_ENV_PASSTHROUGH_ADDITIONS="DL_DIR SSTATE_DIR SOURCES_DIR"

export TEMPLATECONF="$(find "${SOURCES_DIR}" -type f -name "local.conf.sample" -printf "%h\n" | grep -w "${DISTRO}")"

mkdir -p "${BUILD_DIR}"
source "$(find "${SOURCES_DIR}" -type f -name "oe-init-build-env")" "${BUILD_DIR}"

#!/bin/bash

# get-bpf-tools.sh: 

Compile_bcc_original () {
	# Compile BPF Compiler Collection (bcc) from source archive.
	$sh_c 'git clone https://github.com/iovisor/bcc.git'
	$sh_c 'mkdir bcc/build; cd bcc/build'
	$sh_c 'cmake ..'
	$sh_c 'make'
	$sh_c 'sudo make install'
	$sh_c 'cmake -DPYTHON_CMD=python3 ..'
	$sh_c 'pushd src/python'
	$sh_c 'make'
	$sh_c 'sudo make install'
	$sh_c 'popd'
}

Get_bpftrace () {
	# Install bpftrace from upstream sources
	$sh_c 'sudo apt-get install -y libbpffcc-dev'
}

Compile_bcc () {
	# Compile BPF Compiler Collection (bcc) from source archive.
	$sh_c "git clone https://github.com/iovisor/bcc.git;
	mkdir bcc/build; cd bcc/build;
	cmake ..;
	make;
	sudo make install;
	cmake -DPYTHON_CMD=python3 ..;
	pushd src/python;
	make;
	sudo make install;
	popd
	"
}

Build_bcc_toolchain () {
	# Build necessary requirements for to compile bcc
	DEPS="bison build-essential cmake flex git libedit-dev libllvm7 llvm-7-dev libclang-7-dev python zlib1g-dev libelf-dev libfl-dev python3-distutils"
	$sh_c "sudo apt-get install -y --no-install-recommends $DEPS"
}

Prep_host () {
	# Update host and install etckeeper
	$sh_c 'sudo apt-get update -qq > /dev/null'
	$sh_c 'sudo apt-get upgrade -qq > /dev/null'
	if ! command -v etckeeper; then
		$sh_c 'sudo apt-get install -y etckeeper'
	fi
}

sh_c='echo'
RUN_IT="${RUN_IT:-}"
if [ -n "$RUN_IT" ]; then
	set -x
	echo "sh_c='sh -c'"
	set +x
fi

Prep_host
Build_bcc_toolchain && 
	Compile_bcc && 
	Get_bpftrace
